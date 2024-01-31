# System Image Factory

## Terraform Backend Configuration

See [How to set Terraform backend configuration
dynamically](https://brendanthompson.com/posts/2021/10/dynamic-terraform-backend-configuration)
for the theory.

To initialize this project in a new subscription use the following commands.  
**CAVE** This has only to be done once per subscription aka stage!!!

    terraform init -backend=false
    terraform plan -target=module.sp -target=module.backend -out backend.plan
    terraform apply "backend.plan"

    sed -i.bak 's/#backend/backend/' backend.tf
    terraform init -reconfigure -backend-config=backend.hcl

    # Now 'show' should show your terraform backend resource attributes
    terraform show

    # Delete the temporary plan
    rm backend.plan
