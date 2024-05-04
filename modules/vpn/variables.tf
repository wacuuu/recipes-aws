variable "vpn_ami" {
  default = "ami-0f6f5a74e666160bb"
}
variable "vpn_url" {
  type        = string
  description = "If set, will be passed to VPN to set as VPN address"
  default     = ""
}
variable "vpn_vpc_id" {

}
variable "number_of_subnets" {

}
