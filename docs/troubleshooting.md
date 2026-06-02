# Troubleshooting

Registro dos problemas que enfrentei durante a implementação deste projeto e como foram resolvidos.

### Terraform
Output não encontrado após adicionar novo recurso
Erro:

`Error: Output "web_public_ip" not found`

**Causa:** Um novo output foi adicionado ao código mas o terraform apply não foi executado após a mudança. O state file não é atualizado automaticamente com novos outputs.

A solução foi rodar um novo 
```
terraform apply
```

### SSM Session Manager
Plugin não encontrado
Erro:
`SessionManagerPlugin is not found` 

**Causa:** O plugin do Session Manager é separado do AWS CLI e precisa ser instalado individualmente.

A solução foi instalar manualmente. 

### Sessão SSM travada — terminal sem resposta
Terminal fica sem resposta, mostrando apenas `>` para cada Enter.

**Causa:** A sessão SSM caiu mas o terminal não fechou corretamente.
A solução foi pressionar `~.` para forçar o fechamento e abrir uma nova sessão.

### Apache
Site retornando 403 Forbidden

Causa mais comum: Permissões incorretas nos arquivos do site.

A solução foi:
``` 
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
``` 
### Zabbix
Opção PostgreSQL não aparece no assistente de instalação

**Causa:** O pacote php8.1-pgsql não foi instalado, fazendo o frontend mostrar apenas MySQL como opção.

Solução foi instalar o PostgreSQL. 

### Dashboard inacessível na porta 8080

**Causa:** O site padrão do Nginx na porta 80 estava ativo e conflitando com a configuração do Zabbix.

Procurei a informação de onde o Nginx estpava escutando.
``` 
ss -tlnp | grep nginx
``` 
Em seguida removi o padrão e reiniciei o Nginx
```
rm /etc/nginx/sites-enabled/default
systemctl restart nginx
``` 
### Hostname do agente incorreto
O Zabbix Agent aparece como `Zabbix server` em vez do hostname configurado.

**Causa:** O arquivo zabbix_agent2.conf foi editado mas o agente não foi reiniciado.

A solução foi reiniciar o serviço:
```
systemctl restart zabbix-agent2
systemctl status zabbix-agent2 | grep hostname
```
