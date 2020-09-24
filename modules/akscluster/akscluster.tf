resource "random_pet" "prefix" {
}

resource "azurerm_resource_group" "default" {
	name			= "${random_pet.prefix.id}-rg"
	location 	= var.location

	tags = {
		environment = "cloudguard-k8s-demo"
	}
}

resource "azurerm_kubernetes_cluster" "default" {
	name								= "${random_pet.prefix.id}-aks"
	location						= azurerm_resource_group.default.location
	resource_group_name	= azurerm_resource_group.default.name
	dns_prefix					= "${random_pet.prefix.id}-k8s"
	kubernetes_version	= var.kubernetes_version
	
	default_node_pool {
		name						= "default"
		node_count			= 1
		vm_size					= "Standard_D2_V2"
		os_disk_size_gb = 30
	}

	identity {
	    type = "SystemAssigned"
	}

	tags = {
		environment = "cloudguard-k8s-demo"
	}

	linux_profile {
		admin_username = "azureuser"
		ssh_key {
			key_data = var.ssh_key
		}
	}

	network_profile {
		network_plugin = "kubenet"
		load_balancer_sku = "Standard"
	}

	addon_profile {
		aci_connector_linux {
			enabled = "false"
		}

	azure_policy {
		enabled = "false"
	}

	http_application_routing {
		enabled = "false"
	}

	kube_dashboard {
		enabled = "false"
	}

	oms_agent {
		enabled = "false"
	}
}
}
