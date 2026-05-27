# Instruções de Execução: 

## Provisionamento da Infraestrutura (Terraform)

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