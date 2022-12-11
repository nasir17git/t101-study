output "instance" { value = aws_instance.ec2 }
output "ec2-values" { value = values(aws_instance.ec2)[*] }
output "ec2-ids" { value = values(aws_instance.ec2)[*].id }
output "ec2-sg" { value = aws_security_group.ec2 }