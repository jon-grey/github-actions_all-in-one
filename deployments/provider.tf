

terraform {
  backend "azurerm" {
    resource_group_name  = "resource-group-demo-ops"
    storage_account_name = "storageops195235"
    container_name       = "az-terraform-state-195235"
    key                  = "terraform.tfstate"
  }
}


