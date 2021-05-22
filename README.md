A large chunk of this repo has been taken from [Provision an EKS Cluster (AWS)](https://learn.hashicorp.com/tutorials/terraform/eks)
but has the following modifications:
- Both public and private access endpoints enabled
- Terraform state file saved in a S3 bucket
- Installation of metrics-server
- Security groups with port 22 removed
- Deployed k8s metric service  
- Created an admin cluster role binding
- Deployed k8s dashboard

![API server endpoint access options](./pics/API_server_endpoint_access_options.15.37.png "API server endpoint access options")

## Prerequisites
In addition to the prerequisites mentioned at [Provision an EKS Cluster (AWS)](https://learn.hashicorp.com/tutorials/terraform/eks), you will need the following setup:
- Ensure that AWS credentials are available at: "~/.aws/credentials" on the host dev machine
```terraform
      [default]
      aws_access_key_id = <KEY>
      aws_secret_access_key = <SECRET>
      region = <REGION>
```
- Ensure that a S3 bucket as a backend type is created. See the docs [here](https://www.terraform.io/docs/backends/types/s3.html)
```terraform
      terraform {
        # It is expected that the bucket, globally unique, already exists
        backend "s3" {
          # you will need a globally unique bucket name
          bucket  = "ci.terraform"
          key     = "eks/terraform.tfstate"
          region  = "<REGION>"
          encrypt = true
        }
      }
```

## Setup cluster
Run the following command to set up the cluster
```terraform
terraform init # Initialize Terraform workspace
terraform apply # Review the planned actions before continuing
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name) # Configure kubectl

```

## Access dashbaord
```terraform
kubectl proxy
http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"; echo # generate the authorization token for the dashboard
```

## References
- Deploy the kubernetes web UI (Dashboard): `https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html`
