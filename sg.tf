resource "aws_security_group" "sg" {
  name        = "allow_ssh_http"
  description = "Allow ssh http https inbound traffic"
  vpc_id      = aws_vpc.app_vpc.id
}

resource "aws_security_group_rule allow_ssh {
    type            = ingress 
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_group_id = "aws_security_group.sg.id"
  }

resource "aws_security_group_rule allow_http {
    type            = ingress 
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_group_id = "aws_security_group.sg.id"
  }

resource "aws_security_group_rule allow_https {
    type            = ingress 
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_group_id = "aws_security_group.sg.id"
  }
/*
  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_group_id = "aws_security_group.sg.id"
  }

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_group_id = "aws_security_group.sg.id"  
}
*/
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}
