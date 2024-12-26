We will deploy the dockerized Flask application on AWS EC2 with GitHub Actions. We will follow the Devops core principle - CICD(continuous integration and continuous deployment) to build and deploy the application on every code change. 

Whenever we change the Python code, its dependencies, and Dockerfile, GitHub Action workflow will build a new Docker image, push it to AWS ECR, and deploy a new version of the Docker container that we can access using EC2 instances public IP on port 5000.
