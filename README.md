# Terramino Terraform module

This Terraform module creates an instance of [terramino-go](https://github.com/hashicorp-education/terramino-go) running on an EC2 instance in AWS. It takes in the following Terraform variables to configure the application to read Redis connection information from HashiCorp Vault Secrets.

This simpler, leaner version only takes the following inputs:

- `app_name`: a friendly name for the app
- `boundary_addr`
- `vault_token`
- `vault_addr`

## Boundary connection
Apart from the template configuration, the `main.tf` file was modified to retrieve and install the `vault-ca` public key in the EC2.
This is required to use Boundary with SSH credential injection.

## Prerequisites

- AWS account with appropriate permissions
- Terraform installed (version 0.14 or higher recommended)
- HashiCorp Vault instance configured with example secrets and Boundary login credentials to authenticate the Boundary provider.
- HashiCorp Boundary cluster configured with a userpass auth method


## Usage

```hcl
module "terramino" {
    source          = "github.com/hashicorp-education/terraform-aws-terramino"
    
    app_name        = "hashicardo"
    boundary_addr   = var.boundary_addr
    vault_addr      = "https://vault-cluster.vault.11xx22.aws.hashicorp.cloud:8200"
    vault_token     = var.vault_token
}
```

## Outputs

| Name | Description |
|------|-------------|
| `hostname` | ID of the EC2 instance running Terramino |
| `ip` | Public IP address of the EC2 instance |
| `boundary_connect_alias` | ssh command with alias. Requires transparent sessions |
| `boundary_connect_target_id` | Boundary connect command with target ID |

## Architecture

This module deploys the Terramino game on an EC2 instance and configures it to:
1. Retrieve Redis connection details from HashiCorp Vault
2. Set up authentication with HashiCorp Boundary for secure SSH access
3. Install necessary certificates for secure communication

## Testing

After deployment, you can:
1. Access the game through the provided application_url
2. Connect to the instance via Boundary using SSH credential injection
3. Verify logs using `journalctl -u terramino`
