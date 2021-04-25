

terraform {
  backend "azurerm" {
    resource_group_name  = "resource-group-demo-ops"
    storage_account_name = "storageops210849"
    container_name       = "az-terraform-state-211238"
    key                  = "terraform.tfstate"
  }
}


