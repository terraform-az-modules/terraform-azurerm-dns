provider "azurerm" {
  features {}
}

module "dns" {
  source = "../../"
}
