# Network creation
#-----------------#
resource "google_compute_network" "dev-cicd-vpc" {
    auto_create_subnetworks = true
    description             = "VPC for secure CICD pipeline."
    mtu                     = 1460
    name                    = "dev-cicd-vpc"
    project                 = var.gcp_project_id
    routing_mode            = "REGIONAL"
}

# Firewall Rules
#-----------------#

## Custom firewall rules
resource "google_compute_firewall" "dev-cicd-vpc-allow-custom" {
    name                    = "dev-cicd-vpc-allow-custom"
    project                 = var.gcp_project_id
    network                 = google_compute_network.dev-cicd-vpc.name
    description             = "Allows connection from any source to any instance on the network using custom protocols."
    direction               = "INGRESS"
    priority                = 65534
    source_ranges           = ["10.128.0.0/9", "0.0.0.0/0"] 
    allow {
        protocol = "tcp" 
        ports    = ["80", "443", "465", "6443", "3000-10000", "30000-32767"]
    }
}

## ICMP
resource "google_compute_firewall" "dev-cicd-vpc-allow-icmp" {
    network     = google_compute_network.dev-cicd-vpc.name
    project     = var.gcp_project_id
    direction   = "INGRESS"
    priority    = 65534
    source_ranges = ["0.0.0.0/0"]
    name        = "dev-cicd-vpc-allow-icmp" 
    description = "Allows ICMP connections from any source to any instance on the network."
    allow {
        protocol = "icmp"
    }
}

## SSH
resource "google_compute_firewall" "dev-cicd-vpc-allow-ssh" {
    network     = google_compute_network.dev-cicd-vpc.name
    project     = var.gcp_project_id
    direction   = "INGRESS"
    priority    = 65534
    source_ranges = ["0.0.0.0/0"]
    name        = "dev-cicd-vpc-allow-ssh"
    description = "Allows TCP connections from any source to any instance on the network using port 22."
    allow {
        protocol = "tcp" 
        ports    = ["22"]
    }
}

#VM creation
#-----------------#

## Master Node VM
resource "google_compute_instance" "cluster-instances-node-master" {
    boot_disk {
        auto_delete = true
        device_name = "k8-cluster-nodes"

        initialize_params {
        image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240307b"
        size  = 25
        type  = "pd-balanced"
        }

        mode = "READ_WRITE"
    }

    can_ip_forward      = false
    deletion_protection = false
    enable_display      = false

    labels = {
        goog-ec-src = "vm_add-tf"
        node        = "master"
    }

    machine_type = "e2-medium"

    metadata = {
        startup-script = file("./scripts/masterVM.sh")
    }

    name = "cluster-instances-node-master"

    network_interface {
        access_config {
        network_tier = "STANDARD"
        }

        queue_count = 0
        stack_type  = "IPV4_ONLY"
        network     = google_compute_network.dev-cicd-vpc.name
    }

    scheduling {
        automatic_restart   = true
        on_host_maintenance = "MIGRATE"
        preemptible         = false
        provisioning_model  = "STANDARD"
    }

    service_account {
        email  = var.gcp_service_account_email
        scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    }

    shielded_instance_config {
        enable_integrity_monitoring = true
        enable_secure_boot          = false
        enable_vtpm                 = true
    }

    tags = ["http-server", "https-server", "lb-health-check"]
    zone = "asia-south1-c"
}

## Slave Node VM (2 nodes)
resource "google_compute_instance" "cluster-instances-node-slave" {
    count = 2

    boot_disk {
        auto_delete = true
        device_name = "k8-cluster-nodes"

        initialize_params {
        image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240307b"
        size  = 25
        type  = "pd-balanced"
        }

        mode = "READ_WRITE"
    }

    can_ip_forward      = false
    deletion_protection = false
    enable_display      = false

    labels = {
        goog-ec-src = "vm_add-tf"
        node        = "slave0${count.index + 1}"
    }

    machine_type = "e2-medium"

    metadata = {
        startup-script = file("./scripts/slaveVM.sh")
    }

    name = "cluster-instances-node-slave0${count.index + 1}"

    network_interface {
        access_config {
        network_tier = "STANDARD"
        }

        queue_count = 0
        stack_type  = "IPV4_ONLY"
        network     = google_compute_network.dev-cicd-vpc.name
    }

    scheduling {
        automatic_restart   = true
        on_host_maintenance = "MIGRATE"
        preemptible         = false
        provisioning_model  = "STANDARD"
    }

    service_account {
        email  = var.gcp_service_account_email
        scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    }

    shielded_instance_config {
        enable_integrity_monitoring = true
        enable_secure_boot          = false
        enable_vtpm                 = true
    }

    tags = ["http-server", "https-server", "lb-health-check"]
    zone = "asia-south1-c"
}

# Sonarqube VM
#---------------#
resource "google_compute_instance" "sonarqube" {
    boot_disk {
        auto_delete = true
        device_name = "k8-cluster-nodes"

        initialize_params {
        image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240307b"
        size  = 20
        type  = "pd-balanced"
        }

        mode = "READ_WRITE"
    }

    can_ip_forward      = false
    deletion_protection = false
    enable_display      = false

    labels = {
        goog-ec-src = "vm_add-tf"
        sonarqube   = ""
    }

    machine_type = "e2-medium"

    metadata = {
        startup-script = file("./scripts/sonarqube.sh")
    }

    name = "sonarqube"

    network_interface {
        access_config {
        network_tier = "STANDARD"
        }

        queue_count = 0
        stack_type  = "IPV4_ONLY"
        network     = google_compute_network.dev-cicd-vpc.name
    }

    scheduling {
        automatic_restart   = true
        on_host_maintenance = "MIGRATE"
        preemptible         = false
        provisioning_model  = "STANDARD"
    }

    service_account {
        email  = var.gcp_service_account_email
        scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    }

    shielded_instance_config {
        enable_integrity_monitoring = true
        enable_secure_boot          = false
        enable_vtpm                 = true
    }

    tags = ["http-server", "https-server", "lb-health-check"]
    zone = "asia-southeast1-a"
}
#Access SonarQube by opening a web browser and navigating to http://VmIP:9000

# Nexus VM
#---------------#
resource "google_compute_instance" "nexus" {
    boot_disk {
        auto_delete = true
        device_name = "k8-cluster-nodes"

        initialize_params {
        image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240307b"
        size  = 20
        type  = "pd-balanced"
        }

        mode = "READ_WRITE"
    }

    can_ip_forward      = false
    deletion_protection = false
    enable_display      = false

    labels = {
        goog-ec-src = "vm_add-tf"
        nexus       = ""
    }

    machine_type = "e2-medium"

    metadata = {
        startup-script = file("./scripts/nexus.sh")
    }

    name = "nexus"

    network_interface {
        access_config {
        network_tier = "STANDARD"
        }

        queue_count = 0
        stack_type  = "IPV4_ONLY"
        network     = google_compute_network.dev-cicd-vpc.name
    }

    scheduling {
        automatic_restart   = true
        on_host_maintenance = "MIGRATE"
        preemptible         = false
        provisioning_model  = "STANDARD"
    }

    service_account {
        email  = var.gcp_service_account_email
        scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    }

    shielded_instance_config {
        enable_integrity_monitoring = true
        enable_secure_boot          = false
        enable_vtpm                 = true
    }

    tags = ["http-server", "https-server", "lb-health-check"]
    zone = "asia-southeast1-a"
}
# Nexus will be accessible on your host machine at http://IP:8081.

# Jenkins VM
#-----------------#

resource "google_compute_instance" "jenkins" {
    boot_disk {
        auto_delete = true
        device_name = "jenkins-vm"

        initialize_params {
        image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240307b"
        size  = 30
        type  = "pd-balanced"
        }

        mode = "READ_WRITE"
    }

    can_ip_forward      = false
    deletion_protection = false
    enable_display      = false

    labels = {
        goog-ec-src = "vm_add-tf"
        jenkins     = ""
    }

    machine_type = "e2-standard-2"

    metadata = {
        startup-script = file("./scripts/jenkins.sh")
    }

    name = "jenkins"

    network_interface {
        access_config {
        network_tier = "STANDARD"
        }

        queue_count = 0
        stack_type  = "IPV4_ONLY"
        network     = google_compute_network.dev-cicd-vpc.name
    }

    scheduling {
        automatic_restart   = true
        on_host_maintenance = "MIGRATE"
        preemptible         = false
        provisioning_model  = "STANDARD"
    }

    service_account {
        email  = var.gcp_service_account_email
        scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    }

    shielded_instance_config {
        enable_integrity_monitoring = true
        enable_secure_boot          = false
        enable_vtpm                 = true
    }

    tags = ["http-server", "https-server", "lb-health-check"]
    zone = "asia-southeast1-b"
}

# Monitoring VM
#-----------------#

resource "google_compute_instance" "monitor" {
    boot_disk {
        auto_delete = true
        device_name = "monitoring"

        initialize_params {
        image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240307b"
        size  = 20
        type  = "pd-balanced"
        }

        mode = "READ_WRITE"
    }

    can_ip_forward      = false
    deletion_protection = false
    enable_display      = false

    labels = {
        goog-ec-src = "vm_add-tf"
        monitor     = ""
    }

    machine_type = "e2-standard-2"

    metadata = {
        startup-script = file("./scripts/monitoring.sh")
    }

    name = "monitor"

    network_interface {
        access_config {
        network_tier = "PREMIUM"
        }

        queue_count = 0
        stack_type  = "IPV4_ONLY"
        network     = google_compute_network.dev-cicd-vpc.name
    }

    scheduling {
        automatic_restart   = true
        on_host_maintenance = "MIGRATE"
        preemptible         = false
        provisioning_model  = "STANDARD"
    }

    service_account {
        email  = var.gcp_service_account_email
        scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    }

    shielded_instance_config {
        enable_integrity_monitoring = true
        enable_secure_boot          = false
        enable_vtpm                 = true
    }

    tags = ["http-server", "https-server", "lb-health-check"]
    zone = "asia-south2-a"
}
