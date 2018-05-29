# Specifying the provider and access details
provider "aws" {
  access_key = ""
  secret_key = ""
  region = "${var.aws_region}"
}

resource "aws_elb" "raise-elb" {
  name = "raise-elb"

  # Creating an ELB to front the 3 instances
  availability_zones = ["${split(",", var.availability_zones)}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  
  # listener {
  #   instance_port     = 443
  #   instance_protocol = "https"
  #   lb_port           = 443
  #   lb_protocol       = "https"
  # }  

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 10
  }
}

resource "aws_iam_role" "s3_iam_role" {
  name = "s3_iam_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "s3.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3fullaccess-policy-attachment" {
    role = "${aws_iam_role.s3_iam_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_autoscaling_group" "raise-asg" {
  availability_zones   = ["${split(",", var.availability_zones)}"]
  name                 = "raise-asg"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.raise-lc.name}"
  load_balancers       = ["${aws_elb.raise-elb.name}"]

  tag {
    key                 = "Name"
    value               = "raise-asg"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "raise-lc" {
  name          = "raise-lc"
  image_id      = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"

  # Creating a security group
  security_groups = ["${aws_security_group.default.id}"]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from Shabbir" > /var/www/html/index.html
              sudo service httpd start
              chkconfig httpd on
              EOF
  key_name = "${var.key_name}"
   #key_name = "AWS_Key"
}


# Security Group - ingress traffic on port 80/443 is allowed.  Egress traffic is unrestricted.
resource "aws_security_group" "default" {
  name        = "raise_sg"
  description = "Used in the terraform"


  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change this to 173.53.101.79/32 after testing
  }
  

  # Egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

