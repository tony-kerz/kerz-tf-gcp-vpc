variable "tenant" {}

variable "tags" {
  type = map(any)
}

variable "region" {
  #default = "us-east4"
}

variable "apis" {
  type = list(any)
  default = [
    "container.googleapis.com"
  ]
}

# 1. no cidrs (primary or secondary) should overlap
# -- plan for 128 subnets for 128 gke instances...
# 2. masters:
# -- cidrs should be /28 (16-ip)
# -- reserving 10.0.0.0/21 (2,048-ip) for 128 /28's
# -- 10.0.0.1 - 10.0.7.254
# 3. nodes:
# -- using /25 (128-ip) for 64 node cidrs
# -- reserving 10.0.8.0/18 (16384-ip) for 128 /25's
# -- 10.0.0.1 - 10.0.63.254
# 4. services:
# -- using /22 (1,028-ip) for services (1028/64=16 svc/node)
# -- reserving 10.0.64.0/15 (131,072-ip) for 128 /22's
# -- 10.0.0.1 - 10.1.255.254
# 5. pods:
# -- using /19 (8192-ip) for pods (8192/64=128 pod/node)
# -- reserving 10.2.0.0/12 (1,048,576-ip) for 128 /19's
# --
#
variable "subnets" {
  default = {
    kerz-lab-k8s = {
      project     = "lab"
      cidr        = "10.0.8.0/25"
      master-cidr = "10.0.0.0/28"
      secondary-cidrs = {
        # master can't be called out here!
        # master  = "10.0.0.0/28"
        service = "10.0.64.0/22"
        pod     = "10.2.0.0/19"
      }
    }
    kerz-lab-k8s-2 = {
      project     = "lab"
      cidr        = "10.0.9.0/25"
      master-cidr = "10.0.0.16/28"
      secondary-cidrs = {
        service = "10.0.68.0/22"
        pod     = "10.2.32.0/19"
      }
    }
    kerz-shared-pool = {
      cidr = "10.0.8.128/25"
    }
  }
}


