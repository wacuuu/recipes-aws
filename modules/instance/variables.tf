variable "instance_name" {
  nullable    = false
  description = "Instance name"
}

variable "vpc_id" {
  nullable    = false
  description = "VPC ID"
}
variable "security_group_id" {
  default     = ""
  description = "Security group ID, if not provided, a group open to everything will be created"
}
variable "ami_id" {
  default     = ""
  description = "AMI ID, if not provided, latest ubuntu will ne ised"
}
variable "instance_type" {
  default = "t3.medium"
}
variable "subnet_id" {
  nullable = false
}
variable "key_name" {
  nullable = false
}
variable "public_ip" {
  default = false

}
variable "root_size" {
  default = 32

}
