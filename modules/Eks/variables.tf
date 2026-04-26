variable "cluster_name" {
    description = "Name of the EKS cluster"
    type = string

}

variable "cluster_version" {
    description = "Kubernetes version for the EKS cluster"
    type = string
    
}

variable "vpc_id" {
    description = "ID of the VPC where the EKS cluster will be deployed"
    type = string

}

variable "subnet_ids" {
    description = "List of subnet IDs for the EKS cluster"
    type = list(string)
}

variable "node_groups" {
    description = "Configuration for EKS node groups"
    type = list(object({
        name           = string
        instance_type  = string
        desired_size   = number
        min_size       = number
        max_size       = number
    }))
  
}