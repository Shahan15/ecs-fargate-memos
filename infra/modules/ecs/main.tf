resource "aws_ecs_cluster" "memos-ecs-cluster" {
  name = "memos-ecs-cluster"
}

resource "aws_ecs_task_definition" "memos-task-definition" {
  family                   = "memos-task-definition"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
  [
    {
        "name" : "memos-container-definition",
        "image": "${var.application-image-uri}",
        "cpu" : 1024,
        "memory" : 2048,
        "essential" : true,
        "portMappings" : [
          {
            "containerPort" : ${var.container_port},
            "hostPort"      : ${var.host_port}
          }
        ]
    }
  ]
TASK_DEFINITION

 runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
 }
}

#ECS Requires a service role to execute commands on your behalf
resource "aws_iam_role" "ecs_execution_role" {
  name = "memos-ecs-execution-role-clean"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_attach" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "memos-ecs-service" {
  name            = "memos-ecs-service"
  cluster         = aws_ecs_cluster.memos-ecs-cluster.id
  task_definition = aws_ecs_task_definition.memos-task-definition.arn
  desired_count   = 2
  launch_type = "FARGATE"

  network_configuration {
    subnets = var.private_subnets
    security_groups = [var.memos_ecs_tasks_sg]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "memos-container-definition"
    container_port   = var.container_port
  }
}