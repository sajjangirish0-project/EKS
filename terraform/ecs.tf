resource "aws_ecs_service" "ecs_web_service" {
  name            = "ecs-web-service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.multi_platform_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    # Dynamically use the subnets from your eks.tf data source
    subnets          = data.aws_subnets.eks.ids
    # You should reference a security group resource here
    security_groups  = [aws_security_group.ecs_sg.id] 
    assign_public_ip = true
  }

  load_balancer {
    # DO NOT use the string "arn:aws:elasticloadbalancing:region..."
    # Reference your actual target group resource name here:
    target_group_arn = aws_lb_target_group.app_tg.arn 
    container_name   = "web-app"
    container_port   = 8080
  }
}