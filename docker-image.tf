resource "null_resource" "build_and_push_image" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.flask.repository_url}
      docker build -t ${aws_ecr_repository.flask.repository_url}:latest .
      docker push ${aws_ecr_repository.flask.repository_url}:latest
    EOT
  }
}