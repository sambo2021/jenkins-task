variable vbc_cidr {
  type        = string
  
}
variable public_subnet_1_cidr {
  type        = string
 
}
variable public_subnet_2_cidr {
  type        = string

}
variable private_subnet_1_cidr {
  type        = string
 
}
variable private_subnet_2_cidr {
  type        = string

}
variable az1 {
  type        = string

}
variable az2 {
  type        = string

}
variable region {
  type        = string

}
variable name {
  type        = string

}

variable ami {
  type  = string 
}

variable rds_password {
  type  = string 
}

variable rds_username{
  type = string 
}
variable db_name{
  type = string
}



## can pass this variable password at run time by using command 
# export TF_VAR_password=hamadamaslan -> it gonna search for word password and replace it by hamadamaslan in all files