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

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "memos_ecs_tasks_sg" {
  name        = "memos-tasks-sg"
  description = "Only allows traffic from the ALB"
  vpc_id      = var.vpc_id_sg

  ingress {
    from_port       = 8081 
    to_port         = 8081
    protocol        = "tcp"
    
    #only allows traffic from ALB
    security_groups = [aws_security_group.memos-sg.id] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}