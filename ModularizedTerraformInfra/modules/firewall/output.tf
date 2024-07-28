output "firewall_rules" {
  value = [
    google_compute_firewall.allow_custom.name,
    google_compute_firewall.allow_icmp.name,
    google_compute_firewall.allow_ssh.name
  ]
}
