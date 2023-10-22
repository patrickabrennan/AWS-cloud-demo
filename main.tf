terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.12.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.77.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Create a VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = var.aws_vpc_cidr

  tags = {
    Name = "app-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "vpc_igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.aws_public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.aws_availability_zone

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
}

  #filter {
   # name   = "virtualization-type"
    #values = ["hvm"]
  #}

  owners = ["137112412989"] # Canonical
}

resource "aws_instance" "web" {
  #ami             = var.aws_ami
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = var.aws_instance_type
  #key_name        = var.aws_instance_key
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.sg.id]
  availability_zone = var.aws_availability_zone


  user_data = <<-EOF
    #!/bin/bash
    echo "Installing Pat's Google Maps Application"
    yum update -y
    yum install docker -y
    systemctl start docker 
    systemctl enable docker
    chmod 666 /var/run/docker.sock
    docker run --rm -d -p 80:80 -p 443:443 --name myweb patrickabrennan/myweb
    echo "Completed Installing Pat's Google Maps Application"
  EOF

  tags = {
    Name = "web_instance"
  }

  volume_tags = {
    Name = "web_instance"
  }
}



resource "aws_route53_record" "tf-demo" {
  zone_id = "Z08017432VFWFXO6IWHIK"
  name    = var.aws_dns_name
  type    = "A"
  ttl     = 300
  records = [aws_instance.web.public_ip]
}



/*

resource "aws_route53_record" "tf-gcp" {
  zone_id = "Z2ZGZTIWHCNAUW"
  name    = var.aws_dns_name
  type    = "A"
  ttl     = 5

  weighted_routing_policy {
    weight = 50
  }

  set_identifier = "tf-gcp"
   records        = ["67.83.151.68"]
#  records        = [google_compute_instance.default.network_interface.0.access_config.0.nat_ip]
}

resource "aws_route53_record" "tf-aws" {
  zone_id = "Z2ZGZTIWHCNAUW"
  name    = var.aws_dns_name
  type    = "A"
  ttl     = 5

  weighted_routing_policy {
    weight = 50
  }

  set_identifier = "tf-aws"
  records        = [aws_instance.web.public_ip]
}

*/

/*
#GOOGLE SECTION
resource "google_compute_network" "vpc_network" {
  name                    = "my-custom-mode-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "my-custom-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-west1"
  network       = google_compute_network.vpc_network.id
}

# Create a single Compute Engine instance
resource "google_compute_instance" "default" {
  name         = var.gcp_instance_name
  machine_type = var.machine_type
  zone         = "us-west1-a"
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = var.gcp_image
    }
  }

  # Install Docker and Patrick's Google Maps Application
  metadata_startup_script = "sudo apt-get update; curl -fsSL https://get.docker.com -o get-docker.sh; sudo sh ./get-docker.sh; sudo chmod 666 /var/run/docker.sock ; docker run --rm -d -p 80:80 -p 443:443 --name myweb patrickabrennan/myweb"
  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}

resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "docker" {
  name    = "app-firewall"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}
*/


// A variable for extracting the external IP address of the VM
//output "Web-server-URL" {
// value = join("",["http://",google_compute_instance.default.network_interface.0.access_config.0.nat_ip,":80"])
//output "google_ip_address" {
// value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
//}

