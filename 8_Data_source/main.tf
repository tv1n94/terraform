provider "aws" {}

#Get availability zones from AWS
data "aws_availability_zones" "working" {}

#Get user identificator from AWS
data "aws_caller_identity" "current" {}

#Get aws region in we working
data "aws_region" "current" {}

#Get ID all VPCs in our region
data "aws_vpcs" "my_vpcs" {}

#Get aws vpc id 
data "aws_vpc" "prod" {
   tags = {
       Name = "prod"
   }
}

#Create subnet 1 in use VPC ID
resource "aws_subnet" "prod_subnet_1" {
    vpc_id             = data.aws_vpc.prod.id
    availability_zone  = data.aws_availability_zones.working.names[0]
    cidr_block         = "172.31.48.0/24"
    tags = {
        Name    =  "Subnet_1 in ${data.aws_availability_zones.working.names[0]}"
        Account =  "Subnet in account ${data.aws_caller_identity.current.account_id}"
        Region  =  "${data.aws_region.current.description}"
    }   
}

#Create subnet 2 in use VPC ID
resource "aws_subnet" "prod_subnet_2" {
    vpc_id             = data.aws_vpc.prod.id
    availability_zone  = data.aws_availability_zones.working.names[0]
    cidr_block         = "172.31.49.0/24"
    tags = {
        Name    =  "Subnet_1 in ${data.aws_availability_zones.working.names[0]}"
        Account =  "Subnet in account ${data.aws_caller_identity.current.account_id}"
        Region  =  "${data.aws_region.current.description}"
    }   
}

output "prod_vpc_id" {
    value = data.aws_vpc.prod.id
}

output "prod_vpc_cidr" {
    value = data.aws_vpc.prod.cidr_block
}


#Output second availability zone from AWS
output "data_aws_availability_zones" {
    value = data.aws_availability_zones.working.names[1]
}

#Output user identificator (Account ID) from AWS
output "data_aws_caller_identity" {
    value = data.aws_caller_identity.current.account_id
}

#Output aws region current name (Ex: "eu-central-1")
output "data_aws_region_name" {
    value = data.aws_region.current.name
}

#Output aws region description name (Ex: "Europe (Frankfurt)")
output "data_aws_region_description" {
    value = data.aws_region.current.description
}

#Output ID all VPCs in our region
output "data_aws_vpcs_my_vpcs" {
    value = data.aws_vpcs.my_vpcs.ids 
}