# Getting started

## Installing Requirements

First, we need some tools to our work:

### Azure CLI

=== "macOS"

    Homebrew is the easiest way to install the Azure CLI:

    ```bash
    brew install azure-cli
    ```

    See [official documentation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos) for more information

=== "Windows"

    See [official documentation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)
    for information about how to install terrfaform on Windows.

=== "Linux"

    See [official documentation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)
    for information about how to install terrfaform on Linux.

### Terraform

=== "macOS"

    Homebrew is again the easiest way to install Terraform. First install the
    HashiCorp tap, a repository of all their Homebrew packages:

    ```bash
    brew tap hashicorp/tap
    ```

    Now, install Terrfaorm from their tap:

    ```bash
    brew install hashicorp/tap/terraform
    ```

    See [official documentation](https://developer.hashicorp.com/terraform/tutorials/docker-get-started/install-cli)
    for more information.

=== "Windows"

    Chocolatey is the easiest way to install Terraform on Windows:

    ```bash
    choco install terraform
    ```

    See [official documentation](https://developer.hashicorp.com/terraform/tutorials/docker-get-started/install-cli)
    for more information.

=== "Linux"

    There are official repos for a bunch of Linux distros, see the [official
    documentation](https://developer.hashicorp.com/terraform/tutorials/docker-get-started/install-cli)
    for more information on the distro of choice.
