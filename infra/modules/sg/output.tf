output "sg_id" {
  value = aws_security_group.memos-sg.id
  description = "This is the ID of our Security Group"
}

output "memos_ecs_tasks_sg_id" {
  value = aws_security_group.memos_ecs_tasks_sg.id
}