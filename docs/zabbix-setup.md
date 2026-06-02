# Instalação e configuração do Zabbix

Após provisionar a infraestrutura com o Terraform e deixar tudo no "ar", obtenha os IDs e endereços IP gerados, pois eles serão necessários durante a configuração do Zabbix e Apache.

No bash logo em seguida, em `aws-resilent-web-infra/terraform`:
```
terraform output
``` 
O comando exibirá os IDs e IPs das duas instâncias. Guarde essas informações em um bloco de notas para as etapas seguintes.

### Pré-requisito

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


---
