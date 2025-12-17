resource "aws_ecs_cluster" "ecs" {
  name = "ecs-demo-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "multi-platform-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name  = "web-app"
      image = "${aws_ecr_repository.app.repository_url}:latest"
      portMappings = [{
        containerPort = 8080
      }]
      environment = [{
        name  = "PLATFORM"
        value = "ECS-Fargate"
      }]
    }
  ])
}
resource "aws_ecs_task_definition" "multi_platform_task" {
  family                   = "multi-platform-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "web-app"
      image     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/multi-platform-app:latest"
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "PLATFORM"
          value = "ECS-Fargate"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_web_service" {
  name            = "ecs-web-service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.multi_platform_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-xxxx", "subnet-yyyy"]
    security_groups = ["sg-xxxx"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:region:account-id:targetgroup/xxxx"
    container_name   = "web-app"
    container_port   = 8080
  }
}

