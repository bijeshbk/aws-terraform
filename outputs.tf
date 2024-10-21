output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.one.id
}

output "subnet_id" {
  description = "ID of the subnet."
  value       = aws_subnet.two.id
}

# output "instance_public_ip" {
#   description = "Public IP of the EC2 instance."
#   value       = aws_instance.my_instance.public_ip
# }



output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_launch_template.ec2_launch_template.id
}

output "iam_role_name" {
  description = "IAM role name associated with the EC2 instance."
  value       = aws_iam_role.ec2_role.name
}

output "iam_instance_profile" {
  description = "Instance profile name associated with the EC2 instance."
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "auto_scaling_group_name" {
  description = "Name of the Auto Scaling group."
  value       = aws_autoscaling_group.ec2_asg.name
}
