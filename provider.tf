terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.10"
    }
  }
  required_version = ">= 1.1.0"
}

# For testing purposes, I will use the same Service Principal for both providers
# az ad sp create-for-rbac --role="Owner" --scopes "/subscriptions/<hub_id>" "/subscriptions/<spoke1_id>" -o json


provider "azurerm" {
  alias           = "hub"
  subscription_id = ""
  tenant_id       = ""
  client_id       = ""
  client_secret   = ""
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


provider "azurerm" {
  alias           = "spoke1"
  subscription_id = ""
  tenant_id       = ""
  client_id       = ""
  client_secret   = ""
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

