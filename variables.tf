variable "aws_region" {
  description = "AWS_region"
  type        = string
}
variable "blue_weight" {
  description = "weight of blue deployment"
  type        = number
}
variable "green_weight" {
  description = "weight of the green deployment"
  type        = number
}