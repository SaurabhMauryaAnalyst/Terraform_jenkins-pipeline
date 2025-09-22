# Jenkins Pipeline with Terraform for AWS Infrastructure Automation

This project demonstrates **Infrastructure as Code (IaC)** using **Terraform** with a fully automated **Jenkins CI/CD pipeline** to provision and manage AWS infrastructure.  

## Features
- ✅ Automated provisioning of **AWS EC2**, VPC, subnets, and security groups  
- ✅ **Jenkins pipeline** for CI/CD automation of Terraform workflows  
- ✅ Enforced **Infrastructure as Code (IaC)** best practices  
- ✅ Scalable and repeatable deployments  
- ✅ Reduced environment setup time from **hours to minutes**  

---

## Architecture
1. Developer pushes Terraform code to **GitHub**  
2. Jenkins pipeline triggers on commit  
3. Terraform executes:
   - `terraform init`
   - `terraform plan`
   - `terraform apply`
4. AWS resources are provisioned automatically  
5. Optional: `terraform destroy` for teardown  

---

## Tech Stack
- **Terraform** – Infrastructure as Code  
- **AWS** – EC2, VPC, Networking, Security Groups  
- **Jenkins** – CI/CD automation  
- **GitHub** – Version control  

---

## Project Structure
