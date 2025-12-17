resource "aws_ecr_repository" "app" {
  name = "multi-platform-app"

  image_scanning_configuration {
    scan_on_push = true
  }
}
