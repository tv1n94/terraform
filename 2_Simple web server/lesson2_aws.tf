#Use AWS provider
provider "aws" {
    #Access_key and Secret_key storaged in local environments
    region = "eu-central-1"

}

#Add VM
resource "aws_instance" "my_webserver" {
    #Image ID. We can see ID in AWS
    ami                    = "ami-03a71cec707bfc3d7"  #Amazon Linux AMI
    instance_type          = "t3.micro"
    vpc_security_group_ids = [aws_security_group.allow_http.id]  #Add security group
    #Start script after create VM
    #In Script don't use spaces before string
    user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF

    tags = {
      Name  = "Web-server Build by Terraform"
      Owner = "Alexey"
    }
}

#Add Security group for web-server
resource "aws_security_group" "allow_http" {
    name        = "WebServer"
    description = "Allow http inbound traffic" 
    
    #Inside traffic
    #We can create multiple rules
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"   #TCP, UDP or both
      cidr_blocks = ["0.0.0.0/0"]  #add a CIDR block here 
    }
    
    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"   #TCP, UDP or both
      cidr_blocks = ["0.0.0.0/0"]  #add a CIDR block here 
    }
    
    #Outside traffic
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }   

    tags = {
      Name  = "SG for Web-server"
      Owner = "Alexey"
    } 
}

