  vbc_cidr  = "10.0.0.0/16"
    
  public_subnet_1_cidr  = "10.0.0.0/24"
                     
  public_subnet_2_cidr  = "10.0.1.0/24" 
                     
  private_subnet_1_cidr  = "10.0.2.0/24"
              
  private_subnet_2_cidr  = "10.0.3.0/24"
              
  az1  = "us-west-2a"
              
  az2  = "us-west-2b"
               
  region = "us-west-2"

  name = "iti-development"

  ami = "ami-0ee8244746ec5d6d4"

  db_name = "devdatabase"

  rds_password = "admin123456789"

  rds_username = "admin"
  
  #nat_count = 0 # for ex need nat to be installed in prod not dev workspace 
                # so at use count=0 at natgetway setup for dev 
                #       and count=1 at natgetway setup for prod

  ##command to apply hose values 
  # terraform apply --var-file=dev.tfvars

  ## those values could be changed if you gonna use in production and file shall be named prod.tfavrs
  ## and to make it possible to run those to environments in the same time 
  ## adding production environment 
  #  terraform workspace add prod
  #  terraform worlspace new prod 
  #  terraform workspace list  -> gonna show 2 workspaces default one and prod

              
  ## adding developing environment
  #  terraform workspace add dev
  #  terraform worlspace new dev 
  #  terraform workspace list  -> gonna show 3 workspaces default, prod and dev 

  ## to switch between workspaces 
  #  terraform switch workspace-name 
 