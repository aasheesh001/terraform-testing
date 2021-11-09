 resource "aws_instance" "webserver" {
   ami = data.aws_ami.ubuntu.id
   instance_type = "t2.micro"
   associate_public_ip_address = true
   tags = {
       Name = "webserver"
   }
   user_data = "${file("install_nginx.sh")}"
   key_name = aws_key_pair.ec2_access.key_name
   vpc_security_group_ids = [ aws_security_group.ec2_sg2.id ]
 }

 resource "aws_security_group" "ec2_sg2" {
   name        = "EC2_SG2"
   description = "Security group linked with EC2 instance"
   ingress {
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
 }

resource "aws_security_group_rule" "example" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2_sg2.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "example1" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2_sg2.id
  cidr_blocks = ["0.0.0.0/0"]
}

 output "public_ip" {
   value = aws_instance.webserver.public_ip
 }

resource "aws_key_pair" "ec2_access" {
  key_name    = "ec2_access"
  public_key  = file("C:\\Users\\I354200\\Desktop\\DevOps\\AWS\\New_Test\\ec2_access.pub")
}