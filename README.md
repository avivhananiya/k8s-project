WordPress & MariaDB Deployment on Kubernetes.
---------------
This project demonstrates a complete DevOps lifecycle including Infrastructure as Code (Terraform), Containerization (Docker/ECR), Orchestration (Kubernetes), and Monitoring (Prometheus/Grafana).

----------------
📋 Prerequisites
Ensure the following tools are installed and configured:

- AWS CLI: Configured with appropriate IAM permissions.
- Terraform: For provisioning the ECR repository.
- Minikube: Local Kubernetes cluster environment.
- Kubectl: Kubernetes command-line tool.
- Helm: For managing Kubernetes applications.

🏗 Project Architecture
- Infrastructure: Provisioned on AWS EC2.
- Registry: Private AWS ECR for Docker images.
- Orchestration: Kubernetes (Minikube).
- Ingress: Nginx Ingress Controller for traffic routing.
- Observability: Prometheus & Grafana stack for metrics.

📂 Repository Structure
- terraform-ECR/:
  Provisioning scripts for AWS ECR.
- wordpress/:
  Kubernetes manifests for the WordPress application.
- mariadb/:
  Kubernetes manifests for the MariaDB database.
- .gitignore:
  Excludes local state files (tfstate) and sensitive data.

🚀 Deployment Guide
---------------
1. Provision Infrastructure
Initialize and apply Terraform to create the ECR repository:

```console
cd terraform-ECR
terraform init
terraform apply -auto-approve
cd ..
```

2. Deploy Database & Application
Apply the Kubernetes manifests in the following order:

```console
kubectl apply -f mariadb/
kubectl apply -f wordpress/
```
3. Setup Ingress Controller
Install Nginx Ingress using Helm (Idempotent command):

```console
helm upgrade --install my-release oci://ghcr.io/nginxinc/charts/nginx-ingress --namespace default
```
4. Setup Monitoring Stack
Deploy Prometheus and Grafana for real-time observability:

```console
helm upgrade --install prometheus-stack prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
```
-------------------
🌐 Accessing the Services

WordPress:
- Run
```console
  kubectl port-forward --address 0.0.0.0 service/wordpress-aviv-service 8080:80
```
- and access via http://<EC2-IP>:8080.

Grafana:
- Retrieve the admin password:
```console
  kubectl get secret --namespace monitoring prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
- Run
```console
  kubectl port-forward --address 0.0.0.0 -n monitoring service/prometheus-stack-grafana 3000:80.
```
- Access via http://<EC2-IP>:3000 (User: admin).

📊 Monitoring Dashboard Setup
- Login to Grafana using the credentials retrieved above.
- Create a new Dashboard and add a Visualization.
- Select Prometheus as the data source.
- Enter the following PromQL query: kube_pod_container_status_running{container=~"wordpress|mariadb"}
- Change the visualization type to State Timeline to view the uptime bars.
