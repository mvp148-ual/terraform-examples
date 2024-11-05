#Crear nodo mysql
resource "openstack_compute_instance_v2" "mysql" {
  name              = "mysql"
  image_name        = "ubuntu-24"
  availability_zone = "nova"
  flavor_name       = "m1.medium"
  key_pair          = var.openstack_keypair
  security_groups   = ["default"]
  network {
    name = var.openstack_network_name
  }
  user_data = file("install_mysql.sh")
}

#Crear nodo appserver
resource "openstack_compute_instance_v2" "appserver" {
  name              = "appserver"
  image_name        = "ubuntu-24"
  availability_zone = "nova"
  flavor_name       = "m1.medium"
  key_pair          = var.openstack_keypair
  security_groups   = ["default"]
  network {
    name = var.openstack_network_name
  }

  user_data = templatefile("${path.module}/install_appserver.tpl", { mysql_ip = openstack_compute_instance_v2.mysql.network.0.fixed_ip_v4 })

}

resource "openstack_networking_floatingip_v2" "mysql_ip" {
  pool = "external-network"
}

resource "openstack_networking_floatingip_v2" "appserver_ip" {
  pool = "external-network"
}

resource "openstack_compute_floatingip_associate_v2" "mysql_ip" {
  floating_ip = openstack_networking_floatingip_v2.mysql_ip.address
  instance_id = openstack_compute_instance_v2.mysql.id
}

resource "openstack_compute_floatingip_associate_v2" "appserver_ip" {
  floating_ip = openstack_networking_floatingip_v2.appserver_ip.address
  instance_id = openstack_compute_instance_v2.appserver.id
}

output "MySQL_Floating_IP" {
  value      = openstack_networking_floatingip_v2.mysql_ip.address
  depends_on = [openstack_networking_floatingip_v2.mysql_ip]
}

output "Appserver_Floating_IP" {
  value      = openstack_networking_floatingip_v2.appserver_ip.address
  depends_on = [openstack_networking_floatingip_v2.appserver_ip]
}
