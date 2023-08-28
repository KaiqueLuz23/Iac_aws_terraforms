# Estrutura de Diretórios e Arquivos

## Pasta "./data/"
Nesta pasta, são armazenados os arquivos de "user data" das squads.

- `./data/squad.sh`: Arquivo de "user data" para o projeto 123milhas.
- `./data/squad_bf.sh`: Arquivo de "user data" para o BuscaFacil.

## Pasta "./scripts/"
Aqui estão localizadas as automações relacionadas à criação de bancos de dados, permissões de usuários e backups.

## Arquivo "config.tf"
Este arquivo configura o provider AWS para o Terraform.

## Arquivo "main.tf"
Este arquivo contém as configurações de recursos (resources) no Terraform.

## Arquivo "variables.tf"
Aqui são definidas as variáveis utilizadas para configurar os ambientes das squads (123milhas e buscafacil).

# Descrição

Este repositório contém a estrutura de diretórios e arquivos necessários para gerenciar os ambientes de desenvolvimento das squads 123milhas e BuscaFacil utilizando Terraform. Ele facilita a criação de bancos de dados, a atribuição de permissões aos usuários e a configuração do "user data" dos servidores.

## Configurações de Diretórios

- A pasta "./data/" armazena os arquivos de "user data" específicos para cada squad.
- A pasta "./scripts/" contém os scripts de automação relacionados ao gerenciamento de bancos de dados e permissões.

## Terraform

Os arquivos "config.tf", "main.tf" e "variables.tf" são usados com o Terraform para configurar a infraestrutura na AWS. Eles permitem a criação e gerenciamento de recursos necessários para os ambientes das squads.

Certifique-se de substituir as variáveis relevantes em "variables.tf" de acordo com os requisitos de cada squad e ajustar as configurações de "user data", scripts de automação e outras configurações conforme necessário.

Para mais informações sobre como usar o Terraform, consulte a documentação oficial em [https://www.terraform.io/docs/index.html](https://www.terraform.io/docs/index.html).

