variable "prefix" {
  type    = string
  default = "hashicardo"
}

variable "page_title" {
  type    = string
  default = "Hello, world!"
}

variable "image_url" {
  type = string
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "default_tags" {
  type = map(string)
  default = {
    Environment = "demo"
    Project     = "simple-ec2"
  }
}

