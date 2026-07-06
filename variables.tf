variable "public_cidr" {
  description = "The CIDR block for the public subnet"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "private_cidr" {
  description = "The CIDR block for the private subnet"
  type        = list(string)
  default     = ["10.0.100.0/24", "10.0.200.0/24"]
}