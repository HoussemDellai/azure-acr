# set up variables
$acrName = "acrdemo001"
$acrResourceGroup = "resourcegroup-acr-demo001"
# create resource group
az group create -n $acrResourceGroup -l "westeurope"
# create ACR
$acr = az acr create -n $acrName -g $acrResourceGroup --sku Standard | ConvertFrom-Json

# 1. Create and Push a local container

# Login to ACR using Docker CLI
# docker login -u USERNAME -p PASSWORD USERNAME.azurecr.io
# login to ACR using az CLI (needs Docker running)
az acr login -n $acrName

# create Blazor/Web Assebly app
dotnet new -i Microsoft.AspNetCore.Components.WebAssembly.Templates::3.2.0-preview5.20216.8
dotnet new blazorwasm -o app -n webapp

# build a container on local machine
docker build -t "$acrName.azurecr.io/webapp:1.0" .

# push the container to ACR
# docker tag webapp:1.0 $acrName.azurecr.io/webapp:1.0
docker push "$acrName.azurecr.io/webapp:1.0"

# list respositories
az acr repository list -n $acrName

# 2. Create and Push a container in ACR

# we can shut down Docker in the local machine
# login to ACR using az CLI (no need for Docker running)
az acr login -n $acrName --expose-token

# build the container on ACR
az acr build -t "$acrName.azurecr.io/webapp:2.0" -r $acrName .

# show ACR repo images and tags
az acr repository show -n $acrName --repository webapp
az acr repository show-tags -n $acrName --repository webapp


# build Windows image (build from git repository)
az acr build -t "$acrName.azurecr.io/windows/webapp:4.0" -r $acrName https://github.com/Azure/acr-builder.git -f Windows.Dockerfile --platform windows

# Trivi
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy --exit-code 0 --severity MEDIUM,HIGH --ignore-unfixed mvc-app:1.0

# kube-bench
kubectl create -f https://raw.githubusercontent.com/aquasecurity/kube-bench/master/job.yaml
kubectl logs kube-bench-sd6d5

# kube-hunter
kubectl create -f https://raw.githubusercontent.com/aquasecurity/kube-hunter/master/job.yaml
kubectl logs kube-hunter-qgsqn



########################################################################


$ az acr build -t acrforaks2020.azurecr.io/productsstore:0.1 -r acrforaks2020 .

# https://docs.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest#code-try-5
$ az acr build -r MyRegistry https://github.com/Azure/acr-builder.git -f Windows.Dockerfile --platform windows

# not working
az acr build -r acrforaks2020 https://github.com/HoussemDellai/ProductsStoreOnKubernetes -f MvcApp/Dockerfile --platform linux