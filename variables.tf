variable "name" {
  description = "Name"
  type        = string
  default     = "pb-name"
}

#variable "subnet_ids" {
#  type = list(string)
#}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}

variable "aws_region" {
  default = "us-east-1"
}
variable "aws_instance_type" {}
variable "aws_instance_key" {}
variable "aws_vpc_cidr" {}
variable "aws_public_subnet_cidr" {}

variable "aws_availability_zone" {
  type = string
}

variable "aws_ami" {
  type = string
}

variable "aws_dns_name" {
  type = string
}

variable "enable_dns_hostnames" {
  type = string
}

variable "Environment" {
  type = string
}

#GCP Variables
variable "gcp_region" {
  type    = string
  default = "us-east5"
}

variable "gcp_project_id" {
  type = string
}

variable "machine_type" {
  type    = string
  default = "f1-micro"
}

variable "gcp_image" {
  type    = string
  default = "debian-cloud/debian-11"
}

variable "gcp_instance_name" {
  type = string
}
