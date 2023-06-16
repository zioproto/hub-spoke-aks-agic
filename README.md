# Terraform example for Azure Kubernetes Service (AKS) in a Hub and Spoke network topology

Context: [Hub-spoke network topology in Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli)

Subscriptions:
* Hub
* Spoke1

This is an example with AKS deployed in a VNet in the Spoke1 subscription in the `networkspoke1` vnet.

The Application Gateway is deployed in the Hub subscription in the `networkhub` vnet.

The 2 vnets are peered.

The AKS cluster has an AGIC (Application Gateway Ingress Controller) deployed with the AKS addon.

The AGIC is configured to use the Application Gateway in the Hub subscription.

The Azure Role Assignments give the AKS cluster the right to manage the Application Gateway.

## How do deploy the example

First set the credentials for the Hub subscription and the Spoke1 subscription in the file `provider.tf`.

The run the following commands:

```
terraform init -upgrade
terraform apply
```

## Testing
```
az account set --subscription <spoke1>
az aks get-credentials --resource-group spoke1-rg --name testing-aks --overwrite-existing
kubectl apply -f echoserver.yaml
kubectl get ingress
```