# Backend configurations (run once when initializing Terraform plan with Azure)
# Setup an Azure Storage Account for Terraform remote state files:
#   Resource Group: CU-RSG-TERRAFORM
#   Storage Account: terraform<last 4 chars of subscription> (eg. terraformd4fe)
#   Container: terraform-state
#   Run: terraform init -backend-config="beconfig.tfvars" -backend-config="access_key=<storage account access key>"

resource_group_name   = "ES2-PROD-RSG-TERRAFORM"
storage_account_name  = "terraformabc9"
container_name        = "terraform-state"
backend               = "azurerm"
