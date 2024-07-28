locals {
  instance_configs = [
    {
      name        = "master"
      machine_type = "e2-medium"
      script      = "masterVM.sh"
      labels      = { node = "master" }
      zone        = "asia-south1-c"
    },
    {
      name        = "slave01"
      machine_type = "e2-medium"
      script      = "slaveVM.sh"
      labels      = { node = "slave01" }
      zone        = "asia-south1-c"
    },
    {
      name        = "slave02"
      machine_type = "e2-medium"
      script      = "slaveVM.sh"
      labels      = { node = "slave02" }
      zone        = "asia-south1-c"
    },
    {
      name        = "sonarqube"
      machine_type = "e2-medium"
      script      = "sonarqube.sh"
      labels      = { sonarqube = "" }
      zone        = "asia-southeast1-a"
    },
    {
      name        = "nexus"
      machine_type = "e2-medium"
      script      = "nexus.sh"
      labels      = { nexus = "" }
      zone        = "asia-southeast1-a"
    },
    {
      name        = "jenkins"
      machine_type = "e2-standard-2"
      script      = "jenkins.sh"
      labels      = { jenkins = "" }
      zone        = "asia-southeast1-b"
    },
    {
      name        = "monitor"
      machine_type = "e2-standard-2"
      script      = "monitoring.sh"
      labels      = { monitor = "" }
      zone        = "asia-south2-a"
    }
  ]
}

resource "google_compute_instance" "instances" {
  for_each = { for inst in local.instance_configs : inst.name => inst }

  name         = "cluster-instances-node-${each.value.name}"
  machine_type = each.value.machine_type
  zone         = each.value.zone

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

  labels = merge({
    goog-ec-src = "vm_add-tf"
  }, each.value.labels)

  metadata = {
    startup-script = file("./scripts/${each.value.script}")
  }

  network_interface {
    access_config {
      network_tier = "STANDARD"
    }
    network = var.gcp_network_name
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
}
