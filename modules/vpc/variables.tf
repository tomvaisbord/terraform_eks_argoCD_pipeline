variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for public subnet in AZ-a"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for public subnet in AZ-b"
  type        = string
  default     = "10.0.4.0/24"
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for private subnet in AZ-a"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for private subnet in AZ-b"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone_a" {
  description = "Primary AWS availability zone for subnets"
  type        = string
  default     = "eu-north-1a"
}

variable "availability_zone_b" {
  description = "Secondary AWS availability zone for subnets"
  type        = string
  default     = "eu-north-1b"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
