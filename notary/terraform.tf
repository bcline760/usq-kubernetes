terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "unionsquared"
    storage_account_name = "usqartifacts"
    container_name       = "tfstate"
    key                  = "notary.tfstate"
  }
}
