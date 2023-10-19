aws_region             = "us-east-2"
aws_instance_type      = "t2.small"
aws_instance_key       = "TerraForm"
aws_vpc_cidr           = "178.0.0.0/16"
aws_public_subnet_cidr = "178.0.10.0/24"
aws_availability_zone  = "us-east-1a"
aws_ami                = "ami-0f34c5ae932e6f0e4"

aws_dns_name = "tf-demo"


gcp_machine_type  = "f1-micro"
gcp_image         = "debian-cloud/debian-11"
gcp_instance_name = "tf-demo"
gcp_project_id    = "sigma-lane-395917"
