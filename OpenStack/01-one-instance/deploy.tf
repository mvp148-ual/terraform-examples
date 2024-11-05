#Crear nodo tf_vm
resource "openstack_compute_instance_v2" "tf_vm" {
  name              = "tf_vm"
  image_name        = "ubuntu-24"
  availability_zone = "nova"
  flavor_name       = "m1.medium"
  key_pair          = var.openstack_keypair
  security_groups   = ["default"]
  network {
    name = var.openstack_network_name
  }
}

resource "openstack_networking_floatingip_v2" "tf_vm_ip" {
  pool = "external-network"
}

resource "openstack_compute_floatingip_associate_v2" "tf_vm_ip" {
  floating_ip = openstack_networking_floatingip_v2.tf_vm_ip.address
  instance_id = openstack_compute_instance_v2.tf_vm.id
}

output "tf_vm_Floating_IP" {
  value      = openstack_networking_floatingip_v2.tf_vm_ip.address
  depends_on = [openstack_networking_floatingip_v2.tf_vm_ip]
}

