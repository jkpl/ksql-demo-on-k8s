# KSQL demo on Kubernetes

Steps to test locally:

1. Tools
    1. Install Docker
    2. Install kubectl
    3. Install Helm (to install Kafka locally)
2. Setup minikube
3. Install Kafka to minikube using Helm
    1. `helm init`
    2. `helm repo add confluentinc https://confluentinc.github.io/cp-helm-charts/`
    3. `helm repo update`
    4. `helm upgrade --install --atomic --values cp-helm-values.yaml kafka confluentinc/cp-helm-charts`
4. Build the demo in Minikube
    1. `eval $(minikube -p minikube docker-env)`
    2. `docker build -t ksql-demo .`
5. Run the demo in Kubernetes
    1. `kubectl apply -f ksql-demo-deployment.yaml`
