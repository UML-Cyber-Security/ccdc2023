
# Ensure the provider is properly installed with a terraform init.
# Using terraform 0.13 and higher
# Add the configuration so terraform can install the provider from the terraform registry and configure the provider with the necessary credentials
# Instruct terraform to download the provider on `terraform init`
terraform {
  required_providers {
    xenorchestra = {
      source = "terra-farm/xenorchestra"
      version = "0.23.3"
    }
  }
}

provider "xenorchestra" {}