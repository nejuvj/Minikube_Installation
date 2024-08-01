#!/bin/bash

set -e

# Function to handle errors
error_exit() {
  echo "Error: $1"
  exit 1
}

# Update and upgrade system packages
apt update && apt upgrade -y || error_exit "Failed to update and upgrade packages"

# Install curl if not already installed
apt-get install curl -y || error_exit "Failed to install curl"

# Download kubectl binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" || error_exit "Failed to download kubectl"

# Download kubectl checksum file
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" || error_exit "Failed to download kubectl checksum"

# Verify kubectl checksum
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check || error_exit "Kubectl checksum verification failed"

# Install kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl || error_exit "Failed to install kubectl"

# Install Docker
apt-get install docker.io -y || error_exit "Failed to install Docker"

# Download Minikube binary
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 || error_exit "Failed to download Minikube"

# Install Minikube
install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64 || error_exit "Failed to install Minikube"

# Start Minikube with Docker driver
minikube start --driver=docker --force || error_exit "Failed to start Minikube"

# Check Minikube status
minikube status || error_exit "Failed to get Minikube status"

