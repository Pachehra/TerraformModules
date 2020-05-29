
module "production_rbast_nsg" {
  source = "./modules/rbast-nsg"

  nsg_name                 = "${var.production_bastion_subnet_name}-NSG"
  nsg_location             = "${var.location}"
  nsg_rsg                  = "${var.production_all_rsg}"
  nsg_subnet_prefix        = "${var.production_bastion_subnet_prefix}"

}
locals {
  production_rbast_nsg_id = "${module.production_rbast_nsg.nsg_id}"
}

output "production_rbast_nsg_id" {
  value = "${module.production_rbast_nsg.nsg_id}"
}

