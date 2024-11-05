variable "openstack_user_name" {
  description = "The username for the Tenant."
  default     = "mtorres"
}

variable "openstack_tenant_name" {
  description = "The name of the Tenant."
  default     = "mtorres"
}

variable "openstack_password" {
  description = "The password for the Tenant."
}

variable "openstack_domain_name" {
  description = "The name of the domain."
  default     = "users"
}

variable "openstack_auth_url" {
  description = "The endpoint url to connect to OpenStack."
}

variable "openstack_keypair" {
  description = "The keypair to be used."
  default     = "mtorres_ual"
}

variable "openstack_network_name" {
  description = "The name of the network to be used."
  default     = "desarrollo-net"
}

variable "openstack_subnet_name" {
  description = "The name of the subnet to be used."
  default     = "desarrollo-subnet"
}

variable "openstack_router_name" {
  description = "The name of the router to be used."
  default     = "desarrollo-router"
}

variable "openstack_external_network_name" {
  description = "The name of the external network to be used."
  default     = "external-network"
}



