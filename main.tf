1. EC2 Creation
---------------

provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "InstanceDK" {
  count         = 5
  ami           = "ami-022ce6f32988af5fa"
  instance_type = "t2.micro"
  tags = {
    Name = "InstanceDK-${count.index}"
  }
}

-----------------------------------------------------------------------------------------

2. EC2 Creation with var instance_type
----------------------------------------

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "InstanceDK" {
  count         = 2
  ami           = "ami-022ce6f32988af5fa"
  instance_type = var.instance_type

  tags = {
    Name = "InstanceDKvar-${count.index}"
  }
}

variable "instance_type" {

  description = "*"
  type = string
  default = "t2.micro"
  
}

-----------------------------------------------------------------------------------------

3. EC2 Creation with var on count
------------------------------------

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "InstanceDK" {
  count         = var.count
  ami           = "ami-022ce6f32988af5fa"
  instance_type = var.instance_type

  tags = {
    Name = "InstanceDKvar-${count.index}"
  }
}

variable "instance_type" {

  description = "*"
  type = string
  default = "t2.micro"
  
}

variable "count" {

  description = "*"
  type = number
  default = 3
  
}

-----------------------------------------------------------------------------------------

4. Diffrentiating the main.tf and variables.tf
-----------------------------------------------------

a. main.tf
-----------
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "InstanceDK" {
  count         = var.instance_count
  ami           = "ami-022ce6f32988af5fa"
  instance_type = var.instance_type

  tags = {
    Name = "InstanceDKvar-${count.index}"
  }
}

b. variables.tf
----------------

variable "instance_type" {

  description = "*"
  type = string
  default = "t2.micro"
  
}

variable "instance_count" {

  description = "*"
  type = number
  default = 3
  
}


----------------------------------------------------------------------------------------------------------------------

5. tfvars example
------------------------------------

a. main.tf
-----------
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "InstanceDK" {
  count         = var.instance_count
  ami           = "ami-022ce6f32988af5fa"
  instance_type = var.instance_type

  tags = {
    # Conditional logic to set Name based on instance_type
    Name = var.instance_type == "t2.medium" ? "UAT" : "DEV"
  }
}


b. variables.tf
----------------

variable "instance_type" {
  
}

variable "instance_count" {
  
}

c. dev/tfvars
-------------

instance_count = 1
instance_type  = "t2.micro"

4. uat.tfvars
-------------

instance_count = 2
instance_type  = "t2.medium"

command to execute
-------------------

terraform apply -var-file="dev.tfvars"

--------------------------------------------------------------------------------------------


7. cli example
------------------------------------

a. main.tf
-----------
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "InstanceDK" {
  count         = var.instance_count
  ami           = "ami-022ce6f32988af5fa"
  instance_type = var.instance_type

  tags = {
    # Conditional logic to set Name based on instance_type
    Name = var.instance_type == "t2.medium" ? "UAT" : "DEV"
  }
}


b. variables.tf
----------------

variable "instance_type" {
  
}

variable "instance_count" {
  
}


if we execute like "terraform apply" then we need to give the values on the exceution 

and if we want to pass the variable as a part of command line 

terraform aaply -var="instance_type=t2.micro" -var="instance_count=1"


---------------------------------------------------------------------------------------------------

8. Output module

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "InstanceDK" {
  count         = 1
  ami           = "ami-022ce6f32988af5fa"
  instance_type = "t2.micro"

  tags = {
    # Conditional logic to set Name based on instance_type
    Name = "UAT-${count.index}"
  }
}

output "public-ip-op" {
  value = aws_instance.InstanceDK[*].public_ip
  
}

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "InstanceDK" {
  count         = 2  # Change this to the desired number of instances
  ami           = "ami-022ce6f32988af5fa"
  instance_type = "t2.micro"

  tags = {
    Name = "UAT-${count.index}"
  }
}

output "public_ips" {
  value = {
    for i in range(length(aws_instance.InstanceDK)) :
    "UAT-${i}" => aws_instance.InstanceDK[i].public_ip
  }
}
 
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "InstanceDK" {
  count         = 2  # Change this to the desired number of instances
  ami           = "ami-022ce6f32988af5fa"
  instance_type = "t2.micro"

  tags = {
    Name = "UAT-${count.index}"
  }
}

output "instance_details" {
  value = {
    for i in range(length(aws_instance.InstanceDK)) :
    "UAT-${i}" => {
      Public_IP  = aws_instance.InstanceDK[i].public_ip,
      Private_IP = aws_instance.InstanceDK[i].private_ip,
      Public_DNS = aws_instance.InstanceDK[i].public_dns,
      Private_DNS = aws_instance.InstanceDK[i].private_dns
    }
  }
}
 
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "InstanceDK" {
  count         = 2  # Change this to the desired number of instances
  ami           = "ami-022ce6f32988af5fa"
  instance_type = "t2.micro"

  tags = {
    Name = "UAT-${count.index}"
  }
}

output "public_ips" {
  value = {
    for i in range(length(aws_instance.InstanceDK)) :
    "UAT-${i}" => [aws_instance.InstanceDK[i].public_ip,aws_instance.InstanceDK[i].private_ip,aws_instance.InstanceDK[i].public_dns,aws_instance.InstanceDK[i].private_dns]
  }
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

9. AWS S3 and EBS 
-----------------

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "deepak_bucket" {
  bucket = "deepaks3bucket2024yadav007"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "Deepak S3 Bucket"
    Environment = "Dev"
  }
}

resource "aws_ebs_volume" "deepak_ebs" {
  size = 10
  availability_zone = "ap-south-1a"
  tags = {
    Name        = "Deepak EBS Volume"
    Environment = "Dev"
  }
  
}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

10. IAM User creatin , policy, attachment

provider "aws" {
  region = "ap-south-1"
}

# Create an IAM user
resource "aws_iam_user" "my_iam_user" {
  name = "my-iam-user" # Specify the IAM user name

  tags = {
    Name        = "My IAM User"
    Environment = "Dev"
  }
}

# Create an IAM policy
resource "aws_iam_policy" "my_iam_policy" {
  name        = "MyIAMPolicy"
  description = "A policy for my IAM user"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the user
resource "aws_iam_user_policy_attachment" "my_policy_attachment" {
  user       = aws_iam_user.my_iam_user.name
  policy_arn = aws_iam_policy.my_iam_policy.arn
}

# Create access keys for the IAM user
resource "aws_iam_access_key" "my_access_key" {
  user = aws_iam_user.my_iam_user.name
}

# Output the access key and secret
output "access_key_id" {
  value     = aws_iam_access_key.my_access_key.id
  sensitive = true
}

output "secret_access_key" {
  value     = aws_iam_access_key.my_access_key.secret
  sensitive = true
}
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

11. Taint
------------
provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "example" {
  ami           = "ami-022ce6f32988af5fa" # Replace with a valid AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance"
  }
}


If its tainted, first it destroys then create a new instances or resources
terraform taint aws_instance.example


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

12. Lifecycle
-------------

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-022ce6f32988af5fa" # Replace with a valid AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance"
  }

  lifecycle {
    prevent_destroy = true
  }
}  


xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "web_server" {
  ami           = "ami-078264b8ba71bc45e" # Replace with a valid AMI ID
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
} 

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "app_server" {
  ami           = "ami-022ce6f32988af5fa" # Replace with a valid AMI ID
  instance_type = "t2.micro"
  tags = {
    Environment = "production"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}


Once the resources are created change the tag and redeploy

provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "app_server" {
  ami           = "ami-022ce6f32988af5fa" # Replace with a valid AMI ID
  instance_type = "t2.micro"
  tags = {
    Environment = "Dev"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
Even though changes are done terraform is not applying

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

13. VPC Creation
------------------

# Provider configuration
provider "aws" {
  region = "ap-south-1"  # Changed to ap-south-1 (Mumbai region)
}

# VPC creation
resource "aws_vpc" "deepak_vpc" {
  cidr_block           = "10.0.0.0/24"  # VPC CIDR block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "deepak-vpc"
  }
}

# Public Subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.deepak_vpc.id
  cidr_block        = "10.0.0.0/26"    # First public subnet CIDR
  map_public_ip_on_launch = true       # create public ip
  availability_zone = "ap-south-1a"    # First availability zone
  
  tags = {
    Name = "deepak-public-subnet-1"
  }
}

# Public Subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.deepak_vpc.id
  cidr_block        = "10.0.0.64/26"   # Second public subnet CIDR
  map_public_ip_on_launch = true       # # create public ip
  availability_zone = "ap-south-1b"    # Second availability zone
  
  tags = {
    Name = "deepak-public-subnet-2"
  }
}

# Private Subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.deepak_vpc.id
  cidr_block        = "10.0.0.128/26"  # First private subnet CIDR
  availability_zone = "ap-south-1a"    # First availability zone
  
  tags = {
    Name = "deepak-private-subnet-1"
  }
}

# Private Subnet 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.deepak_vpc.id
  cidr_block        = "10.0.0.192/26"  # Second private subnet CIDR
  availability_zone = "ap-south-1b"    # Second availability zone
  
  tags = {
    Name = "deepak-private-subnet-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "deepak_igw" {
  vpc_id = aws_vpc.deepak_vpc.id
  
  tags = {
    Name = "deepak-internet-gateway"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.deepak_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.deepak_igw.id
  }

  tags = {
    Name = "deepak-public-route-table"
  }
}

# Associate Public Subnet 1 with Route Table
resource "aws_route_table_association" "public_route_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate Public Subnet 2 with Route Table
resource "aws_route_table_association" "public_route_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Security Group for EC2 allowing all traffic
resource "aws_security_group" "deepak_sg" {
  vpc_id = aws_vpc.deepak_vpc.id
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"      # Allows all traffic (TCP, UDP, ICMP, etc.)
    cidr_blocks = ["0.0.0.0/0"] # Allow all traffic from anywhere
  }


  /* ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/24"]  # Allows all inbound traffic within the VPC CIDR range
  } */

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "deepak-security-group"
  }
}

output "security_group_id" {
  value = aws_security_group.deepak_sg.id
}

# EC2 Instance

resource "aws_instance" "deepak_ec2" {
  ami           = "ami-022ce6f32988af5fa" # Replace with your preferred AMI
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet_1.id # Launch in public subnet 1
  security_groups        = [aws_security_group.deepak_sg.id] # Use ID instead of name
  associate_public_ip_address = true

  # Dependency on security group
   depends_on = [
    aws_security_group.deepak_sg,
    aws_subnet.public_subnet_1,
    aws_subnet.public_subnet_2
  ]

  tags = {
    Name = "deepak-ec2"
  }
}


