# Deploy AWS Automatizado: Arquitetura, Backup S3 e Monitoramento

![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=flat&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![Apache](https://img.shields.io/badge/Apache-D22128?style=flat&logo=Apache&logoColor=white)
![Zabbix](https://img.shields.io/badge/Zabbix-D40000?style=flat&logo=Zabbix&logoColor=white)
![Status](https://img.shields.io/badge/Status-WIP-orange?style=flat)

![Descrição da imagem](./docs/images/banner-infra.png)

## Visão Geral
Este projeto implementa um servidor web Apache hospedado na AWS, monitorado em tempo real pelo Zabbix e com backup diário automatizado para o S3. Todo o acesso às instâncias é feito via AWS Systems Manager, sem nenhuma chave SSH.


## Tecnologias e Ferramentas
- **Cloud Provider:** AWS (EC2, S3, IAM, VPC, Systems Manager)
- **IaC:** Terraform
- **OS & Web Server:** Linux (Ubuntu/Amazon Linux), Apache
- **Automação:** Python, Boto3, Cron
- **Observabilidade:** Zabbix (Server e Agent)

## Projeto em produção:
### Site no ar
![Site do apache online](/docs/images/apache-on.png)


### Zabbix - Métricas de CPU/ Discos em tempo real
![Zabbix métricas de CPU](/docs/images/zabbix-cpu.png)
![Zabiix métricas de Discos](/docs/images/zabbix-discs.png)

### AWS Console - Intância EC2 rodando
![Métricas da instancia rodando no EC2](/docs/images/instance-ec2.png)

### AWS Backup funcionando
![Backup armazenado no S3](/docs/images/backup.png)

## Estrutura do Repositório
```
aws-resilient-web-infra/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── output.tf
│   ├── providers.tf
│   └── modules/
│       ├── compute/
│       ├── network/
│       ├── security/
│       └── storage/
├── python/
│   └── backup.py
├── website/
│   └── index.html
├── docs/
│   ├── images/
│   ├── apache-setup.md
│   ├── backup-seturp.md
│   ├── setup.md
│   ├── zabbix-setup.md
│   ├── troubleshooting.md
│   └── lessons-learned.md
└── README.md

```
## Pré-requisitos

- Conta AWS com permissões de EC2, S3, IAM e SSM
- Terraform
- AWS CLI configurado
- Session Manager Plugin instalado

## Como executar:
Clone o repositório:
```
git clone https://github.com/carolsavio/aws-resilient-web-infra.git
cd aws-resilient-web-infra/terraform
``` 
Configure suas credenciais da AWS
```
aws configure
```
Inicie a infraestrutura em Terraform
```
terraform init
terraform plan
terraform apply
```
Após o `apply`, conecte nas instâncias via SSM e instale o Apache e o Zabbix manualmente conforme documentado em `docs/apache-setup.md` e `docs/zabbix-setup.md`.

---
## Documentação do projeto

Para obter instruções completas de configuração, provisionamento de infraestrutura e etapas de reprodução do projeto, consulte:

➤ [Guia de primeiros passos](./docs/setup.md)

➤ [Guia do Zabbix](/docs/zabbix-setup.md)

➤ [Guia do Apache](/docs/apache-setup.md)

➤ [Guia da automação de Backup](/docs/backup-setup.md)

➤ [Lições Aprendidas](/docs/lessons-learned.md)

➤ [Troubleshooting](/docs/troubleshooting.md)

## Destruição do Ambiente
Para evitar custos não planejados na sua conta AWS após a conclusão dos testes do laboratório, você pode destruir tudo com um comando só:
```
terraform destroy
``` 



