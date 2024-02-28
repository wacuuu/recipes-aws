Happy attempt to build an eks cluster. The process:
1. Comment out all content of `generate_config.tf`
2. apply, Ctrl + C when it reaches CoreDNS
3. Uncomment the part of `generate_config.tf` responsible for kubeconfig generation
4. apply, Ctrl + C when it reaches CoreDNS
5. Uncomment the rest and let it cook

Based on this module https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

All shenanigans around the config is caused by chicken and egg problem of managing the aws auth config on a cluster that doesn't yet exist. If you have problems with kubeconfig, a good starting point is 
```
terraform taint local_file.kubeconfig
terraform apply --target local_file.kubeconfig
```
aws auth related stuff fails implicitly.

When you want to delete the cluster, first run `terraform state rm local_file.kubeconfig`, to avoid the same problem. Also `terraform state rm module.eks.kubernetes_config_map.aws_auth[0]` and ` terraform state rm module.eks.kubernetes_config_map_v1_data.aws_auth[0]`

I use self managed instance groups, they typically operate faster than eks managed

The version mismatch is a touchy subject