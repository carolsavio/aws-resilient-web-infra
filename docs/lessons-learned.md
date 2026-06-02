# Lições Aprendidas
Reflexões e aprendizados obtidos durante a implementação deste projeto do zero.

---

## Terraform

### Estrutura modular exige disciplina

Trabalhar com módulos Terraform é mais organizado, mas qualquer novo recurso exige mudanças em pelo menos três lugares: o recurso dentro do módulo, a variável que o módulo recebe e o output que ele expõe para fora. Esquecer qualquer um dos três gera erros que podem parecer confusos no começo.

A lição: ao adicionar qualquer coisa nova em um módulo, já abrir os três arquivos (`main.tf`, `variables.tf`, `outputs.tf`) ao mesmo tempo.


---

### `terraform output` 

Sempre configurar outputs para tudo que você vai precisar depois — IPs públicos, IPs privados, IDs de instâncias, nome do bucket. Sem outputs você fica recorrendo ao console da AWS ou ao AWS CLI para pegar informações que o Terraform já tem.

---

## AWS

### SSM é superior ao SSH para laboratório

O AWS Systems Manager Session Manager elimina a necessidade de chaves `.pem`, regras de Security Group para a porta 22 e qualquer exposição desnecessária. O acesso é controlado pela IAM Role da instância e pelo usuário AWS. Para um laboratório de aprendizado, é a abordagem mais segura.

---

### IP privado para comunicação entre instâncias

Instâncias dentro da mesma VPC sempre devem se comunicar pelo IP privado, nunca pelo público. O IP privado não muda enquanto a instância estiver rodando. O IP público pode mudar após uma reinicialização se não houver Elastic IP.

No contexto deste projeto: o Zabbix Agent na instância web aponta para o IP privado do Zabbix Server, ex:`10.0.0.11`, não para o IP público.


---

### Confirmar em qual instância você está

Com duas instâncias rodando e múltiplas sessões SSM abertas, é fácil executar comandos na instância errada. 

---

## Apache

### mod_status é essencial para monitoramento

O template `Apache by Zabbix agent` depende do endpoint `/server-status?auto` para coletar métricas. Sem habilitar o `mod_status` e o `ExtendedStatus On`, o Zabbix não consegue dados do Apache mesmo que o agente esteja funcionando perfeitamente. São componentes separados que precisam ser configurados independentemente.

---

### reload vs restart

`systemctl reload apache2` recarrega a configuração sem derrubar conexões ativas. `systemctl restart apache2` reinicia o processo completamente. Para alterações de configuração em produção, sempre usar `reload`. O `restart` só é necessário quando o processo precisa ser reiniciado de verdade.

---

## Zabbix

### PostgreSQL precisa do pacote PHP separado

A instalação do Zabbix no Ubuntu não instala automaticamente o suporte PHP ao PostgreSQL. Sem o pacote `php8.1-pgsql`, o assistente de instalação web só mostra MySQL como opção de banco. Sempre instalar `php8.1-pgsql` junto com os demais pacotes do Zabbix.

---

### O site padrão do Nginx conflita com o Zabbix

O Ubuntu instala o Nginx com um site padrão ativo na porta 80. A configuração do Zabbix usa a porta 8080, mas o site padrão pode interferir. 

---

### Trocar a senha padrão imediatamente

O Zabbix vem com login `Admin` / `zabbix` por padrão. Esse login é público e amplamente conhecido. Trocar a senha é o primeiro passo obrigatório após acessar o dashboard pela primeira vez.

---

## Python

### boto3 usa a IAM Role automaticamente

O cliente boto3 busca credenciais na seguinte ordem: variáveis de ambiente, arquivo de configuração, Instance Metadata Service. Em uma instância EC2 com IAM Role, as credenciais são encontradas automaticamente no IMDS sem nenhuma configuração. Não é necessário passar `aws_access_key_id` ou `aws_secret_access_key` para o cliente.

---

### Testar o script manualmente antes do cron

Sempre rodar o script de backup manualmente pelo menos uma vez antes de configurar o cron. O cron roda em silêncio, se o script tiver um erro, você só vai descobrir verificando o log. Testando manualmente você vê a saída em tempo real e confirma que o arquivo chegou no S3 antes de confiar na automação.

---

## Geral

### Documentar durante, não depois

Documentar depois de implementar é difícil porque os detalhes se perdem. A abordagem mais eficiente é anotar os comandos enquanto executa e registrar os erros no momento em que acontecem. O troubleshooting deste projeto foi construído exatamente assim, cada erro foi registrado no momento em que ocorreu.

