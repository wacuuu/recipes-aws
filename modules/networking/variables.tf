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

variable "number_of_public_subnets" {
  default     = 3
  type        = number
  description = "Number of public networks to create"
}
variable "use_openvpn" {
  default     = false
  description = "Use OpenVPN as connection provider"
}
variable "use_tailscale" {
  default     = false
  description = "Use Tailscale as connection provider"
}
variable "tailscale_auth" {
  default = ""
}
