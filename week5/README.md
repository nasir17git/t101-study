# 5주차 과제

# terraform count, for_each, conditionals 실습

- for 표현식과 if 문자열 지시자는 아직 뭔가 어떻게 써먹어야할지 잘 떠오르지가 않습니다
- 해당 실습부분도 VPC 생성 및 보안그룹과 연동해서 구성해보고 싶었는데 연동이 쉽지않네요.. 일단 간단하게 사용 실습만 해보았습니다

##  conditionals 

```
resource "aws_instance" "bastion_server" {
  count         = var.create_bastion == "YES" ? 1 : 0
  ami           = data.aws_ami.amazonlinux2.id
  instance_type = "t3.micro"
  tags = {
    Name = "Bastion Server"
  }
}
```

##  count 

```
resource "aws_instance" "dev_server" {
  count         = var.dev_server
  ami           = data.aws_ami.amazonlinux2.id
  instance_type = "t2.micro"
  tags = {
    Name = "dev-${count.index + 1}"
  }
}
```

##  for_each

``` 
resource "aws_instance" "prod_server" {
  for_each      = var.prod_server
  ami           = each.value["ami"]
  instance_type = each.value["instance_type"]

  root_block_device {
    volume_size = each.value["volume_size"]
  }

  tags = {
    Name = "prod-${each.key}"
  }
}
```