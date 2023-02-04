# creating instance 1
resource "aws_instance" "fbayomide-server1" {
  ami             = "ami-0778521d914d23bc1"
  instance_type   = "t2.micro"
  key_name        = "fbayomide-server"
  security_groups = [aws_security_group.fbayomide-server-sg.id]
  subnet_id       = aws_subnet.fbayomide-public-subnet1.id
  availability_zone = "us-east-1a"
  tags = {
    Name   = "server-1"
    source = "tf"
  }
}
# creating instance 2
 resource "aws_instance" "fbayomide-server2" {
  ami             = "ami-0778521d914d23bc1"
  instance_type   = "t2.micro"
  key_name        = "fbayomide-server"
  security_groups = [aws_security_group.fbayomide-server-sg.id]
  subnet_id       = aws_subnet.fbayomide-public-subnet2.id
  availability_zone = "us-east-1b"
  tags = {
    Name   = "server-2"
    source = "tf"
  }
}
# creating instance 3
resource "aws_instance" "fbayomide-server3" {
  ami             = "ami-0778521d914d23bc1"
  instance_type   = "t2.micro"
  key_name        = "fbayomide-server"
  security_groups = [aws_security_group.fbayomide-server-sg.id]
  subnet_id       = aws_subnet.fbayomide-public-subnet1.id
  availability_zone = "us-east-1a"
  tags = {
    Name   = "server-3"
    source = "tf"
  }
}

# Create a file to store the IP addresses of the instances

resource "local_file" "Ip_address" {
  filename = "/home/vagrant/tf_project/inventory"
  content  = <<EOT
${aws_instance.fbayomide-server1.public_ip}
${aws_instance.fbayomide-server2.public_ip}
${aws_instance.fbayomide-server3.public_ip}
  EOT
}