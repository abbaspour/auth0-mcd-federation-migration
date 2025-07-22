.PHONY: init plan apply destroy

# Default target
all: plan

# Initialize Terraform
init:
	terraform init

# Plan Terraform changes
plan:
	terraform plan -out=tfplan

# Apply Terraform changes
apply: init
	terraform apply -auto-approve

# Destroy Terraform resources
destroy: init
	terraform destroy -auto-approve

# Clean up Terraform files
clean:
	rm -rf .terraform/ tfplan terraform.tfstate terraform.tfstate.backup