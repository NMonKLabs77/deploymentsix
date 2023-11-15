# Deployment6:- Demonstrating my ability to deploy a Retail Banking application across two regions
Date: 14/11/2023

Done by: Nehemiah Monrose

## Table of Contents
- [Purpose](#purpose)
- [Requirements](#requirements)
- [Steps](#steps)
- [Diagram](#diagram)
  
## Purpose
The purpose of this deployment is to demonstrate my ability to deploy an application across multiple regions using Jenkins Agent and provision infrastructure using Terraform
Requirements

## Requirements

Instance 1:

Jenkins
software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa
python3.7
python3.7-venv
build-essential
libmysqlclient-dev
python3.7-dev

Instance 2:

Terraform
default-jre

## Steps

Step 1: I created a Terraform File provisioning 2 instances in default VPC for a Jenkins Manager and Agent Architecture

<img width="752" alt="Screenshot 2023-11-14 at 5 02 15 PM" src="https://github.com/NMonKLabs77/deployment6/assets/139259756/98ffe327-d506-4c18-ba08-1c432151f10e">



Step 2: Created two VPCs with Terraform, 1 VPC in US-east-1 and the other VPC in US-west-2. MUST have the following components in each VPC:

2 AZ's
2 Public Subnets
2 EC2's
1 Route Table
Security Group Ports: 8000 and 22

<img width="506" alt="Screenshot 2023-11-14 at 5 03 25 PM" src="https://github.com/NMonKLabs77/deployment6/assets/139259756/dcd9a2fc-38b4-4b1b-bc98-102428aa54ac">


Step 3: After, I made a user data script that will install the dependencies 

<img width="511" alt="Screenshot 2023-11-14 at 5 06 05 PM" src="https://github.com/NMonKLabs77/deployment6/assets/139259756/f4c0ac67-a520-4109-a2d1-7797e25a8c4f">

Step 4: Create and RDS Database

<img width="1113" alt="Screenshot 2023-11-14 at 5 07 45 PM" src="https://github.com/NMonKLabs77/deployment6/assets/139259756/f2056bae-1a18-4648-af14-67b89386477a">



<img width="806" alt="Screenshot 2023-11-14 at 5 09 47 PM" src="https://github.com/NMonKLabs77/deployment6/assets/139259756/92beba03-bd07-46a7-917a-2cddba5b3d53">

Step 5: Configured AWS credentials in Jenkins

- From the Jenkins dashboard, click on "Credentials" on the left-hand side menu.
- Click on "System" or "Global credentials (unrestricted)".
- Click on "Add Credentials" on the left panel.
- Click on the "Kind" dropdown and choose "AWS Credentials"
- Fill in the AWS Access Key ID and Secret Access Key
- Click "OK" to save the credentials
- Click Create

Step 6: Placed Terraform files in 

Step 7: Setup a Multibranch pipeline in Jenkins

- Access Jenkins Dashboard:
Open your web browser and navigate to your Jenkins server's URL to access the Jenkins dashboard.

- Create a New Item:
<p>Click on "New Item" on the left-hand side menu.
Enter Item Name and Select Multibranch Pipeline
Enter a name for your project in the "Enter an item name" field.</p>
-Choose "Multibranch Pipeline" and click "OK."
Configure Source Code Management:

- Under "Branch Sources," select your preferred source repository (e.g., Git, SVN, etc.).
Provide the repository URL and credentials if needed.
Specify the behavior for discovering branches (e.g., all branches, specific branches).
Add Branch Source:

- Click on "Add source" to add the repository source (GitHub, Bitbucket, etc.).
Configure authentication and other settings related to your repository provider.
Configure Build Triggers (Optional):


- Define the pipeline script or Jenkinsfile location (e.g., Jenkinsfile in the root of each branch).
Save and Run:

- Click "Save" to create the multibranch pipeline.
Jenkins will automatically scan the repository branches and create pipelines for each branch based on the Jenkinsfile or script defined.
View Multibranch Pipeline:


Step 8: Created a load balancer for us-east-1 and us-west-2

- Sign in to the AWS Management Console:

Go to https://aws.amazon.com/ and sign in to your AWS account.

- Navigate to the EC2 Dashboard:
Click on "Services" in the top left corner and select "EC2" under the "Compute" section.

- Go to Load Balancers Section:
In the EC2 dashboard, select "Load Balancers" from the left-hand navigation pane.

- Click "Create Load Balancer":
Click on the orange "Create Load Balancer" button.

- Choose Load Balancer Type:
Select the type of load balancer you want to create (Application Load Balancer, Network Load Balancer, or Classic Load Balancer). For example, select "Application Load Balancer."

- Configure Load Balancer Settings:
Provide a name for your load balancer.
Configure listeners, security settings, and availability zones.

- Configure Security Settings:
Set up security settings as needed, including SSL certificate, security policy, etc.

- Configure Routing:
Set up routing rules (target groups, routing based on paths, etc.).

- Configure Security Groups:
Define security groups for the load balancer to control inbound and outbound traffic.

Review and Create

NOTE WELL: Repeat the following steps for us-west-2


Bonus Question: With both infrastructures deployed, is there anything else we should add to our infrastructure?
Answer:

## Diagram 

[Link to Diagram](/Diagram)

