resource "aws_ecr_repository" "flask" {
  name                 = "docker-flask"
  image_tag_mutability = "MUTABLE"
  force_delete = true
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
    repository = aws_ecr_repository.flask.name
    policy = <<EOF
        {
            "rules": [
                {
                "rulePriority": 1,
                "description": "Expire untagged images older than 14 days",
                "selection": {
                    "tagStatus": "untagged",
                    "countType": "sinceImagePushed",
                    "countUnit": "days",
                    "countNumber": 14
                },
                "action": {
                    "type": "expire"
                }
                }
            ]
        }
        EOF
}