# Azure FAQ

## How Print Details of Current `az` Login-User

    az account show

    # If you need your the ID of your user object:
    az ad signed-in-user show [--query objectId -o tsv]
