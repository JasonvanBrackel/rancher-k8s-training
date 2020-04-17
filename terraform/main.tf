# Configure the Azure Provider
provider "azurerm" {
  features { }
}

data azurerm_subscription "current" {}

## Resource Groups 
# Demo Resource Group
module "demo-resourcegroup" {
  source = "./resourcegroup-module"

  group-name = "jvb-onlinetraining"
  region = "eastus"
}

## Networks
module "demo-network" {
  source = "./network-module"

  resource-group = module.demo-resourcegroup.resource-group

}

## Nodes
locals {
   node-definition = {
    admin-username = "jason"
    ssh-keypath = "~/.ssh/id_rsa.pub"
    ssh-keypath-private = "~/.ssh/id_rsa.pub"
    size = "Standard_D2s_v3"
    disk-type = "Premium_LRS"
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
    docker-version = "18.09"
  }
}


module "k3s-nodes" {
  source = "./node-module"
  prefix = "jvb-k3s"

  resource-group = module.demo-resourcegroup.resource-group
  node-count = 1
  subnet-id = module.demo-network.subnet-id
  address-starting-index = 0
  node-definition = local.node-definition
}

module "rancher-nodes" {
  source = "./node-module"
  prefix = "jvb-rancher"

  resource-group = module.demo-resourcegroup.resource-group
  node-count = 1
  subnet-id = module.demo-network.subnet-id
  address-starting-index = 1
  node-definition = local.node-definition
}