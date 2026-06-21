resource "aws_security_group" "memos-sg" {
  name        = "memos-sg"
  description = "Security group for memos application, allows all web traffic in and and all traffic out"
  vpc_id      = var.vpc_id_sg

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}