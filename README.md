# CI/CD with Built-in Security and Automation

A security-centric CI/CD pipeline integrating cutting-edge tools and practices to ensure robust code quality, vulnerability scanning, artifact publishing, secure Kubernetes deployment, and continuous monitoring.

## Introduction
This CI/CD pipeline is built on the principles of security, automation, and continuous monitoring to deliver a seamless and secure development and deployment experience.

- **Security by Design**: Security considerations are integrated into every stage of the development and deployment process.
- **Automation**: The pipeline leverages automation to enhance efficiency, security, and reduce human error.
- **Continuous Monitoring**: Systems and applications are continuously monitored to detect issues and anomalies promptly.

## Architecture

![arch-withGCP-TF](https://github.com/user-attachments/assets/29105e49-d5f6-483a-9d23-c7378cf6ca3b)

![ArchitectureDiag drawio](https://github.com/user-attachments/assets/833d7aee-8c24-499c-bd04-bc807d492975)
## Technologies Used
- **Kubernetes**: Container orchestration platform.
- **Jenkins**: CI/CD automation server.
- **SonarQube**: Code quality and static analysis.
- **Aqua Trivy**: Vulnerability scanning for code and container images.
- **Nexus Repository**: Artifact repository for secure storage.
- **Docker**: Containerization technology.
- **Docker Hub**: Docker image registry.
- **Kubeaudit**: Tool to audit Kubernetes clusters for various security concerns.
- **Grafana**: System and application-level monitoring and alerting.
- **Prometheus**: Collecting and querying metrics from services and endpoints.
- **Gmail**: Status notifications and alerts.

## Features:


## Project Structure
- **terraform/**: Terraform configuration files.
- **ModularizedTerraformInfra/**: Modular Terraform code for provisioning infra.
- **scripts/**: Deployment and automation scripts used with Terraform to automate and setup tools.
- **Jenkinsfile**: Declarative Jenkins pipeline definition.

## Workflow

### Development
- Developers create feature branches and push code to GitHub.

### CI/CD Pipeline Trigger
- Code changes trigger the Jenkins CI/CD pipeline.

### Build and Unit Testing
- [Build tool] compiles the code and executes unit tests.

### Code Quality and Security
- **SonarQube** performs code quality analysis.
- **Aqua Trivy** scans for vulnerabilities in code dependencies.

### Artifact Creation
- A build artifact (e.g., JAR, WAR) is generated.

### Artifact Publishing
- The artifact is pushed to Nexus Repository.

### Container Image Build
- Docker creates a container image using the artifact.

### Image Vulnerability Scan
- Aqua Trivy scans the image for vulnerabilities.

### Deployment
- If all checks pass, the image is deployed to Kubernetes.

### Monitoring and Notifications
- Monitoring solutions track system and website health.
- Emails are sent for deployment status and critical alerts.

## Screenshots
- Deployed Website
 ![website](DeployedWebsite.png)
- Prometheus Target
 ![prmTargets](https://github.com/user-attachments/assets/0ccedee5-e4ac-4fbf-be96-115dad4268ad)
- Grafana Dashboard
 ![dashboardofgraphanaForJenkinsMachine](https://github.com/user-attachments/assets/12241d06-2046-4991-9b61-aac04af84e01)
 ![prmmonitoringongraphna](https://github.com/user-attachments/assets/bbcf6816-868f-42f3-aa3e-7d7da1abb1de)
- Blackbox Exporter
- Notification Recieved
![mail](https://github.com/user-attachments/assets/e9519cfe-7e75-4b42-b42e-52a26ee3657c)
- Pipeline Build
![pipelin](https://github.com/user-attachments/assets/aef9b61e-4c4b-4de4-9f2a-af9b4eae22dd)


- Sonarqube
![sq1](https://github.com/user-attachments/assets/096b495d-6553-4c6b-9550-43438eb3be0d)
- Docker Image
![docker](https://github.com/user-attachments/assets/4304edcb-b4b8-42ae-8595-f433593bf979)


## **[Read the Blog Post here!](https://blogs.vijaysingh.cloud/project-devsecops-pipeline-pro)**

## Contribution
Contributions to this project are welcome! If you encounter any issues or have suggestions for improvement, feel free to open an issue or submit a pull request.

---
