ungrouped:
    hosts:
%{ for ip in instance_ips ~}
        ${ip}:
            ansible_ssh_private_key_file: "${key_path}"
            ansible_user: "${username}"
%{ endfor ~}