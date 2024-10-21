provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "one" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "two" {
  vpc_id            = aws_vpc.one.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = var.subnet_name
  }
}

resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.one.id

  ingress {
    from_port   = var.sg_ingress_from_port
    to_port     = var.sg_ingress_to_port
    protocol    = var.sg_ingress_protocol
    cidr_blocks = var.sg_ingress_cidr_blocks
  }

  egress {
    from_port   = var.sg_egress_from_port
    to_port     = var.sg_egress_to_port
    protocol    = var.sg_egress_protocol
    cidr_blocks = var.sg_egress_cidr_blocks
  }

  tags = {
    Name = var.sg_name
  }
}

resource "aws_iam_role" "ec2_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2_role_policy" {
  name = var.role_policy_name
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      }
    ]
  })
}


resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.ec2_role.name
}

# # Launch Configuration for EC2 instances in Auto Scaling Group
# resource "aws_launch_configuration" "ec2_launch_configuration" {
#   name_prefix                 = "ec2-lc-"
#   image_id                    = var.ami
#   instance_type               = var.instance_type
#   security_groups             = [aws_security_group.my_sg.id]
#   iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
#   key_name                    = var.key_name
#   associate_public_ip_address = true
  

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               echo "Hello, World!" > /home/ec2-user/hello.txt
#               EOF

#   lifecycle {
#     create_before_destroy = true
#   }
# }
resource "aws_launch_template" "ec2_launch_template" {
  name_prefix                 = "ec2-lt-"
  image_id                    = var.ami
  instance_type               = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  network_interfaces {
    security_groups = [aws_security_group.my_sg.id]
    associate_public_ip_address = true  # This associates a public IP if needed
  }

  key_name                    = var.key_name
  user_data = base64encode(<<-EOF
               #!/bin/bash
                sudo yum update -y
                sudo yum install -y httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "Hello from BK" > /var/www/html/index.html
                EOF
)
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name
    }
  }
}
# Auto Scaling Group
resource "aws_autoscaling_group" "ec2_asg" {
  desired_capacity     = var.asg_desired_capacity
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  vpc_zone_identifier  = [aws_subnet.two.id]

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
}

# # Auto Scaling Group
# resource "aws_autoscaling_group" "ec2_asg" {
#   launch_configuration = aws_launch_configuration.ec2_launch_configuration.id
#   min_size             = var.asg_min_size
#   max_size             = var.asg_max_size
#   desired_capacity     = var.asg_desired_capacity
#   vpc_zone_identifier  = [aws_subnet.two.id]

#   tag {
#     key                 = "Name"
#     value               = var.instance_name
#     propagate_at_launch = true
#   }
# }

# resource "aws_instance" "my_instance" {
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.two.id
#   vpc_security_group_ids = [aws_security_group.my_sg.id]
#   key_name               = var.key_name

#   iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               echo "Hello, World!" > /home/ec2-user/hello.txt
#               EOF

#   tags = {
#     Name = var.instance_name
#   }
# }
