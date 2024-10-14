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
