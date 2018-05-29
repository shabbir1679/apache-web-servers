variable "aws_region" {
  description = "Raise Assigned Region is US EAST 1 i.e., Virginia"
  default     = "us-east-1"
}

# Apache Web Server
variable "aws_amis" {
  default = {
    "us-east-1" = "ami-26950f4f"
  }
}

variable "availability_zones" {
  default     = "us-east-1a,us-east-1b"
  description = "List of availability zones"
}

 variable "key_name" {
  description = "AWS_Key"
}

variable "instance_type" {
  default     = "t1.micro"
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "3"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "5"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "3"
}
