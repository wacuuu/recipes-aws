Why not, after all I link my github in my CV, I'd like to prove that even if I don't know the proper attributes of ami data block of the top of my head, I'm pretty familiar with it. The assumtion is that you have credentials configured either with aws CLI or in env.

### swap-key.sh
Yeee this is a public facing repo, I'd like to not leak the access key by accident, so this is a simple bash script to replace the credentials in local `~/.aws/credentials`

### networking
Setup VPC, cheap NAT (shoutout AndrewGuenther/fck-nat) and openvpn. You control VPC CIDR, how many subnets to create, whether to force them into one AZ (cheaper traffic) and if you want to set the VPN address, you get SSH keys to instances, networking and VPN based on OpenVPN marketplace AMI. Also it contains ansible stuff. Say you need a devbox with some of the tools you can connect to with vscode/ssh and use as a sortof swiss army knife. So now there is option to create a devbox instance and then you can go and manually run ansible once it is up.  `ansible-playbook -i devbox devbox.yaml -v`. Tested against the Paris and garbage internet, takes around 11 minutes. Also, there is a thing in ansible to run some basic config on all instances created via `create_instance` variable. `ansible-playbook -i instances host.yaml -v`

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_devbox"></a> [create\_devbox](#input\_create\_devbox) | Whether to create and configure devbox | `bool` | `true` | no |
| <a name="input_create_instance"></a> [create\_instance](#input\_create\_instance) | Create number of instances in private subnet | `number` | `3` | no |
| <a name="input_devbox_type"></a> [devbox\_type](#input\_devbox\_type) | Size of devbox to create | `string` | `"t3.medium"` | no |
| <a name="input_force_one_zone"></a> [force\_one\_zone](#input\_force\_one\_zone) | If true, all subnets will by default force instances to live in single AZ. Useful to cut cost | `bool` | `false` | no |
| <a name="input_number_of_subnets"></a> [number\_of\_subnets](#input\_number\_of\_subnets) | Number of subnets to create in the VPC, the last one will be public, with autoassigned public ips | `number` | `8` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR of VPC to be created in the format x.x.x.x/x | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpn_url"></a> [vpn\_url](#input\_vpn\_url) | If set, will be passed to VPN to set as VPN address | `string` | `""` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_devbox_ip"></a> [devbox\_ip](#output\_devbox\_ip) | IP of devbox that can be configured with ansible |
| <a name="output_devbox_pem_path"></a> [devbox\_pem\_path](#output\_devbox\_pem\_path) | Path to devbox instance key |
| <a name="output_instances_ips"></a> [instances\_ips](#output\_instances\_ips) | IPS of instances created in vpcs |
| <a name="output_instances_to_monitor_id"></a> [instances\_to\_monitor\_id](#output\_instances\_to\_monitor\_id) | List of instances to create for the sake of monitoring |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of private subnets ids |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet ID |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | CIDR of created VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of created VPC |
| <a name="output_vpn_ip"></a> [vpn\_ip](#output\_vpn\_ip) | VPN instance IP |
| <a name="output_vpn_password"></a> [vpn\_password](#output\_vpn\_password) | Password generated for VPN admin |
| <a name="output_vpn_webui"></a> [vpn\_webui](#output\_vpn\_webui) | Address to VPN admin panel |

### eks
A happy attempt to set up EKS cluster. It will build the cluster with a self managed node group using the official module. Check the readme there for more details, it is wild

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Cluster name |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | OIDC ARN to be use with IRSA stuff |

### eks-cluster-config
Configure supporting services that would technically work only on EKS.

### cluster-config
Configure supporting services that would technically work on any cluster running in AWS (like kOps). Currently works with:
- Nginx ingress controller

### an-app
A helmchart that can be deployed for testing purposes. It roughly is `helm init .` with a few tweaks

### cloudwatch-slack-notifications
Lambda implementation with all things around it like ecr and sns queue to handle cloudwatch notifications and send them to slack. You will need to have a var file with the value for slack hook, this is confidential thing

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Base name used for few things, like ecr repo, lambda or SNS | `string` | `"alert-notifier"` | no |
| <a name="input_slack_hook"></a> [slack\_hook](#input\_slack\_hook) | Slack webhook to push messages to | `string` | n/a | yes |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | SNS topic ARN, to be used with cloudwatch definitions |

### monitoring-deployments
Actual references to monitoring modules. The idea is to connect the thing in monitoring-modules like cpu monitoring with objects like instances in networking outputs. This is also the place that refers to SNS from cloudwatch-slack-notifications

### monitoring-modules
A bunch of cloudwatch rules to catch various rules, like ec2 instance monitoring stuff