# 3주차 과제

## Cpt3. Service Port 나 기타 코드에 고정된 값들을 변수 variables.tf 로 만들어서 사용해보세요

```HCL
/dev/services/webserver-cluster/web-variable.tf

variable "nickname" {
  description = "nickname for tags:Name"
  default     = "nasir"
}

variable "subnet_cidrs" {
  type        = map(any)
  description = "subnet cidr"
  default = {
    mysubnet1 = "10.10.1.0/24"
    mysubnet2 = "10.10.2.0/24"
  }
}

variable "port" {
  description = "EC2 sg inbound port number"
  default     = "8080"
}
```

## Cpt3. 시크릿을 다양한 시크릿 저장소를 활용해 사용해보세요. > vault 활용

로컬 vault 서버 구성 후 기밀데이터 사전 구성

<a href="https://ibb.co/s9WNW6S"><img src="https://i.ibb.co/MkBtBGT/2022-11-06-00-40-39.png" alt="2022-11-06-00-40-39" border="0"></a>      

vault 프로바이더의 vault_generic_secret data로 불러와서 사용

```HCL
/dev/data-stores/mysql/main.tf - Line 19:21

db_name                = data.vault_generic_secret.db_creds.data["db_name"]
username               = data.vault_generic_secret.db_creds.data["db_username"]
password               = data.vault_generic_secret.db_creds.data["db_password"]
```

userdata 적용하여 WEB 화면에 반영된 모습

<a href="https://ibb.co/tBctF2s"><img src="https://i.ibb.co/D4kyTMC/2022-11-06-01-32-18.png" alt="2022-11-06-01-32-18" border="0"></a>


아쉬운점    

- vault_generic_secret 리소스로 사용함
    - 해당 리소스는 일반적인 키=밸류 형식의 데이터를 사용 (k/v secret engine)
    - vault_database_secrets_mount, vault_database_secret_backend_role, vault_database_secret_backend_connection 등의 DB 지향적인?리소스들이 있으나 아직 활용방식 파악 못함 (database secret engine)


구성 참고자료   

[Vault-tutorial](https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-dev-server)    
    > vault 설치 및 로컬 서버 구동  
    > secret 생성 및 관리 방식 파악

[Inject Secrets into Terraform Using the Vault Provider](https://developer.hashicorp.com/terraform/tutorials/secrets/secrets-vault)     
    > vault-terraform-aws 이어지는 작동방식 파악 및 코드 샘플


[VAULT DOCUMENTATION](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/database_secrets_mount)     
    > vault provider로 생성가능한 리소스, 예시, 필수 및 옵션값 설명