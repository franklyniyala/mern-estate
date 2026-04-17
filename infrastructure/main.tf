resource "aws_instance" "mern-estate-ec2-server" {
  ami                         = "ami-01b14b7ad41e17ba4"
  instance_type               = "m7i-flex.large"
  subnet_id                   = aws_subnet.mern-estate-public-subnet[0].id
  vpc_security_group_ids      = [aws_security_group.mern-estate-sg.id]
  key_name                    = "jay"
  associate_public_ip_address = true

  tags = {
    Name = "mern-estate-ec2-server"
  }
}




