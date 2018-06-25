variable count {}

variable gateway {}

variable "vpn_interface" {
  default = "wg0"
}

variable "bastion_host" {}

variable "ssh_user" {
  default = "root"
}

variable "ssh_private_key" {
  default = "~/.ssh/id_rsa.insecure"
}

variable "connections" {
  type = "list"
}

resource "null_resource" "default-gateway" {
  count = "${var.count}"

  triggers {
    count = "${var.count}"
  }

  connection {
    type                = "ssh"
    host                = "${element(var.connections, count.index)}"
    user                = "${var.ssh_user}"
    private_key         = "${file(var.ssh_private_key)}"
    agent               = false
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.ssh_user}"
    bastion_private_key = "${file(var.ssh_private_key)}"
    timeout             = "1m"
  }

  provisioner "file" {
    content     = "${element(data.template_file.default-route-vpn-service.*.rendered, count.index)}"
    destination = "/etc/systemd/system/default-route-vpn.service"
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl daemon-reload",
      "systemctl start default-route-vpn.service",
      "systemctl is-enabled default-route-vpn.service || systemctl enable default-route-vpn.service",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "${element(data.template_file.wireguard-config-script.*.rendered, count.index)}",
    ]
  }
}

data "template_file" "default-route-vpn-service" {
  count    = "${var.count}"
  template = "${file("${path.module}/templates/default-route-vpn.service")}"

  vars {
    gateway = "${var.gateway}"
  }
}

data "template_file" "wireguard-config-script" {
  count    = "${var.count}"
  template = "${file("${path.module}/scripts/wireguard_config.sh")}"

  vars {
    gateway       = "${var.gateway}"
    vpn_interface = "${var.vpn_interface}"
  }
}