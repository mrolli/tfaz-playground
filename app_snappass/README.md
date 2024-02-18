# Snappass in Azure

## Redis Backend Setup
The setup of the Redis cache is based on Azure Cache for Redis and follows
closely [this lab](http://k8s.anjikeesari.com/azure/14-redis-cache/).

## References
- [Microsoft MSDN - Azure Cache for Redis Documentation](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/)
- [Microsoft MSDN - Tutorial: Secure access to an Azure Cache for Redis instance from a virtual network](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-private-link)
- [Microsoft MSDN - Azure Private DNS Zone Overview](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns)
- [Terraform Registry - azurerm_redis_cache](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache)
- [Terraform Registry - azurerm_private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone)
- [Terraform Registry - azurerm_private_dns_zone_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link)
- [Terraform Registry - azurerm_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint)
- [Terraform Registry - azurerm_monitor_diagnostic_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting)
