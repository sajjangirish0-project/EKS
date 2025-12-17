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
