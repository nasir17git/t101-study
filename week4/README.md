# 4주차 과제

# Terraform 자체 모듈 구성

## Project Structure

```
.
├── README.md
├── dev
│   ├── aaa
│   │   ├── aaa-main.tf
│   │   ├── aaa-variable.tf
│   │   └── aaa.auto.tfvars
│   └── bbb
│       └── WIP
├── prd
│   └── WIP
└── _modules
    ├── 00network
    │   ├── nw-variable.tf
    │   └── nw-template.tf
    ├── 01alb
    │   ├── alb-template.tf
    │   └── alb-variable.tf
    └── 02ec2
        ├── ec2-template.tf
        └── ec2-variable.tf
```

## 생성 및 접속 결과

<a href="https://ibb.co/LZTZQtm"><img src="https://i.ibb.co/BChC4Zb/trf-result.png" alt="trf-result" border="0"></a>



