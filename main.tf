resource "aws_vpc" "main" {
  cidr_block = "20.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
      Name = "devops-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "20.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1e"
  tags = {
    Name = "1stSub"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "myIGW"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
    tags = {
       Name = "main-rt"
    }
  }

resource "aws_route" "r" {
  route_table_id            =  aws_route_table.rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "rt-associate" {
       subnet_id = aws_subnet.main.id
       route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "allow"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
    Name = "allow_all_traffic"
  }
}

resource "aws_key_pair" "aws_kp" {
    key_name = "cicd_key"
    public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "Jenkins-Master"{
    instance_type = var.instance_type[2]
    ami = var.ami["image"]
    key_name = aws_key_pair.aws_kp.id
    vpc_security_group_ids = [aws_security_group.allow_all.id]
    subnet_id = aws_subnet.main.id
    user_data = file("userdata.tpl")
    tags = {
        Name = "Jenkins-Master"
    }
}

output "Jenkins-Master_public_ip" {
  value = aws_instance.Jenkins-Master.public_ip
}
