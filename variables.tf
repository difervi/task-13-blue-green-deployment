variable "aws_region" {
  description = "AWS region"
  type        = string
}
variable "blue_weight" {
  description = "Weight of blue deployment"
  type        = number
}
variable "green_weight" {
  description = "Weight of the green deployment"
  type        = number
}
variable "blue_template_name" {
  description = "Name of the Blue launch template"
  type        = string
}
variable "green_template_name" {
  description = "Name of the Green launch template"
  type        = string
}
variable "blue_tg_name" {
  description = "Name of the Blue target group"
  type        = string
}
variable "green_tg_name" {
  description = "Name of the Green target group"
  type        = string
}
variable "blue_asg_name" {
  description = "Name of the Blue Auto Scaling Group"
  type        = string
}
variable "green_asg_name" {
  description = "Name of the Green Auto Scaling Group"
  type        = string
}
variable "lb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}