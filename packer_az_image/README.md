# System Image Factory

To initialize this project use the following commands.  
**CAVE** This has only to be done once per stage!!!

    terraform init -backend=false
    terraform plan -target=module.tfbackend_sp -target=module.tfbackend -out backend.plan
    terraform apply "backend.plan"

    sed -i.bak 's/#backend/backend/' conf.tf
    terraform init -reconfigure -backend-config=conf.tfvars

    # Now 'show' should show your terraform backend resource attributes
    terraform show
