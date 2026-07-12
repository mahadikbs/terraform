resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
}

resource "aws_subnet" "sub-private" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = false

    tags = {
        name = "private-subnet"
    }
}

resource "aws_subnet" "sub-public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        name = "public-subnet"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        name = "main-igw"
    }
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.sub-public.id

    tags = {
        name = "main-nat-gateway"
    }
}

resource "aws_eip" "nat" {

  domain = "vpc"

}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        name = "public-route-table"
    }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags = {
        name = "private-route-table"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.sub-public.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.sub-private.id
    route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "allow-ssh" {
    name = "allow-ssh"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port =80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web" {
    ami = "ami-0b6d9d3d33ba97d99" # Amazon Linux 2 AMI
    instance_type = "t3.micro"
    subnet_id = aws_subnet.sub-public.id
    vpc_security_group_ids = [aws_security_group.allow-ssh.id]
    associate_public_ip_address = true
    key_name = "ec2-pub"

    tags = {
        Name = "WebServer"
    }
}