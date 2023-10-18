# Terraform FAQ

## How do I inspect resources of the current state?

`terraform state` and `terraform show` are your friends to inspect the state file
and therefore the state of all resources:

| Command                              | Description                               |
| ---------------                      | ---------------                           |
| `terraform state list`                 | List all known resources with their names |
| `terraform state show <resource name>` | Show the details of a certain resource    |
| `terraform show`                       | Show the details of all known resources   |

See the [terraform docs about State](https://developer.hashicorp.com/terraform/language/state)
for more information.

## How do I upgrade a resource provider to a new version?

Edit your HCL file and adjust the version option of the required_version section
of the provider in question. Then run `terraform init -upgrade`. This will
upgrade the installed provider and will update the .terraform.lock.hcl file
accordingly.

