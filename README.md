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
2. you should be able to use kubectl to view node status: `kubectl get nodes --watch`
3. Finally, you can deploy a guestbook application: `https://docs.aws.amazon.com/eks/latest/userguide/eks-guestbook.html`
4. Then you should be able to get the endpoint with kubectl: `ubectl get services -o wide` e.g. http://adf8587e8822b11e985ed06aa4a3435a-1242824340.eu-west-2.elb.amazonaws.com:3000/
5. Then deploy the kubernetes web UI (Dashboard): `https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html`
