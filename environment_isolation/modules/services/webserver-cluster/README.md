## What this script does 
- This is a sample TF script for ASG with ELB working together to provision a simple web cluster 
- The ASG resource basically attaches the loadbalncer for cluster management and scaling


## To Do 
- I still see instances coming up with public IPs, this ruins the concept of loadbalancing. - Fix it 
- Create a sample AMI to provision this cluster 

## 
- We fetched value from data-storage/mysql statefile, and used it in our user_data.sh script to provision our web cluster in the asg resource
