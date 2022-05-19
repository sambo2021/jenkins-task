module "iti"{
    source = "./network"
     netowrk_vbc_cidr              = var.vbc_cidr
     netowrk_public_subnet_1_cidr  = var.public_subnet_1_cidr
     netowrk_public_subnet_2_cidr  = var.public_subnet_2_cidr 
     netowrk_private_subnet_1_cidr = var.private_subnet_1_cidr
     netowrk_private_subnet_2_cidr = var.private_subnet_2_cidr
     netowrk_az1                   = var.az1
     netowrk_az2                   = var.az2
     netowrk_name                  = var.name

}