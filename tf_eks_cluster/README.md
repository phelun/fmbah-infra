## PREREQUISITES

1. Modify vpc ID 
2. Use pub subnets from VPC 
3. install aws-iam-authenticator 
4. List and confirm new cluster 
	 aws eks list-clusters --region eu-west-1

## POST EKS INSTALLATION STEPS 
 - aws sts get-caller-identity
 - aws eks update-kubeconfig --name fmbah01 --region eu-west-1

## HELM/TILLER SETUP
 - helm init
 - helm version # Should fail
 - kubectl create serviceaccount --namespace kube-system tiller
 - kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
 - kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'      
 - helm init --service-account tiller --upgrade
 - helm ls 

