variable "instance_type" {
 description = "Type of EC2 instance to provision"
 default     = "t3.micro"
}
variable "AWS_SECRET_ACCESS_KEY" {
  description = "The AWS secret access key"
  type        = string
  sensitive   = true # Mark as sensitive to prevent display in logs
}
