Why not, after all I link my github in my CV, I'd like to prove that even if I don't know the proper attributes of ami data block of the top of my head, I'm pretty familiar with it

### networking
Setup VPC, cheap NAT (shoutout AndrewGuenther/fck-nat) and openvpn. You control VPC CIDR, how many subnets to create, whether to force them into one AZ (cheaper traffic) and if you want to set the VPN address, you get SSH keys to instances, networking and VPN based on OpenVPN marketplace AMI.

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_force_one_zone"></a> [force\_one\_zone](#input\_force\_one\_zone) | If true, all subnets will by default force instances to live in single AZ. Useful to cut cost | `bool` | `true` | no |
| <a name="input_number_of_subnets"></a> [number\_of\_subnets](#input\_number\_of\_subnets) | Number of subnets to create in the VPC, the last one will be public | `number` | `8` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR of VPC to be created in the format x.x.x.x/x | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpn_url"></a> [vpn\_url](#input\_vpn\_url) | If set, will be passed to VPN to set as VPN address | `string` | `""` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_fck_pem_path"></a> [fck\_pem\_path](#output\_fck\_pem\_path) | Path to fck nat instance key |
| <a name="output_vpn_instance_pem_path"></a> [vpn\_instance\_pem\_path](#output\_vpn\_instance\_pem\_path) | Path to fck nat instance key |
| <a name="output_vpn_ip"></a> [vpn\_ip](#output\_vpn\_ip) | VPN instance IP |
| <a name="output_vpn_password"></a> [vpn\_password](#output\_vpn\_password) | Password generated for VPN admin |
| <a name="output_vpn_webui"></a> [vpn\_webui](#output\_vpn\_webui) | Address to VPN admin panel |

