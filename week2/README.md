# 2주차 과제 
## Cpt2. 닉네임을 리소스 이름으로 한 ALB/ASG 생성 후 연동

웹 브라우저에서 ALB dns name으로 접속한 결과

<a href="https://ibb.co/Tb2PJHm"><img src="https://i.ibb.co/hZ92rKD/cpt2-web-result.png" alt="cpt2-web-result" border="0"></a>

터미널에서 curl 명령어로 ALB, 각 EC2에 접속한 결과

<a href="https://ibb.co/7C2cWrb"><img src="https://i.ibb.co/r04P65v/cpt2-web-result2.png" alt="cpt2-web-result2" border="0"></a>

## Cpt3. 생성된 리소스를 S3 버킷에 저장후 DynamoDB를 통한 Locking 

생성된 리소스 변경이 완료되기 전, 변경 시도 테스트 결과

<a href="https://ibb.co/nmCTB7Q"><img src="https://i.ibb.co/YQZ6Xcf/cpt3-lock-result.png" alt="cpt3-lock-result" border="0"></a>
