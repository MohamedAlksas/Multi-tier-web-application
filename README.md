# AWS Multi-Tier Web Application with Terraform

This project demonstrates how to deploy a highly available, scalable, and secure multi-tier web application architecture on AWS using Terraform (Infrastructure as Code).

## 🏗️ Architecture Overview

The infrastructure is deployed within a custom Virtual Private Cloud (VPC) in the `us-east-1` region across two Availability Zones (`us-east-1a` and `us-east-1b`) for high availability. 

It consists of the following components:
*   **Networking:** Custom VPC (`10.0.0.0/16`), Internet Gateway, 2 Public Subnets, 2 Private Subnets, and 2 NAT Gateways (one in each public subnet).
*   **Compute Tier:** EC2 instances launched into the private subnets via an Auto Scaling Group. Instances are bootstrapped using a User Data script to install Apache (`httpd`) and serve a custom webpage displaying the instance's Availability Zone.
*   **Load Balancing:** An Application Load Balancer (ALB) deployed in the public subnets to distribute incoming HTTP traffic evenly across the healthy EC2 instances.
*   **Auto Scaling:** A Target Tracking Scaling Policy monitors average CPU utilization (targeting 50%) to automatically scale instances in and out.
*   **Database Tier:** A Multi-AZ Amazon RDS MySQL instance deployed in the private subnets for high availability and automated failover.
*   **Security:** Strict Security Groups (SGs):
    *   **ALB SG:** Allows inbound HTTP (80) from the internet.
    *   **Web SG:** Allows inbound HTTP/HTTPS only from the ALB, and SSH (22).
    *   **RDS SG:** Allows inbound MySQL traffic (3306) only from the Web SG.

## 🚀 Features

*   **Infrastructure as Code (IaC):** Fully automated deployment using Terraform.
*   **High Availability:** Resources are spanned across two AZs. If one AZ fails, the application remains accessible.
*   **Elasticity:** Auto Scaling Group ensures the application scales dynamically based on CPU load.
*   **Security Best Practices:** Compute and Database resources are isolated in private subnets. Access is strictly controlled via Security Groups. EBS volumes are encrypted at rest.

## 🛠️ Prerequisites

*   [Terraform](https://developer.hashicorp.com/terraform/downloads) installed on your local machine.
*   An AWS account.
*   AWS CLI installed and configured with your credentials (`aws configure`) using a profile named `Terraform_dev` (or modify `provider.tf` to match your profile).

## 💻 Usage

1.  **Clone the repository**
    ```bash
    git clone <your-repo-url>
    cd Multi-tier-web-application
    ```

2.  **Initialize Terraform**
    Downloads the necessary provider plugins.
    ```bash
    terraform init
    ```

3.  **Review the Infrastructure Plan**
    See what resources Terraform will create.
    ```bash
    terraform plan
    ```

4.  **Deploy the Infrastructure**
    Apply the configuration to create the resources in AWS.
    ```bash
    terraform apply
    ```
    *Type `yes` when prompted to confirm.*

5.  **Verify Deployment**
    Once deployment is complete, Terraform will output the DNS name of the Application Load Balancer (if configured in `output.tf`). Paste this URL into your browser. You should see a webpage stating which Availability Zone the server is running in. Refreshing the page should eventually balance you to the other server in the second AZ.

## 🧹 Clean Up

To avoid incurring future charges from AWS, remember to destroy the infrastructure when you are done testing.
```bash
terraform destroy
```
*Type `yes` when prompted to confirm.*
