provider "aws" {
    region = "eu-central-1"
}

#Get AWS availability zone
data "aws_availability_zones" "available" {}

#Get AMI ID latest Amazon linux
data "aws_ami" "latest_amazon_linux" {
    owners = ["amazon"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

#Add Security group for web-server
resource "aws_security_group" "web" {
    name        = "WebServer"
    description = "Allow http inbound traffic" 
    
    #Inside traffic
    #Dynamic blocks
    dynamic "ingress"  {
      for_each = ["80", "443", "22"]
       content {
         from_port   = ingress.value
         to_port     = ingress.value
         protocol    = "tcp"   #TCP, UDP or both
         cidr_blocks = ["0.0.0.0/0"]  #Allow access from all ipv4 addresses
       }
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
#Add ssh-key
resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = "YOUR PUBLIC SSH_KEY"
}

#Add aws launch configuration
resource "aws_launch_configuration" "web" { 
    name_prefix   = "WebServer-HA"
    image_id      = data.aws_ami.latest_amazon_linux.id
    #add ssh-key
    key_name= "ssh-key"
    instance_type = "t3.micro"
    #attach security group
    security_groups = [aws_security_group.web.id]
    #Add bash start script
    user_data = file("./user_data.sh")

    #Add rule. If will changes, then first - create new instance, next - remove old instance
    lifecycle {
      create_before_destroy = true
    }
}

#Add auto scalling group
resource "aws_autoscaling_group" "web" {
  name         = "WebServer-ASG-HA-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2
  max_size             = 2
  #How many IPs need to be for complete test
  min_elb_capacity     = 2
  vpc_zone_identifier  = [aws_default_subnet.default_eu1.id,aws_default_subnet.default_eu2.id]
  #Ping on Web page
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.web.name]

  dynamic "tag" {
      for_each = {
          #tag.key = "tag.value"
          Name = "WebServer-in-ASG"
          Owner = "Alexey"
      }
      content {
          key                 = tag.key
          value               = tag.value
          propagate_at_launch = true
      }
  }
  lifecycle {
      create_before_destroy = true
    }
}

resource "aws_elb" "web" {
    name               = "WebServer-HA-ELB"
    availability_zones = [data.aws_availability_zones.available.names[0],data.aws_availability_zones.available.names[1]]
    security_groups    = [aws_security_group.web.id]
    listener {
        lb_port           = 80
        lb_protocol       = "http"
        instance_port     = 80
        instance_protocol = "http"
    }
    health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 3
      #Check our webpage
      target              = "HTTP:80/"
      interval            = 10
    }
    tags = {
        Name = "WebServer-HA-ELB"
    }
}

resource "aws_default_subnet" "default_eu1" {
    availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_eu2" {
    availability_zone = data.aws_availability_zones.available.names[1]
}

output "web_lb_url" {
    value = aws_elb.web.dns_name
}
