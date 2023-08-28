terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "http" {
  }
}

provider "aws" {
    access_key = "${var.AWS_ACESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
    region = "us-east-1"
}

