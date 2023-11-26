pull:
	git pull

init: pull
	terraform init 

validate: init
	terraform validate 

cleanup:
	find / -type d  -name ".terraform" -exec rm -rf {} \;

# ---------------------------------------------------------------------------

asia-pacific-apply:
		terraform workspace new  asiapacific  || terraform workspace select  asiapacific
		terraform init   
		terraform apply -var-file envs/asiapacific.tfvars -auto-approve

germany-west-central-apply:
		terraform workspace new  germanywestcentral  || terraform workspace select  germanywestcentral
		terraform init   
		terraform apply -var-file envs/germanywestcentral.tfvars -auto-approve


india-central-apply:
		terraform workspace new  centralindia  || terraform workspace select  centralindia
		terraform init   
		terraform apply -var-file envs/centralindia.tfvars -auto-approve

europe-west-apply:
		terraform workspace new  westeurope  || terraform workspace select  westeurope
		terraform init   
		terraform apply -var-file envs/westeurope.tfvars -auto-approve

us-east-apply:
		terraform workspace new  eastus  || terraform workspace select  eastus
		terraform init   
		terraform apply -var-file envs/eastus.tfvars -auto-approve

uk-south-apply:
		terraform workspace new  uksouth  || terraform workspace select  uksouth
		terraform init   
		terraform apply -var-file envs/uksouth.tfvars -auto-approve

canada-east-apply:
		terraform workspace new  canadaeast  || terraform workspace select  canadaeast
		terraform init   
		terraform apply -var-file envs/canadaeast.tfvars -auto-approve

norway-east-apply:
		terraform workspace new  norwayeast  || terraform workspace select  norwayeast
		terraform init   
		terraform apply -var-file envs/norwayeast.tfvars -auto-approve				  

# ---------------------------------------------------------------------------

asia-pacific-destroy:
		terraform workspace new  asiapacific  || terraform workspace select  asiapacific
		terraform init   
		terraform destroy -var-file envs/asiapacific.tfvars -auto-approve

germany-west-central-destroy:
		terraform workspace new  germanywestcentral  || terraform workspace select  germanywestcentral
		terraform init   
		terraform destroy -var-file envs/germanywestcentral.tfvars -auto-approve
india-central-destroy:
		terraform workspace new  centralindia  || terraform workspace select  centralindia
		terraform init   
		terraform destroy -var-file envs/centralindia.tfvars -auto-approve

europe-west-destroy:
		terraform workspace new  westeurope  || terraform workspace select  westeurope
		terraform init   
		terraform destroy -var-file envs/westeurope.tfvars -auto-approve

us-east-destroy:
		terraform workspace new  eastus  || terraform workspace select  eastus
		terraform init   
		terraform destroy -var-file envs/eastus.tfvars -auto-approve

uk-south-destroy:
		terraform workspace new  uksouth  || terraform workspace select  uksouth
		terraform init   
		terraform destroy -var-file envs/uksouth.tfvars -auto-approve  		

canada-east-destroy:
		terraform workspace new  canadaeast  || terraform workspace select  canadaeast
		terraform init   
		terraform destroy -var-file envs/canadaeast.tfvars -auto-approve

norway-east-destroy:
		terraform workspace new  norwayeast  || terraform workspace select  norwayeast
		terraform init   
		terraform destroy -var-file envs/norwayeast.tfvars -auto-approve 
