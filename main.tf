provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}


resource "aws_internet_gateway" "internet_gw" {
  vpc_id =  aws_vpc.demo-vpc.id
}


resource "aws_route_table" "demo-route-table" {
  vpc_id = aws_vpc.demo-vpc.id
  

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "production-route-table"
  }
}

resource "aws_subnet" "demo_subset" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.1.0/24" 
  availability_zone = "us-east-1a"

  tags = {
    Name = "production-subnet"
  }
}


resource "aws_route_table_association" "demo-route-table-association" {
  subnet_id      = aws_subnet.demo_subset.id
  route_table_id = aws_route_table.demo-route-table.id

}


resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}


resource "aws_network_interface" "web_server" {
  subnet_id       = aws_subnet.demo_subset.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}
resource "aws_instance" "web_server" {
    ami    = "ami-0360c520857e3138f"
    instance_type = "t3.micro"
    availability_zone = "us-east-1a"
    key_name = "mykeydemo"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web_server.id
  }
    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo Deployed via Terraform >  /var/www/html/index.html'
                EOF
    tags = {
      Name = "Web-Server"
      }

}
resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.web_server.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [ aws_internet_gateway.internet_gw ]
}




