terraform {
  backend "s3" {
    bucket = "backendterraform-state"
    key    = "python-webapp-aws-cicd-state"
    region = "ap-south-1"
  }
}