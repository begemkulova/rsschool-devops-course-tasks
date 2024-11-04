# Task 4: Jenkins Installation and Configuration
This task 4 is a part of the RS School AWS DevOps coursework.

## Overview

This repository contains Terraform configuration files to set up a networking infrastructure for a Kubernetes cluster in AWS and Jenkins. The S3 bucket is used to store the Terraform state.

## Installation
**Prerequisites:**
- AWS Account
- Terraform installed
- AWS CLI configured with the appropriate access and permissions
- SSH Key for EC2 instances created in AWS
- GitHub repository with access to AWS secrets stored in GitHub Actions.

**Clone the Repository**:
```bash
1. git clone https://github.com/begemkulova/rsschool-devops-course-tasks.git
2. cd rsschool-devops-course-tasks
```

## GitHub Secrets
Before running the workflows, make sure to set the following GitHub Secrets in your repository settings:
- **AWS_ACCESS_KEY_ID**: Your AWS access key ID.
- **AWS_SECRET_ACCESS_KEY**: Your AWS secret access key.
- **AWS_REGION**: The AWS region to deploy resources in.
- **AWS_ACCOUNT_ID**: Your AWS account ID (optional but recommended). 
- **AWS_EC2_PRIVATE_KEY**: Your AWS's Key Pair (optional but recommended). 

## Resources Provisioned
- VPC: A Virtual Private Cloud with DNS support and hostnames enabled.
- Subnets: Public and private subnets spread across availability zones.
- Internet Gateway: Allows public internet access for instances in public subnets.
- NAT Gateway: Enables instances in private subnets to access the internet.
- Route Tables: Separate route tables for public and private subnets.
- Security Groups:
- Bastion security group with SSH and ICMP access.
- Main instance security group for internal communication.
- Network ACL: Configured for private subnets.
- EC2 Instances: A bastion host in the public subnet and a main host in the private subnet.

## Variable Definitions
region: AWS region for resource creation (default: us-east-1).
vpc_name: Name of the VPC (default: task2-vpc).
vpc_cidr: CIDR block for the VPC (default: 10.0.0.0/16).
public_subnets: List of CIDR blocks for public subnets (default: ["10.0.1.0/24", "10.0.2.0/24"]).
private_subnets: List of CIDR blocks for private subnets (default: ["10.0.3.0/24", "10.0.4.0/24"]).
bastion_instance_type: EC2 instance type for the Bastion host (default: t2.small for Jenkins, it is NOT Free Tier).
instance_type: EC2 instance type for the main host (default: t2.small for Jenkins, it is NOT Free Tier).
ssh_key_name: SSH key name for EC2 instances.
enable_nat_gateway: Whether to enable NAT Gateway (default: true).
project: Project name used in tags (default: task4).

## Backend Configuration
The Terraform state is stored remotely in my S3 bucket (please use your own bucket name).
My Bucket name: begemkulov-rs-terraform-state.

## Workflow Overview
The GitHub Actions workflow consists of the job named terraform-deploy with the following steps:
- **terraform-check**: Checks the formatting of Terraform files.
- **terraform-plan**: Initializes Terraform and creates an execution plan.
- **terraform-apply**: Applies the changes to the AWS infrastructure (only on push to main).

## Usage
To deploy the infrastructure:
1. Make changes to your Terraform files.
2. Push your changes to the branch that you are working on & create a pull request.
3. Monitor the GitHub Actions for the pipeline's status, success & errors.

## Testing Your Workflow
To verify that your GitHub Actions workflow works after running the successful workflow, you should do the following steps:

- **Public IP of the master node**:
You can find the information in your AWS EC2 dashboard.

- **Connect/SSH the master node**:

```bash
ssh -i path/to/your/privatekey.pem ubuntu@<master_public_ip>
```
my example: ssh -i "C:\Becca\STUDY\RS-School\key1234 (1).pem" ubuntu@44.201.158.145



- **Installation verification**:

```bash
sudo systemctl status k3s
```

- **Copy:**
File should be copied to your local machine.
- if you are already SSH’d into the instance, copy the file to a temporary directory on your AWS instance:

```bash
sudo cp /etc/rancher/k3s/k3s.yaml ~/
```

- Exit the SSH session, returning to your local machine, and then use scp to transfer the file:
```bash
scp -i path/to/your/privatekey.pem ubuntu@<master_public_ip>:~/k3s.yaml /path/to/local
```
my example: $ scp -i "C:\Becca\STUDY\RS-School\key1234 (1).pem" ubuntu@54.164.93.87:~/k3s.yaml "C:\Becca\STUDY\RS-School\k3s.yaml"


- **KUBECONFIG (env var):**
Set it up in your local machine and verify the cluster. Note: it should be done in another terminal, parallel to open SSH tunnel.

```bash
export KUBECONFIG=/path/to/local/directory/k3s.yaml
```


- **Access: SSH tunnel:**
```bash
ssh -i /path/to/your/key.pem -L 6443:localhost:6443 ubuntu@<EC2_PUBLIC_IP>
```
my example: $ ssh -i "C:\Becca\STUDY\RS-School\key1234 (1).pem"  -L 6443:localhost:6443 ubuntu@54.164.93.87

- **Verify - Cluster & Jenkins:**
```bash
kubectl get nodes
kubectl get pods -n jenkins
```

- **Jenkins:**
Since we have set the service type to LoadBalancer, we should be able to access Jenkins via the public IP of our master node.
Retrieve the service details to get the external IP:

```bash
kubectl get svc -n jenkins
```

Open a web browser and navigate to http://<master_node_public_ip>:8080. You should see the Jenkins setup wizard.

- **Jenkins-Setup:**
The initial admin password to unlock Jenkins can be retrieved by running:

```bash
    kubectl exec -n jenkins <jenkinspodname> -- cat /var/jenkins_home/secrets/initialAdminPassword
```

Copy the password for the Jenkins setup wizard.

- **Freestyle Project:**
Follow the setup wizard to install recommended plugins.
Freestyle project - creation steps:
- Name it "HelloWorld".
- Choose the BuildSection, then, add the "Execute shell" Step with the command:

```bash
echo "Hello World!"
```

- **Verify:**
After saving and running the job, check the console output to ensure it shows "Hello world".

- **Check - PV Configuration:**
Ensure that the persistent volume (PV) and persistent volume claim (PVC) were created successfully by running:

```bash
kubectl get pv
kubectl get pvc -n jenkins
```

- **Verify - Helm install**
It should be done by deploying and removing the Nginx chart from Bitnami as stated in the task. Install the Nginx chart using Helm by running:

```bash
helm install my-nginx oci://registry-1.docker.io/bitnamicharts/nginx
```

- **Verify - Deployment:**

```bash
kubectl get pods
```

- **Remove - Nginx Chart:**

```bash
helm uninstall my-nginx
```

- **Check Nginx resources:**
Based on the steps, the resources should be removed, to check it run the following codes:
```bash
kubectl get pods
kubectl get svc
```
End