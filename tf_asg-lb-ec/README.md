## What this script does 
- This is a sample TF script for ASG with ELB working together to provision a simple web cluster 
- The ASG resource basically attaches the loadbalncer for cluster management and scaling


## To Do 
- I still see instances coming up with public IPs, this ruins the concept of loadbalancing. 
	- Move all resource to a custom VPC with multiple subnets 
- Dynamically set resources to fetch values/setting from target VPC remote state file
- Create a sample AMI to provision this cluster 
- Make them modules 
- Re-organize directoy for code reusability 

