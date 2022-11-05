output "public_ips" {
  value       = data.aws_instances.get_data.public_ips
}

output "nasir_alb_dns" {
  value       = aws_lb.nasir_alb.dns_name
  description = "The DNS Address of the ALB"
}