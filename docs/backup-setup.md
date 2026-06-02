# Implementando automação de Backup com Python e Cron

Conecte-se na instância web via SSM e instale o boto3:
``` 
sudo -i
pip install boto3
```
![](/docs/images/install-boto3.png)

> Apesar geralmente o `pip` vir junto a instalação padrão do Python, pode ser necessário instalar separadamente.

Crie uma pasta para o script:
```
mkdir -p /opt/backup
nano /opt/backup/backup.py
```
Cola o script Python do projeto dentro do arquivo do `nano`, substituindo a var `BUCKET` pelo nome do seu bucket:

 ➤ [Acesse o script aqui](/python/backup.py)

 ![](/docs/images/backup-python-script.png)

 Caso precise, procure pelo nome do bucket:
 ``` 
 aws s3 ls
 ``` 
 Teste manualmente:
 ``` 
 python3 /opt/backup/backup.py
 ``` 
 Confirme em: 
 ``` 
 aws s3 ls s3://<seu-bucket-name>/backups/
 ```

 Se tudo estiver OK, configure o Cron: 
 ```
 echo "30 2 * * * root python3 /opt/backup/backup.py" > /etc/cron.d/web-backup
chmod 644 /etc/cron.d/web-backup
cat /etc/cron.d/web-backup
 ``` 
 ![](/docs/images/cron-config.png)

 ---
 Retornar para o README:
 ➤ [README](/README.md)