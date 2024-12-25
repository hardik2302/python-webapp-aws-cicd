# Create EC2 Instance
resource "aws_instance" "my_ec2" {
  depends_on = [null_resource.build_and_push_image]  # Ensure EC2 is created after image is pushed to ECR

  ami           = "ami-0fd05997b4dff7aac"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  availability_zone      = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  key_name = "test"

  # User data script to configure docker 
  user_data = <<-EOF
              #!/bin/bash
              yum update -y 
              yum install -y docker
              systemctl enable docker 
              systemctl start docker 
              sudo usermod -aG docker ec2-user
              sudo aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 337909742593.dkr.ecr.ap-south-1.amazonaws.com
              sudo docker pull 337909742593.dkr.ecr.ap-south-1.amazonaws.com/docker-flask
              sudo docker run -d -p 5000:5000 --name flask-container 337909742593.dkr.ecr.ap-south-1.amazonaws.com/docker-flask

              EOF

  tags = {
    Name = "my_ec2_instance"
  }
}

# Security Group for EC2 Instance
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "my_security_group"
  description = "allow ssh to ec2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

  ingress {
  from_port   = 5000
  to_port     = 5000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
