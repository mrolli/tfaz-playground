# Using Azure Storage for Terraform State

This scenario is a slightly changed adaption of what is showcased in the video
[Using Azure Storage for Terraform State - Best Practices](https://www.youtube.com/watch?v=iVyKvopGnrQ).

This repository showcases how to setup a Azure Storage Blob Storage to store
terraform state in it. It grants minimal needed permissions to a service
principal to access a specific key in a specific container only to carry out
read and writes but nothing more. In addition feature are chosen to make the
storage account safe for this use case. Find details in the next chapter.

## Create Storage

### Access Control

This scenario will setup a service principal to access the terraform state key
in the container created. To show case the **attribute-based access control (ABAC)**
instead of using the "Contributor" role or the recommended "Storage Data Blob Owner"
(recommended by HashiCorp) or "Storage Data Blob Contributor", a more
restrictive custom role is presented that only is allowed to the minimal needed permissions:

- actions: containers/read and generateUserDelegationKey/action (for SAS token
  creation)
- data_action: containers/blobs/read, containers/blobs/write,
  containers/blobs/add/action

These actions and data_actions are then even further restricted by only allowing
them on keys of the pattern `tacowagon/*` within exactly one container
`tfstate`. See `conditionals.tf` for the details.  
To test that the restrictions are in place, a second container `tfstate` will be
created to illustrate the different access errors that will occur if permissions
are missing.

As access is done using EntraID by using a service principal via OAUTH, the
shared access keys that a storage account provides are not used. Therefore, to
minimize the attack surface, the shared access keys get disabled.

- showcases  by using conditionals
- shared access keys disabled by default (use EntraID to authenticate)
- default to OAUTH authentication using a service principal
The lifetime of SAS tokens is restricted to two hours on this storage account.
SAS tokens shall be used for automation in pipelines.


### Technical Decisions

In transit encryption is guaranteed by allowing access by HTTPS only. A minimla
TLS level of 1.2 is setup. Data at rest is encrypted by Microsoft by default.
Infrastructure encryption (additional encryption step) is not enabled by
default, but could if needed.  To account for region fails and to be able to use
certain feature a standard storage of type StorageV2 is created with a
replication type of GRS (replication to partner region, e.g. switzerlandwest).

To account human error or Microsoft side errors, versioning is enabled. Diffs
are stored with a retention time of 90 days. The retention policy is set to 30d
for the blob and the container, which means both are only soft deleted and can
be restored within 30d - just in case somebody accidentally deleted the blob or
the whole container.

Setting up the storage is as easy as:

    cd create_storage
    terraform init
    terraform plan
    terraform apply -auto-approve

Keep in mind that in this demo scenario the state of this creating step is local
and not stored remotely. If you want to have this in the created storage, you
have to migrate it.

The terraform run will output all relevant data. Use this to create the backend
configuration file of the storage test below.

## Storage Test

The directory `storage_test` is there to test the storage we
created above. All it does is creating a resource group - the start of every new
project. While the files provided are complete, the backend configuration is not
hard-coded. The use the above created storage account, setup a file called
`backend.tfbackend` with the following content. The filename does not have a
magic extension, it just reminds one that it holds a backend configuration.

    storage_account_name = "storage_account_name"
    container_name  >= "tfstate"
    key = "tacowagon/terraform.tfstate"
    client_id = "CLIENT_ID"
    client_secret = "CLIENT_SECRET"
    tenant_id = "TENANT_ID"
    subscription_id = "SUBSCRIPTION_ID"

As the storage account is setup with a random part you have to provide the
storage account name as it has been setup in the "create storage" step.

In lines 4-7 we have our authentication information. Now, in a production type
scenario you would want to submit this authentication information in another way
whether that's through a SAS token or some sort of integrated OIDC
authentication fork testing purposes I just hard-coded it right into this backend
file so if we bring up the terminal and I run a t

To run terraform, we first have to initialize Terraform but it shall use the
backend according the above created configuration:

    cd storage_test
    # create the backend.tfbackend file and fill-in the
    # details of the storage creaetd in [Create Storage](#create-storage)
    terraform init -backend-config backend.tfbackend
    terraform plan
    terraform apply

Play around with other value for the container_name, e.g `tfnope`, which is a valid
container name, or a different key like `burito/terraform.tfstate`. This
perfectly illustrates the use of the attribute-based access control (ABAC). The
created service principal has only access to the key
`tacowagon/terraform.tfstate` in the container `tfstate` and nowhere else.
