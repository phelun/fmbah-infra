Repo Author: 
F.Mbah

## Target Version: tf >= 0.12 

## Repo Purpose:
    - Deploy to multiple kind of infrastructure 
        * Kubernetes Cluster(EKS, KUBEADM) 
        * IBM ICP 
        * AWS ElasticBeanstalk 
        * AWS EC2 
        * Docker Compose 
    - Create Base Image With Packer


## Reference Environment Layout 
```
.
├── global
│   ├── iam
│   └── s3
├── mgmt
│   ├── services
│   │   ├── bastion-host
│   │   └── jenkins
│   └── vpc
├── prod
│   ├── data-storage
│   │   ├── mysql
│   │   └── redis
│   ├── services
│   │   ├── backend-app
│   │   └── frontend-app
│   └── vpc
└── stage
    ├── data-storage
    │   ├── mysql
    │   └── redis
    ├── services
    │   ├── backend-app
    │   └── frontend-app
    └── vpc

```
## So far: 
    - Above structure has been used to deploy a staging webcluster with user data 
    - Node still have public IPs associated with them :( 
    - Next refactor and modularise the code for reusability in a prod environment 
## To Do:
