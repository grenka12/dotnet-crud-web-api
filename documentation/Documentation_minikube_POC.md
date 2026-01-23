# BeStrong API – Kubernetes PoC (Minikube)

This document describes how to run the BeStrong API locally using Kubernetes (Minikube) as a Proof of Concept for future Azure Kubernetes Service (AKS) deployment.

## 1. Purpose of this PoC

The goal of this Proof of Concept is to:
- Validate Kubernetes as a runtime platform for BeStrong API
- Demonstrate application deployment, exposure, and persistence
- Prepare the solution for future migration to Azure Kubernetes Service (AKS)

## 2. Prerequisites

Before starting, ensure the following tools are installed:
- Docker
- Minikube
- kubectl (optional, alt: minikube kubectl)
- Access to Azure Container Registry (ACR) with a built image

## 3. Steps to start API
#### 3.1 Start Local Kubernetes Cluster

Start Minikube:
`minikube start`

Verify:
`minikube status`
#### 3.2 Configure Access to Azure Container Registry

##### 3.2.1 Obtain ACR Credentials
ACR credentials can be retrieved from Azure Portal:
- Go to **Azure Container Registry**
- Copy **username** and **password**

!OR via Azure CLI:
`az acr credential show -n acrdotnetcrudbestrong`

##### 3.2.2 Create Kubernetes Image Pull Secret
Create a Docker registry secret in Kubernetes:
```bash
kubectl create secret docker-registry acr-secret \
  --docker-server=acrdotnetcrudbestrong.azurecr.io \
  --docker-username=<ACR_USERNAME> \
  --docker-password=<ACR_PASSWORD>
```

##### 3.3 Deploy Application Resources
Resources must be created in the correct order.
##### Deployment Order
1. PersistentVolume (PV)
2. PersistentVolumeClaim (PVC)
3. Deployment
4. Service

##### 3.3.1 Persistent Storage
The application uses SQLite for data storage.  
To ensure data is not lost when the application restarts, persistent storage is used.

Apply Persistent Volume:
`kubectl apply -f pv.yaml`

Apply Persistent Volume Claim:
`kubectl apply -f pvc.yaml`

Verify storage:
`kubectl get pv kubectl get pvc`

##### 3.3.2 Deploy Application

Deploy the BeStrong API:
`kubectl apply -f deployment.yaml`

Verify pod status:
`kubectl get pods`

##### 3.3.3 Expose Application via Service

Expose the application using a NodePort service:
`kubectl apply -f service.yaml`

Verify service:
`kubectl get svc`


## 4. Access the API:
After the application is deployed and exposed, it can be accessed via Minikube.

##### 4.1  Prerequisite: Get Application URL
Run the following command to obtain the service URL:
`minikube service dotnet-crud-api`

This command will output a URL similar to:
`http://<MINIKUBE_IP>:<NODE_PORT>`
This URL will be referred to as `<API_BASE_URL>` in the examples below.

##### 4.2 API Endpoints
###### **4.2.1 Get All Movies**

**Endpoint**
`GET /api/Movies`

**Example**
`curl -X GET <API_BASE_URL>/api/Movies`

**Description**  
Returns a list of all movies stored in the database.


###### **4.2.2 Get Movie by ID**

**Endpoint**
`GET /api/Movies/{id}`

**Example**
`curl -X GET <API_BASE_URL>/api/Movies/1`

**Description**  
Returns a single movie by its unique identifier.


###### **4.2.3 Create a Movie**

**Endpoint**
`POST /api/Movies`

**Example**
```bash
curl -X PUT "<API_BASE_URL>/api/Movies?id=1" \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1,
    "title": "Interstellar",              
    "genre": "Science Fiction",
    "releaseDate": "2014-11-07" 
  }'
```

**Description**  
Creates a new movie record in the system.


###### **4.2.4 Update a Movie**

**Endpoint**
`PUT /api/Movies?id={id}`

**Example**
```bash
curl -X PUT "<API_BASE_URL>/api/Movies?id=1" \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1,
    "title": "Interstellar",
    "genre": "Science Fiction",
    "releaseDate": "2014-11-08"
  }'
```

**Description**  
Updates an existing movie record.


##### **4.2.5 Delete a Movie**

**Endpoint**
`DELETE /api/Movies/{id}`

**Example**
`curl -X DELETE <API_BASE_URL>/api/Movies/1`

**Description**  
Deletes a movie record by its identifier.

## 5. Data Storage
At the current Proof of Concept stage:
- The application uses SQLite as its database
- The database file is stored inside a Persistent Volume
- Kubernetes PersistentVolume (PV) and PersistentVolumeClaim (PVC) ensure data persistence

This means:
- Restarting or recreating application pods does not cause data loss
- Application runtime and data storage are clearly separated

###### Current Storage Location
At the current Proof of Concept stage, application data is stored using Kubernetes persistent storage.
- The SQLite database file is mounted into the application container at:
  `/app/data/App.db`

###### Future Azure Migration
In a future Azure deployment:
- SQLite will be replaced by a managed Azure database service
- Persistent Volumes will be backed by Azure-managed storage (Azure Fileshare or Managed Disks)

###### Persistance verification:
Create a record using the API (make the POST request)
Delete the running pod:
`kubectl delete pod <POD_NAME>`

Kubernetes will recreate the pod automatically
Verify that previously created data is still available (make the GET request)

This confirms correct persistent storage configuration.

## 6. Summary
This documentation demonstrates:
- Successful deployment of BeStrong API to Kubernetes
- Data persistence across restarts
- Readiness for future Azure Kubernetes Service migration