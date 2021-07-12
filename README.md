Infra Optimization.
Project 1 
DESCRIPTION
in this project I am going to create a DevOps infrastructure for an e-commerce application to run on high-availability mode.
Background of the problem statement:
A popular payment application, EasyPay where users add money to their wallet accounts, faces an issue in its payment success rate. The timeout that occurs with
the connectivity of the database has been the reason for the issue.
While troubleshooting, it is found that the database server has several downtime instances at irregular intervals. This situation compels the company to create their own infrastructure that runs in high-availability mode.
Given that online shopping experiences continue to evolve as per customer expectations, the developers are driven to make their app more reliable, fast, and secure for improving the performance of the current system.
Implementation requirements:
    1. Creating an AWS cluster (3 EC2 instances 1 master and 2 worker nodes) with full connectivity including loadbalancer and elastic IPs. I am also using AWS cloud9 for my environment which 	gives me a lot of flexibility to control over my cluster.
    2. Automating the provisioning of an EC2 instance using Ansible in case we need to add more nodes to our cluster.
    3. Installing Docker and Kubernetes on the cluster
    4. Implementing the network policies at the database pod to allow ingress traffic from the front-end application pod
    5. Creating a new user with permissions to create, list, get, update, and delete pods
    6. Configuring application on the pod
    7. Taking snapshot of ETCD database
    8. Setting criteria such that if the memory of CPU goes beyond 50%, environments automatically get scaled up and configured

Tools I am going to use:
    1. AWS EC2 cluster 
    2. Kubernetes
    3. Docker
    4. Ansible
    5. Git
       
Repositories:
       github: 
       dockerhub:
       
       
Steps to be taken:
- creating AWS cluster with full connectivity:
    • first I created an IAM user account, user group and key pair, set up default VPC, default subnet on different availability zones, security group, 3 elastic IP address. (screenshots: 01 - 02)
    • I created my instances manually and installed either apache2 or nginx webserver on each. I also could automatically provision all instances using Ansible playbook at once. I selected t2.medium as my instance type to have 2 CPUs (screenshot: 03).
    • Then i created my target groups and ALB applied the setting. Tested my ALB public DNS to make sure my connectivity is established (screenshot: 04 - 05)
    • using cloud9 i connected to all my instances using SSH.
- using all necessary information from the cluster and IAM user credentials, I automated the provisioning of an EC2 instance using Ansible playbook in case we need to add more nodes to our cluster (screenshot: 06 – 07 – 08).
      - Installed Docker and Kubernetes:
    • installed Docker and Kubernetes on all nodes using official documentations.
    • Set docker as CRI on and set cgroup=systemd on kube-config.
    • Initialized my kubernetes cluster using kubeadm, applied joint command on worker nodes
    • Installed weave-net as networking addon to take control of my networking within the cluster.
    • Tested my cluster is up and running (screenshot: 09).
      
      - Testing Application in the cluster:
    • First I created a repository on Git Hub for my codes and one repository on Docker Hub for my images (sceenshot: 10 – 11).
    • connected my Docker Hub to my Git Hub to automate build using source code on any release.
    • Then for testing purposes, I generated a maven project and developed a web application using spring boot. Downloaded the project and modified in IntelliJ IDE and wrote a test case (screenshot: 12 - 13).
    • Ran maven clean and maven install (screenshot: 14). 
    • built project using maven build tool and created the war file (screenshot: 15).
    • tested my application on a web browser (screenshot: 16).
    • Created my Dockerfile on project folder and pushed my project including Dockerfile to my git hub repository (screenshot: ).
    • Created my images on Docker Hub in automatic manner to use them on my Kubernetes cluster (screenshot: 15)
    • created a release on my git hub repository and got my built image on Docker repository.
    • wrote a yaml manifest for deployment and service and created application pods (screenshot: 09).


      - Implementing the network policies at the database pod to allow ingress traffic from the front-end application pod.
    • wrote a yaml manifest for deployment and service and created database pods as back-end.
    • created an network policy using yaml file and applied ingress rule for the database pod to allow incoming traffic only from front-end application pod on port 3306 (screenshot: 17).
      
      - Creating a new user with permissions to create, list, get, update, and delete pods
    • Created a service account and configured credentials for devops user using openssl.
    • for testing purpose, i used one of the worker nodes as a machine out of the cluster.
    • Created .kube/config on the worker node and copied the contents from master .kube/config files 
    • created a namespace
    • Wrote a role to grant "get", "list", "watch", "create", "update", "patch", "delete" control to ther user
    • wrote a rolebinding to link the role and service account.
    • Set context to my Namespace on config file and copied all contents excluding user: kubernetes part to the worker node corresponding config file (screenshot: ).
    • Ran kubectl get nodes to make sure new user has the granted privileges from worker node (screenshot: 18).  

- Configuring application on the pod
    • you can configure a pod in so many different ways; like running bash commands, creating directories and files, Assign Memory or cpu Resources to Containers and Pods, Configure a Pod to Use a Volume for Storage, and so on within yaml file. in this project I assigned CPU resources and configured a volume. 
      - Taking snapshot of ETCD database
    •  	using kubectl get pods -n kube-system and kubectl describe pod command i got the advertise_rul of the etcd pod and exported it. Then using below command put the content of etcd in to etcd.json file.
    • 	sudo ETCDCTL_API=3 etcdctl --endpoints $advertise_url --cacert /etc/kubernetes/pki/etcd/ca.crt --key /etc/kubernetes/pki/etcd/server.key --cert /etc/kubernetes/pki/etcd/server.crt get "" --prefix=true -w json > etcd.json
    • 	then applied: sudo ETCDCTL_API=3 etcdctl --endpoints $advertise_url --cacert /etc/kubernetes/pki/etcd/ca.crt --key /etc/kubernetes/pki/etcd/server.key --cert /etc/kubernetes/pki/etcd/server.crt snap save test1.db
    • and then : sudo ETCDCTL_API=3 etcdctl --endpoints $advertise_url --cacert /etc/kubernetes/pki/etcd/ca.crt --key /etc/kubernetes/pki/etcd/server.key --cert /etc/kubernetes/pki/etcd/server.crt snap status test1.db 
    • (screenshot: 19).
      - Setting criteria such that if the memory of CPU goes beyond 50%, environments automatically get scaled up and configured
    • first I modified application yaml file and set cpu resource
    • then  created and hpa using yaml file and set targetCPUUtilizationPercentage: 50  
    • installed metrics-server in kube-system name space and created hpa (sceenshot: 20 – 21 - 22).
      

links:
https://github.com/SMaqsoodi/07-07-21-final

https://hub.docker.com/repository/docker/smaqsoodi/07-07-21-final/general

Conclusion:
following all the steps in this project now we have a DevOps infrastructure for our application to run on high-availability mode.
 
