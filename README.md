## This is work in progress

This example has been taken from: https://learn.hashicorp.com/terraform/aws/eks-intro

## Prerequisites
- Ensure that a .pem key is available under: "~/.ssh/" on the host dev machine. In my case it is called personal.pem
- Ensure that AWS credentials are available at: "~/.aws/credentials" on the host dev machine
```
      [default]
      aws_access_key_id = <KEY>
      aws_secret_access_key = <SECRET>
```
- Ensure that a S3 bucket as a backend type is created. See the docs [here](https://www.terraform.io/docs/backends/types/s3.html)
```
      terraform {
        # It is expected that the bucket, globally unique, already exists
        backend "s3" {
          # you will need a globally unique bucket name
          bucket  = "ci.terraform"
          key     = "eks/terraform.tfstate"
          region  = "eu-west-2"
          encrypt = true
        }
      }
```

## Setup guestbook app
1. See `kubectl_config.tf` for configuring the cluster which is a manual process
2. you should be able to use kubectl to view node status: `kubectl get nodes`
3. Finally you can follow the exact steps in the AWS docs to create the app. Here they are again:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/v1.10.3/examples/guestbook-go/redis-master-controller.json
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/v1.10.3/examples/guestbook-go/redis-master-service.json
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/v1.10.3/examples/guestbook-go/redis-slave-controller.json
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/v1.10.3/examples/guestbook-go/redis-slave-service.json
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/v1.10.3/examples/guestbook-go/guestbook-controller.json
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kubernetes/v1.10.3/examples/guestbook-go/guestbook-service.json
```
4. Then you can get the endpoint with kubectl: `kubectl get services`
