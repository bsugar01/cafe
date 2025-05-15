provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-html-website-bucket"
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}
