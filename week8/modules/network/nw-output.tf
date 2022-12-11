output "vpc" { value = aws_vpc.vpc }
output "pub_ids" { value = values(aws_subnet.pub)[*].id }
output "pri_ids" { value = values(aws_subnet.pri)[*].id }