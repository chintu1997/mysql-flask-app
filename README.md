# Python Flask MySQL App

This project demonstrates how to run a Python-based Flask web application that connects to a MySQL database using Docker, Kubernetes (Minikube), and Helm for deployment.

## Features

- Python Flask app that connects to a MySQL database.
- Automatically creates a `test_database` if it doesn't exist.
- Helm chart for deploying the app to Kubernetes.

## Requirements

To run this project locally or in a Kubernetes cluster, you will need the following:

- [Docker](https://www.docker.com/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Git](https://git-scm.com/)

## Project Structure

```
.
├── Dockerfile
├── README.md
├── app.py
├── docker-compose.yml
├── mysql-deployment.yaml
├── namespace.yaml
├── persistent-volume.yaml
├── python-app-deployment.yaml
├── python-mysql-app
│   ├── Chart.yaml
│   ├── templates
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── tests
│   │       └── test-connection.yaml
│   └── values.yaml
└── storage-class.yaml
```

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/python-flask-mysql-app.git
cd python-flask-mysql-app
```

### 2. Build and Run Locally Using Docker Compose

If you want to run this app locally using Docker, use the following steps:

1. **Build the Docker images and run the containers:**

   ```bash
   docker-compose up --build
   ```

2. **Access the App:**

   Once the containers are running, open your browser and visit `http://localhost:8080`. You should see the message:
   
   ```
   Hello, world! Connected to database: test_database
   ```

### 3. Deploy to Kubernetes Using Minikube

To deploy the app on a Kubernetes cluster using Minikube:

1. **Start Minikube:**

   ```bash
   minikube start
   ```

2. **Build Docker Images Inside Minikube:**

   Switch Docker environment to Minikube:

   ```bash
   eval $(minikube docker-env)
   docker build -t rohithbathini97/python-flask-app:latest .
   ```

3. **Deploy Using Helm:**

   - First, install Helm (if not already installed):

     ```bash
     curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
     ```

   - Install the Helm chart:

     ```bash
     helm upgrade --install python-mysql-app ./python-mysql-app --namespace python-mysql-app --create-namespace
     ```

4. **Access the App:**

   Use Minikube to get the service URL:

   ```bash
   minikube service python-mysql-app -n python-mysql-app
   ```

   This will open the app in your browser. You should see the same output:
   
   ```
   Hello, world! Connected to database: test_database
   ```

### 4. Clean Up

When you're done, you can clean up your Kubernetes resources and stop Minikube:

```bash
helm uninstall python-mysql-app -n python-mysql-app
minikube stop
```

## GitHub Actions for CI/CD

This project uses GitHub Actions to automate the CI/CD pipeline. The following secrets are required for GitHub Actions to work:

1. **`DOCKER_USERNAME`**: Your Docker Hub username.
2. **`DOCKER_PASSWORD`**: Your Docker Hub password or access token.
3. **`KUBECONFIG_DATA`**: Base64-encoded kubeconfig for accessing your Kubernetes cluster.

### CI/CD Workflow

- The CI/CD pipeline automatically builds the Docker image and pushes it to Docker Hub.
- The Helm chart is used to deploy the application to a Kubernetes cluster.
- On each commit or pull request, the pipeline will run and update the deployment.

### How to Set Up GitHub Actions

1. Fork this repository.
2. Set the required secrets (`DOCKER_USERNAME`, `DOCKER_PASSWORD`, `KUBECONFIG_DATA`) in your GitHub repository settings under **Settings > Secrets**.
3. Push any changes to the repository, and the GitHub Actions workflow will automatically trigger.

## Additional Information

- **Liveness and Readiness Probes**: Configured in the deployment YAML to ensure that the application is healthy.
- **Rolling Update Strategy**: Ensures minimal downtime during deployment updates.