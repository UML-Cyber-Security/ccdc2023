# Set provider
terraform {
  required_providers {
    xenorchestra = {
      source = "terra-farm/xenorchestra"
      version = "~> 0.3.0"
    }
  }
}

# Configure the XenServer Provider
provider "xenorchestra" {
  url      = "wss://xoa-admin.cyber.uml.edu"  # Or set XOA_URL environment variable
  username = "Justin"                         # Or set XOA_USER environment variable
  password = ""                      # Or set XOA_PASSWORD environment variable
}