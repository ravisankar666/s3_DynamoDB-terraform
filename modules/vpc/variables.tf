variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = ""
  
}

variable "availability_zones" {
    description = "Availability Zones"
    type        = list(string)
 
  
}

variable "private_subent_cidrs" {
    description = "CIDR blocks for private subnets"
    type        = list(string)


}

variable "public_subent_cidrs" {
    description = "CIDR blocks for public subnets"
    type        = list(string)


}

variable "cluster_name" {
    description = "Name of the EKS cluster"
    type = string
    
}