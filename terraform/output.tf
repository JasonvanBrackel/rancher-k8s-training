output "k3s-ip" {
  value = module.k3s-nodes.publicIps
}

output "rancher-ip" {
  value = module.rancher-nodes.publicIps
}