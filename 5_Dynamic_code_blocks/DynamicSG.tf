#Use AWS provider
provider "aws" {
    #Access_key and Secret_key storaged in local environments
    region = "eu-central-1"
}

#Add Security group for web-server
resource "aws_security_group" "allow_http" {
    name        = "WebServer"
    description = "Allow http inbound traffic" 
    
    #Inside traffic
    #Dynamic blocks
    dynamic "ingress"  {
      for_each = ["80", "443", "8080", "8443", "9092", "8301"]
       content {
         from_port   = ingress.value
         to_port     = ingress.value
         protocol    = "tcp"   #TCP, UDP or both
         cidr_blocks = ["0.0.0.0/0"]  #Allow access from all ipv4 addresses
       }
    }

    #Allow ssh
    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"   #TCP, UDP or both
      cidr_blocks = ["10.10.0.0/16"]  #allow access of ssh from addresses 10.10.0.0/16
    }
    
    #Outside traffic
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }   

     tags = {
      Name  = "Dynamic SG for Web-server"
      Owner = "Alexey"
    } 
}

