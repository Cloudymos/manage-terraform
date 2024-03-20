#!/bin/bash

if [ $# -eq 0 ]
    then
        echo "Selecione uma das opcoes"
        echo "Para config inicial rodar um 'source deploy.sh config'
        echo $0" <config | fmt | init | plan | apply | destroy | clean | go | goodbye>" 
        exit 1
fi 

#implementar um ambiente pos config pra não precisar entrar no script e trocar o ENV toda vez


case $1 in
    config)
    export TF_LOG=debug                                             # modo DEBUG
    export TF_LOG_PATH=./terraform.log                              # cria arquivo LOG
    export TF_PLUGIN_CACHE_DIR="$APPDATA/terraform.d/plugin-cache"  # fornece um diretorio para cache dos plugins
    export TF_VAR_repo=`echo "${PWD##*/}"`                          # configura nome do repositório de origem
    export ENV="your_env"
    
    ;; 
    fmt)
        echo "## Iniciando $1. ##"
        terraform fmt
        terraform fmt tfvars/
        terraform validate
        duration=$SECONDS # armazena a duração do processo na variável 'duration'
        echo "Levou $duration segundos para executar o $1."
        ;; 
    init)
        SECONDS=0
        echo "## Iniciando $1. ##"
        terraform init
        duration=$SECONDS # armazena a duração do processo na variável 'duration'
        echo "Levou $duration segundos para executar o $1."
        ;;
    plan)
        SECONDS=0
        echo "## Iniciando $1. ##"
        terraform fmt
        terraform validate
        terraform plan -var-file="tfvars/$ENV.tfvars" -out="$ENV.tfplan"
        duration=$SECONDS # armazena a duração do processo na variável 'duration'
        echo "## Levou $duration segundos para executar o $1. ##"
        ;;
    apply)
        SECONDS=0
        echo "## Iniciando $1. ##"
        terraform apply -auto-approve "$ENV.tfplan"
        duration=$SECONDS # armazena a duração do processo na variável 'duration'
        echo "Levou $duration segundos para executar o $1."
        ;;
    go)
        SECONDS=0
        echo "## Iniciando $1. ##"
        terraform plan -var-file="tfvars/$ENV.tfvars" -out="$ENV.tfplan"
        terraform apply -auto-approve "$ENV.tfplan"
        duration=$SECONDS # armazena a duração do processo na variável 'duration'
        echo "Levou $duration segundos para executar o $1."
        ;;
    goodbye)
        SECONDS=0
        echo "## Iniciando $1. ##"
        terraform plan -var-file="tfvars/$ENV.tfvars" -out="$ENV.tfplan"
        terraform destroy -auto-approve "$ENV.tfplan"
        duration=$SECONDS # armazena a duração do processo na variável 'duration'
        echo "Levou $duration segundos para executar o $1."
        ;;
    destroy)
        SECONDS=0
        echo "## Executando $1. ##"
        terraform destroy -auto-approve -var-file="tfvars/$ENV.tfvars"
        duration=$SECONDS # armazena a duração do processo na variável 'duration'
        echo "## Levou $duration segundos para executar o $1."
        ;;
    clean)
        rm -rf .terraform
        rm -rf *.tfplan
        rm -rf *.log
        rm -rf *.lock.hcl
        rm -rf *.tfstate
        rm -rf *.backup
        rm -rf .terraform.lock.hcl
        echo "$1 finalizado."
        ;;
    lock)
        terraform providers lock
        echo "$1 finalizado."
        ;;
    *)
        echo "erro, selecione uma opcao valida."
        ;;
esac