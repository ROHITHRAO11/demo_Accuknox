provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
}

module "vpc_us_east_1" {
  source           = "./modules/vpc"
  providers        = { aws = aws.us_east_1 }
  # vpc_cidr         = "10.0.0.0/16"
  # name             = "us-east-1-vpc"
}

module "vpc_us_east_2" {
  source           = "./modules/vpc"
  providers        = { aws = aws.us_east_2 }
  # vpc_cidr         = "10.1.0.0/16"
  # name             = "us-east-2-vpc"
}

module "subnets_us_east_1" {
  source             = "./modules/subnets"
  providers          = { aws = aws.us_east_1 }
  vpc_id             = module.vpc_us_east_1.vpc_id
  public_subnet_cidrs  = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24"]
}

module "subnets_us_east_2" {
  source             = "./modules/subnets"
  providers          = { aws = aws.us_east_2 }
  vpc_id             = module.vpc_us_east_2.vpc_id
  public_subnet_cidrs  = ["10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24"]
}

module "igw_us_east_1" {
  source     = "./modules/internet_gateway"
  providers  = { aws = aws.us_east_1 }
  vpc_id     = module.vpc_us_east_1.vpc_id
  name       = "us-east-1-igw"
}

module "igw_us_east_2" {
  source     = "./modules/internet_gateway"
  providers  = { aws = aws.us_east_2 }
  vpc_id     = module.vpc_us_east_2.vpc_id
  name       = "us-east-2-igw"
}

module "nat_us_east_1" {
  source     = "./modules/nat_gateway"
  providers  = { aws = aws.us_east_1 }
  public_subnet_id = module.subnets_us_east_1.public_subnets[0]
  name       = "us-east-1-nat"
}

module "nat_us_east_2" {
  source     = "./modules/nat_gateway"
  providers  = { aws = aws.us_east_2 }
  public_subnet_id = module.subnets_us_east_2.public_subnets[0]
  name       = "us-east-2-nat"
}

module "security_group_us_east_1" {
  source   = "./modules/security_group"
  providers = { aws = aws.us_east_1 }
  vpc_id   = module.vpc_us_east_1.vpc_id
  name     = "us-east-1-sg"
}

module "security_group_us_east_2" {
  source   = "./modules/security_group"
  providers = { aws = aws.us_east_2 }
  vpc_id   = module.vpc_us_east_2.vpc_id
  name     = "us-east-2-sg"
}

module "ec2_instance_us_east_1" {
  source        = "./modules/ec2_instance"
  providers     = { aws = aws.us_east_1 }
  ami           = "ami-08a0d1e16fc3f61ea"
  instance_type = "t2.small"
  subnet_id     = module.subnets_us_east_1.public_subnets[0]
  sg_id         = module.security_group_us_east_1.sg_id
  name          = "us-east-1-instance"
}

module "ec2_instance_us_east_2" {
  source        = "./modules/ec2_instance"
  providers     = { aws = aws.us_east_2 }
  ami           = "ami-033fabdd332044f06"
  instance_type = "t2.small"
  subnet_id     = module.subnets_us_east_2.public_subnets[0]
  sg_id         = module.security_group_us_east_2.sg_id
  name          = "us-east-2-instance"
}

