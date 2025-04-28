provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "node_server" {
  image  = "ubuntu-22-04-x64"
  name   = "node-server"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = [var.ssh_fingerprint]
}
