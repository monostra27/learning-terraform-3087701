variable "instance_type" {
 description = "Type of EC2 instance to provision"
 default     = "t2.nano"
}
variable "AWS_SECRET_ACCESS_KEY" {
  description = "The AWS secret access key"
  type        = string
  sensitive   = true # Mark as sensitive to prevent display in logs
}
