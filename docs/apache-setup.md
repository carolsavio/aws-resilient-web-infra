# Conectando a instância do Apache

## Acessando a Instância Apache

Abra um novo terminal e conecte-se à instância Apache via AWS Systems Manager:

```
aws ssm start-session --target <web_instance_id> --region us-east-1
```

### Torne-se root

```
sudo -i
```
![conectando o Apache](/docs/images/connecting-apache-and-sudo.png)
---

## Atualização do Sistema

Atualize os pacotes do sistema:

```
apt-get update -y && apt-get upgrade -y
```

> **Observação:** Se aparecer a tela de configuração do Daemon, repita o mesmo procedimento do Zabbix:
>
> * Pressione `Tab` até chegar em `Ok`
> * Pressione `Enter`

Quando finalizar, prossiga para a instalação do Apache.

---

## Instalação do Apache

```
apt-get install -y apache2
```

> Se aparecer a tela do Daemon, siga o mesmo procedimento (`Tab` + `Enter`).

---

## Habilitar e Iniciar o Apache

```
systemctl enable apache2
systemctl start apache2
systemctl status apache2 --no-pager
```
![Apache rodando](/docs/images/apache-running.png)
---

## Validar Funcionamento do Apache

Execute:

```
curl http://localhost
```

Se retornar o HTML padrão do Apache, o servidor está funcionando corretamente.

---

# Configuração do mod_status

O módulo `mod_status` será utilizado pelo Zabbix para coletar métricas do Apache.

Crie a configuração:

```
cat > /etc/apache2/conf-available/status.conf << 'EOF'
<Location "/server-status">
    SetHandler server-status
    Require local
</Location>
ExtendedStatus On
EOF
```

Habilite a configuração e o módulo:

```
a2enconf status
a2enmod status
systemctl reload apache2
```

---

## Validar Endpoint de Status

```bash
curl http://localhost/server-status?auto
```

O retorno deverá exibir métricas como:

* Total Accesses
* Total kBytes
* BusyWorkers
* IdleWorkers

Esses dados serão coletados pelo Zabbix.

---

# Instalação do Zabbix Agent 2

Adicione o repositório oficial:

```
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-2+ubuntu22.04_all.deb

dpkg -i zabbix-release_7.0-2+ubuntu22.04_all.deb

apt-get update -y
```

Instale o agente:

```
apt-get install -y zabbix-agent2
```

> Caso apareça a tela do Daemon, utilize novamente:
>
> * `Tab`
> * `Enter`

---

# Descobrir o IP Privado do Servidor Zabbix

Primeiro tente:

```
terraform output
```

Se o comando não retornar informações, utilize a AWS CLI:

```
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=Zabbix-Server" \
  --query "Reservations[].Instances[].PrivateIpAddress" \
  --output text \
  --region us-east-1
```

Anote o IP privado retornado.

Exemplo:

```
10.0.0.11
```

---

# Configurar o Zabbix Agent

Volte para o terminal da instância Web e edite o arquivo:

```bash
nano /etc/zabbix/zabbix_agent2.conf
```

Altere os parâmetros:

```ini
Server=10.0.0.11
ServerActive=10.0.0.11
Hostname=web-server-apache
```
![Exemplo do nano ServerActive](/docs/images/nano-serveractive.png)

Salve utilizando:
`Ctrl` + `x`, `y` e `Enter`

---

# Iniciar o Agente

```
systemctl enable zabbix-agent2
systemctl start zabbix-agent2
systemctl status zabbix-agent2 --no-pager
```

Reinicie para garantir que a configuração foi aplicada:

```
systemctl restart zabbix-agent2
systemctl status zabbix-agent2 --no-pager | grep -E "Active|hostname"
```

---

# Cadastro do Host no Zabbix

Acesse o dashboard do Zabbix.

Navegue para:

```text
Data collection → Hosts → Create host
```
![Tela de criação de Host no zabbix](/docs/images/zabbix-create-hosts.png)
Preencha:

### Host

Host name: web-server-apache

### Templates

Adicionar:

* Linux by Zabbix agent
* Apache by Zabbix agent

### Host Groups

```
Linux servers
```

### Interface Agent

Clique em **Add → Agent**:

```text
IP: 10.0.0.7
Port: 10050
```

> Confirme o IP privado da instância Web com:

```
terraform output web_private_ip
```

Clique em **Add**.

![Criando o host](/docs/images/zabbix-new-host.png)
---

# Monitoramento

Após alguns minutos, navegue para:

**Monitoring** → Hosts


Localize:
`web-server-apache`


Clique em **Dashboards** para visualizar:

* CPU
* Memória
* Rede
* Métricas do Apache
* Workers ativos
* Requisições HTTP

O Zabbix estará coletando dados reais do Apache em tempo real.

![Dashboard do apache no zabbix](/docs/images/host-apache-dashboard.png)
---

# Consultar o Apache Pelo IP Público

Obtenha o IP público da instância:

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=Apache-Web-Server" \
  --query "Reservations[].Instances[].PublicIpAddress" \
  --output text \
  --region us-east-1
```

Exemplo de retorno:

```
3.236.90.140
```

Acesse no navegador:

```text
http://3.236.90.140
```
Você verá o html padrão do apache.

---

# Personalizar a Página Inicial do Apache

Baixe o HTML personalizado no repositório:

```
curl -o /var/www/html/index.html \
  https://raw.githubusercontent.com/carolsavio/aws-resilient-web-infra/main/website/index.html
```

---

## Validar Atualização

```
curl http://localhost
```

Ou acesse novamente pelo IP público da instância:

```text
http://<IP_PUBLICO>
```

Você deverá visualizar a página personalizada no lugar da página padrão do Apache.

![index do apache funcionando](/docs/images/apache-on.png)

---

# Resultado Final

Ao concluir todos os passos:

➤ Apache instalado e operacional

➤ Endpoint `/server-status` configurado

➤ Zabbix Agent 2 instalado

➤ Host cadastrado no Zabbix

➤ Monitoramento do Apache ativo

➤ Página web personalizada publicada
