#Use AWS provider
provider "aws" {
    #Access_key and Secret_key storaged in local environments
    region = "eu-central-1"
}

#Add Elastic IP
resource "aws_eip" "my_static_ip" {
  #Add this eip to VM my_webserver
  instance = aws_instance.my_webserver.id
}

#Add VM
resource "aws_instance" "my_webserver" {
    #Image ID. We can see ID in AWS
    ami                    = "ami-03a71cec707bfc3d7"  #Amazon Linux AMI
    instance_type          = "t3.micro"
    vpc_security_group_ids = [aws_security_group.allow_http.id]  #Add security group
    #Start script after create VM
    #Use template file
    #templatefile("file_path", {envs for template}
    user_data              = templatefile("user_data.sh.tpl", {
      f_name = "Alexey",
      names = ["Vasya", "John", "Kate", "Sasha"]
    })

    tags = {
      Name  = "Web-server test test"
      Owner = "Alexey"
    }
    
    #If we edited parametrs VM, AWS first started provision new Instance and next destroy old instance
    lifecycle {
      create_before_destroy = true
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

// #Add output web-server instans-id 
// output "webserver_instance_id" {
//   value = aws_instance.my_webserver.id
// }

// #Add output web-server public IP
// output "webserver_public_ip" {
//   value = aws_eip.my_static_ip.public_ip
// }