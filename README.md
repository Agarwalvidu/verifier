This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app) and deployed using Docker, Kubernetes, Helm, CI/CD (Jenkins) as well as includes minitoring and observability using Prometheus and Grafana.

# First, clone the repository:

Run the command `git clone https://github.com/Agarwalvidu/verifier.git`  
  
Navigate to the project directory:  `cd verifier`

# Access Using Docker  

## Installation Setup (Docker and Docker Compose):  
### Ubuntu:  
```
#Docker
sudo apt update
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

#Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

```
### MAC/Windows:  
Install Docker Desktop from [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)  

## Run Instructions  

### 1. Start all services (app, Prometheus, Grafana):  
```
docker compose up -d
```
### 2. Check running containers:  
```
docker ps
```
### 3. Access the app on: [http://localhost:3000](http://localhost:3000)  

### 4. Stop and clean up:  
```
docker compose down
```

# Automate using CI/CD (Jenkins):  

## 1. Install Jenkins and Trivy (for file scanning for running Jenkins pipeline):  
```
## Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

## Trivy
sudo apt update
sudo apt install wget -y
wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.44.4_Linux-64bit.deb
sudo dpkg -i trivy_0.44.4_Linux-64bit.deb
```
## 2. Access Jenkins Dashboard:  

Visit: `http://localhost:8080`

Retrieve the initial password:  
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

## 3. Install Required Plugins  
-- Docker Pipeline  
-- Git Plugin  

## 4. Add Credentials:  
Store Docker Username and Password in credential named 'DockerHubCreds'.  

## 5. Run the pipeline:  
Use the Jenkinsfile for automated builds and deployments.  

# Run the app inside Kubernetes Cluster (Kind):  

## 1. Install kind:  
```
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind version
```

## 2. Create the Kubernetes Cluster:  
```
kind create cluster --name verifier-cluster --config cluster.yml
```

## 3. Install kubectl:  
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client
```

## 4. Apply Kubernetes Configurations:  
```
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/pod.yml
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service.yml
kubectl apply -f k8s/hpa.yml
```
OR  
```
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/pod.yml
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service.yml
kubectl apply -f k8s/vpa.yml
```

## 5. Verify the Cluster:  
```
kubectl get all -n verifier-ns
```

# Helm Setup (for making Kubernetes process smoother):  

## 1. Install Helm:
```
curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version
```
Alternatively,  
```
bash helm/get_helm.sh
```
  
## 2. Install the Application:  
```
helm install verifier helm/verifier
```

## 3. Upgrade or Rollback  
```
helm upgrade verifier helm/verifier --reuse-values
helm rollback verifier 1
```

## 5. Check Releases  
```
helm list
helm status verifier
```

# Monitor using Prometheus:  

## 1. Start Prometheus along with other services:  
```
docker compose up -d
```

## 2. Access Prometheus at:  
```
http://localhost:9090
```

# Observe using Grafana:  

## 1. Start Grafana along with other services:  
```
docker compose up -d
```

## 2. Access Grafana at:  
```
http://localhost:3001
```

## 3. Default credentials:  
Username: admin  
Password: admin (or as configured)  

## 4. Add Prometheus as a data source:  
1. Go to Configuration > Data Sources
2. Add Prometheus
3. URL: http://prometheus:9090 (as defined in Docker Compose networking)

## 5. Create dashboards:  

Use panels to visualize metrics like CPU usage, memory, request count, etc.  
  
# More about the Project:  
You can start editing the page by modifying `app/page.js`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family, originally created by Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!


Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
