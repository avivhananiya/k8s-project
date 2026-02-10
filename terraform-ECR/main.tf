provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "wordpress_aviv" {
  name                 = "wordpress-aviv"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "mariadb_aviv" {
  name                 = "mariadb-aviv"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "wordpress_repo_url" {
  value = aws_ecr_repository.wordpress_aviv.repository_url
}

output "mariadb_repo_url" {
  value = aws_ecr_repository.mariadb_aviv.repository_url
}
