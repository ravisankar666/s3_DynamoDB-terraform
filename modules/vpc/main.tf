resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private" {
    count  = length{var.private_subent_cidrs}
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subent_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]

    map_public_ip_on_launch  = true

    tags = {
        Name = "${var.cluster_name}-private-subnet-${count.index + 1}"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
        "kubernets.io/role/elb" = "1"

    }
  
}

resource "aws_subnet" "public" {
    count  = length{var.public_subent_cidrs}
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subent_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]

    map_public_ip_on_launch  = true

    tags = {
        Name = "${var.cluster_name}-public-subnet-${count.index + 1}"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
        "kubernets.io/role/elb" = "1"

    }
  
}

resource "aws_internet_gateway" "main" {
vpc_id = aws_vpc.main.id

tags = {
    Name = "${var.cluster_name}-igw"
}
  
}

resource "aws_route_table" "main" {
vpc_id = aws_vpc.main.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id     //attach IGW to the route table

}

tags = {
    Name = "${var.cluster_name}-public"
}
}

resource "aws_route_table_association" "public" {
    count = length{var.public_subent_cidrs}
    subnet_id = aws_subnet.public[count.index].id    
    route_table_id = aws_route_table.main.id              //finally attach the route table to the public subnet
}

resource "aws_nat_gateway" "main" {
    count = length(var.public_subent_cidrs)
    allocation_id = aws_eip.nat[count.index].id
    subnet_id = aws_subnet.public[count.index].id   

    tags = {
        Name = "${var.cluster_name}-nat-gw-${count.index + 1}"
    }
}

resource "aws_route_table" "main"{
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main[0].id
    }

    tags = {
        Name = "${var.cluster_name}-private"
    }

}

resource "aws_route_table_association" "private" {
    count = length{var.private_subent_cidrs}
    subnet_id = aws_subnet.private[count.index].id    
    route_table_id = aws_route_table.main.id   
    
   
            //finally attach the route table to the private subnet
}