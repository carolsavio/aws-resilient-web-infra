# Instalação e configuração do Zabbix

Após provisionar a infraestrutura com o Terraform e deixar tudo no "ar", obtenha os IDs e endereços IP gerados, pois eles serão necessários durante a configuração do Zabbix e Apache.

No bash logo em seguida, em `aws-resilent-web-infra/terraform`:
```
terraform output
``` 
O comando exibirá os IDs e IPs das duas instâncias. Guarde essas informações em um bloco de notas para as etapas seguintes.

## 1 - Pré-requisito

Antes de iniciar as instalações, é necessário instalar o plugin AWS Session Manager na máquina local. Esse componente é distribuído separadamente do **AWS CLI**.

**Linux:**
```
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
``` 
>Note que é possivel que a instalação "trave" no dpkg esperando a senha, se isso acontecer, aperte `Ctrl` + `c` e rode os comandos separadamente.

**Mac:**
```
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"
unzip sessionmanager-bundle.zip
sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
```
Para **Windows**: baixe o instalador direto no site da Aws: [AWS Session Manager](https://s3.amazonaws.com/session-manager-downloads/plugin/latest/windows/SessionManagerPluginSetup.exe)

Depois confira em:
``` 
session-manager-plugin --version
``` 

## 2. Conectando à instância Zabbix

Inicie uma sessão na instância Zabbix utilizando o AWS Session Manager:

```
aws ssm start-session --target <zabbix_instance_id> --region us-east-1
```


### Verificando o usuário atual

Após conectar, confirme o usuário da sessão:

```
whoami
```

A saída esperada é:

```text
ssm-user
```
![Print do bash](/docs/images/zabbix-whoami-ssm-user.png)

Em seguida, entre como `root`:

```
sudo -i
```

### Atualizando o sistema

Atualize os pacotes instalados:

```
apt-get update -y && apt-get upgrade -y
```

Durante a atualização poderá ser exibida uma tela de configuração de serviços (*Daemons*). Mantenha a opção padrão e confirme.
![Tela de configuração do Deamons](/docs/images/daemons-screen-in-zabbix-update.png)

### Instalando o repositório do Zabbix

Adicione o repositório oficial do Zabbix 7.0 para Ubuntu 22.04:

```
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-2+ubuntu22.04_all.deb

dpkg -i zabbix-release_7.0-2+ubuntu22.04_all.deb

apt-get update -y
```

### Instalando os componentes do Zabbix

Instale o servidor Zabbix, frontend web, agente e banco de dados PostgreSQL:

```bash
apt-get install -y \
  zabbix-server-pgsql \
  zabbix-frontend-php \
  zabbix-nginx-conf \
  zabbix-sql-scripts \
  zabbix-agent2 \
  postgresql
```

Durante a instalação, uma nova tela de configuração de serviços poderá ser exibida. Mantenha as opções padrão.

### Configurando o PostgreSQL

Crie o usuário do banco de dados:

```
sudo -u postgres createuser --pwprompt zabbix
```

Informe uma senha e guarde-a, pois ela será utilizada na configuração do Zabbix.

Crie o banco de dados:

```
sudo -u postgres createdb -O zabbix zabbix
```

Importe o schema inicial do Zabbix:

```bash
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz \
  | sudo -u zabbix psql -U zabbix -d zabbix
```

Esse processo cria todas as tabelas, índices e dados necessários para o funcionamento do Zabbix.

### Configurando o Zabbix Server

Abra o arquivo de configuração:

```
nano /etc/zabbix/zabbix_server.conf
```

Localize a diretiva:

```
#DBPassword=
```

Remova o comentário e informe a senha criada anteriormente:

```
DBPassword=<senha-do-usuario-zabbix>
```

Salve o arquivo e feche o editor.

> **Observação:** Em ambientes de produção, recomenda-se armazenar credenciais em um serviço dedicado de gerenciamento de segredos, como o AWS Secrets Manager, evitando senhas em texto plano em arquivos de configuração.

### Configurando o Nginx

Abra o arquivo de configuração do frontend:

```
nano /etc/zabbix/nginx.conf
```

Localize as linhas:

```
#        listen          80;
#        server_name     example.com;
```

Altere para:

```nginx
        listen          8080;
        server_name     _;
```

Salve o arquivo e feche o editor.

O valor `_` em `server_name` atua como um coringa, permitindo acesso ao frontend independentemente do nome de domínio utilizado. Em ambientes de produção, recomenda-se configurar um domínio específico.
