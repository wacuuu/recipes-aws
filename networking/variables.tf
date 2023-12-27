variable "vpc_cidr" {
  type        = string
  description = "CIDR of VPC to be created in the format x.x.x.x/x"
  default     = "10.0.0.0/16"
}
variable "number_of_subnets" {
  type        = number
  description = "Number of subnets to create in the VPC, the last one will be public, with autoassigned public ips"
  default     = 8
}
variable "force_one_zone" {
  type        = bool
  description = "If true, all subnets will by default force instances to live in single AZ. Useful to cut cost"
  default     = false
}
variable "vpn_url" {
  type        = string
  description = "If set, will be passed to VPN to set as VPN address"
  default     = ""
}
variable "create_instance" {
  type        = number
  default     = 0
  description = "Create number of instances in private subnet"
}
variable "create_devbox" {
  type        = bool
  default     = true
  description = "Whether to create and configure devbox"
}

variable "devbox_type" {
  type        = string
  default     = "t3.medium"
  description = "Size of devbox to create"
}
