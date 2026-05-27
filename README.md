# Deploy AWS Automatizado: Arquitetura, Backup S3 e Monitoramento

![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=flat&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![Apache](https://img.shields.io/badge/Apache-D22128?style=flat&logo=Apache&logoColor=white)
![Zabbix](https://img.shields.io/badge/Zabbix-D40000?style=flat&logo=Zabbix&logoColor=white)
![Status](https://img.shields.io/badge/Status-WIP-orange?style=flat)


>## Aviso

>A infraestrutura e scripts ainda estão sendo construidos e refinados. Algumas instruções do README podem ficar temporariamente desatualizadas...

## Visão Geral
Este repositório contém a documentação e os scripts para a implementação de uma infraestrutura web resiliente na AWS. O projeto demonstra o ciclo de vida completo de uma operação em nuvem, partindo do provisionamento via Infrastructure as Code (IaC) até a implementação de rotinas de backup e monitoramento contínuo.

## Tecnologias e Ferramentas
- **Cloud Provider:** AWS (EC2, S3, IAM, VPC, Systems Manager)
- **IaC:** Terraform
- **OS & Web Server:** Linux (Ubuntu/Amazon Linux), Apache
- **Automação:** Python, Boto3, Cron
- **Observabilidade:** Zabbix (Server e Agent)

---
## Instruções de Execução: Provisionamento da Infraestrutura (Terraform)

Os passos abaixo irão provisionar os recursos base do laboratório (VPC, Subnets, Instâncias EC2, IAM Roles, Security Groups e Bucket S3) na sua conta AWS.

### Pré-requisitos
- [Terraform](https://developer.hashicorp.com/terraform/downloads) instalado.
- [AWS CLI](https://aws.amazon.com/pt/cli/) instalado e configurado.
- Git.

### Passo 1: Clonar o Repositório

Faça o clone do projeto para a sua máquina local:

```
git clone https://github.com/carolsavio/aws-resilient-web-infra.git
cd aws-resilient-web-infra
```

### Passo 2: Autenticação na AWS
O Terraform utiliza o perfil local da AWS CLI para realizar o *deploy* em segurança, sem necessitar de credenciais (chaves) expostas no código. No seu terminal, execute:
```
aws configure
```

### Passo 3: Inicialização do Terraform
```
terraform init
```
### Passo 4: Validar plando de execuração do Terraform
Verifique se o plano gerado está correto, e confirme quais os recursos exatos que serão criados na AWS antes de aplicar qualquer mudança:
```
terraform plan
```

### Passo 5: Aplicação e Provisionamento
Execute a criação da arquitetura. 
```
terraform apply
```
O Terraform irá pedir uma confirmação de segurança, digite `yes` se estiver tudo certo e aperte `Enter` para prosseguir.

### Passo 6: Destruição do Ambiente
Para evitar custos não planejados na sua conta AWS após a conclusão dos testes do laboratório, você pode destruir tudo com um cmando só:
```
terraform distroy
```