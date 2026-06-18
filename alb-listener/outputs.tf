output "listener_id" {
  description = "ID of the ALB listener"
  value       = aws_lb_listener.alb_listener.id
}

output "listener_arn" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.alb_listener.arn
}
