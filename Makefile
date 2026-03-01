CLUSTER_NAME := k8s-test
REGION       := us-east-1

.PHONY: connect apply diff destroy status url tf-init tf-apply tf-destroy

# --- Kubernetes ---

connect:
	aws eks update-kubeconfig --region $(REGION) --name $(CLUSTER_NAME)

apply:
	cd k8s && helmfile sync

diff:
	cd k8s && helmfile diff

destroy:
	cd k8s && helmfile destroy

status:
	kubectl get pods,svc -A

url:
	@kubectl get svc frontend -n apps -o jsonpath='http://{.status.loadBalancer.ingress[0].hostname}'

# --- Terraform ---

tf-init:
	cd terraform && terraform init

tf-apply:
	cd terraform && terraform apply -auto-approve

tf-destroy:
	cd terraform && terraform destroy -auto-approve
