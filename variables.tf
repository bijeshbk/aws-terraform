variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC."
  default     = "test-vpc"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet."
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet."
  default     = "us-east-1a"
}

variable "subnet_name" {
  description = "Name of the subnet."
  default     = "test-subnet"
}

variable "sg_ingress_from_port" {
  description = "Ingress rule from port."
  default     = 80
}

variable "sg_ingress_to_port" {
  description = "Ingress rule to port."
  default     = 80
}

variable "sg_ingress_protocol" {
  description = "Protocol for ingress."
  default     = "tcp"
}

variable "sg_ingress_cidr_blocks" {
  description = "CIDR blocks allowed for ingress."
  default     = ["0.0.0.0/0"]
}

variable "sg_egress_from_port" {
  description = "Egress rule from port."
  default     = 0
}

variable "sg_egress_to_port" {
  description = "Egress rule to port."
  default     = 0
}

variable "sg_egress_protocol" {
  description = "Protocol for egress."
  default     = "-1"
}

variable "sg_egress_cidr_blocks" {
  description = "CIDR blocks allowed for egress."
  default     = ["0.0.0.0/0"]
}

variable "sg_name" {
  description = "Name of the security group."
  default     = "my-sg"
}

variable "ami" {
  description = "The AMI to use for the EC2 instance."
  default     = "ami-0fff1b9a61dec8a5f"
}

variable "instance_type" {
  description = "The EC2 instance type."
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key pair to use for the EC2 instance."
  default     = "bk-keypair"
}

variable "role_name" {
  description = "The name of the IAM role to attach to the EC2 instance."
  default     = "ec2-role"
}

variable "role_policy_name" {
  description = "The name of the IAM role policy."
  default     = "ec2-role-policy"
}

variable "instance_profile_name" {
  description = "The name of the EC2 instance profile."
  default     = "ec2-instance-profile"
}

variable "instance_name" {
  description = "Name of the EC2 instance."
  default     = "ec2-instance-one"
}
# Auto Scaling Group variables
variable "asg_min_size" {
  description = "Minimum size of the Auto Scaling Group."
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group."
  default     = 2
}

variable "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group."
  default     = 1
}