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

## 3. Inicialização e habilitação dos serviços

Habilite os serviços necessários para o funcionamento do Zabbix:

```
systemctl enable postgresql zabbix-server zabbix-agent2 nginx php8.1-fpm
```

Inicie os serviços:

```
systemctl start postgresql zabbix-server zabbix-agent2 nginx php8.1-fpm
```

### Verificação do status dos serviços

Verifique se todos os serviços estão em execução:

```
systemctl status zabbix-server nginx php8.1-fpm postgresql --no-pager
```

Todos os serviços devem apresentar status:

`Active: active (running)`

---

## 4. Suporte ao PostgreSQL no frontend

Caso o frontend do Zabbix não carregue corretamente, instale o suporte ao PostgreSQL para PHP:

```bash
apt-get install -y php8.1-pgsql
systemctl restart php8.1-fpm nginx
```

Após isso, recarregue a página do assistente de instalação no navegador.

---

## 5. Acesso ao Zabbix

Acesse o frontend no navegador:

```text
http://<zabbix_public_ip>:8080
```

Exemplo:

```text
http://13.220.7.101:8080
```

---

## 6. Assistente de configuração inicial
![Tela te instalação do Zabbix](/docs/images/zabbix-installation-screen.png)

No assistente de instalação:

### Passo 1 — Checagem de pré-requisitos (Prerequisites check)

Verifique se todos os itens estão marcados como `OK` e prossiga.

### Passo 2 — Configuração do DB (Database configuration)

Preencha os dados:

* Database type: PostgreSQL
* Host: localhost
* Port: 5432
* Database name: zabbix
* User: zabbix
* Password: `<senha configurada anteriormente>`

### Passo 3 — Confuguração (Settings)

Defina o nome da instância (opcional), por exemplo: `Zabbix Lab`.

### Step 4 — Sumário

Revise as configurações e continue.

### Step 5 — Finalização

Finalize a instalação.
![Zabbix sucessso na instalação](/docs/images/abbix-success-installation.png)

---

## 7. Primeiro acesso

Após concluir a instalação, acesse a tela de login do Zabbix.

Credenciais padrão:

* User: `Admin`
* Password: `zabbix`

Após o login inicial, altere a senha padrão em:

```
User menu → Profile → Change password
```

---

## 8. Próximo passo

Após a configuração inicial do Zabbix, prossiga para a configuração da instância Apache.

➤ [Guia de instalação do Apache](/docs/apache-setup.md)
