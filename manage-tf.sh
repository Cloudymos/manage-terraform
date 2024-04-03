#!/bin/bash

if [ $# -eq 0 ]
    then

echo "..:''''''''''''''''''''''''''''''''''''''''''''''''''''''''':.."
echo ": :  _                          _            _              : :"
echo ": : | |_ ___ _ __ _ __ __ _  __| | ___ _ __ | | ___  _   _  : :"
echo ": : | __/ _ \ |__| |__/ _| |/ _| |/ _ \ |_ \| |/ _ \| | | | : :"
echo ": : | ||  __/ |  | | | |_| | (_| |  __/ |_) | | (_) | |_| | : :"
echo ": :  \__\___|_|  |_|  \__|_|\__|_|\___| |__/|_|\___/ \__| | : :"
echo ": :                                   |_|             |___| : :"
echo ":.:.........................................................:.:"
        echo "Initial setup on bash: 'source deploy.sh config'"
        echo "## basic options - behaves the same as terraform but with steroids ##" 
        echo $0 "( init | plan | apply | destroy | fmt )"
        echo "## custom options ##"
        echo $0 "( clean | go | goodbye )"       
        exit 1
fi 

#implementar um ambiente pos config pra não precisar entrar no script e trocar o ENV toda vez


case $1 in
    
    config)
    export TF_LOG=error                                             # set debug level on your logs valid options [TRACE , DEBUG , INFO , WARN or ERROR]
    export TF_LOG_PATH=./terraform.log                              # create a log file for your to troubleshoot, change according to your needs
    export TF_PLUGIN_CACHE_DIR="$APPDATA/terraform.d/plugin-cache"  # plugins cache dir
    export TF_VAR_repo=`echo "${PWD##*/}"`                          # configura nome do repositório de origem
    #export ENV="your_env"                                           # sets the env youre working, really depends on your tfvars structure - recommended to put everything inside tfvars/env.tfvars
    #export TF_WORKSPACE=your_workspace
    echo '## setup done ##'
    ;; 
    fmt)
        SECONDS=0
        echo "## Iniciando $1. ##"
        terraform fmt
        terraform fmt tfvars/
        terraform validate
        duration=$SECONDS
        echo "Levou $duration segundos para executar o $1."
        ;;

    init)
        SECONDS=0
        echo "## Iniciando $1. ##"
        terraform init
        duration=$SECONDS
        echo "Levou $duration segundos para executar o $1."
        ;;
    plan)
        SECONDS=0
        echo "## Iniciando $1. ##"
        terraform fmt
        terraform validate
        terraform plan -var-file="tfvars/$ENV.tfvars" -out="$ENV.tfplan"
        duration=$SECONDS
        echo "## Levou $duration segundos para executar o $1. ##"
        ;;
    apply)
        SECONDS=0
        echo "## Iniciando $1. ##"
        terraform apply -auto-approve "$ENV.tfplan"
        duration=$SECONDS
        echo "Levou $duration segundos para executar o $1."
        ;;
    go)
        SECONDS=0
        echo "## Iniciando $1. ##"
        terraform plan -var-file="tfvars/$ENV.tfvars" -out="$ENV.tfplan"
        terraform apply -auto-approve "$ENV.tfplan"
        duration=$SECONDS
        echo "Levou $duration segundos para executar o $1."
        ;;
    goodbye)
        SECONDS=0
        echo "## Iniciando $1. ##"
        terraform plan -var-file="tfvars/$ENV.tfvars" -out="$ENV.tfplan"
        terraform destroy -auto-approve "$ENV.tfplan"
        duration=$SECONDS
        echo "Levou $duration segundos para executar o $1."
        ;;
    destroy)
        SECONDS=0
        echo "## Executando $1. ##"
        terraform destroy -auto-approve -var-file="tfvars/$ENV.tfvars"
        duration=$SECONDS
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
        echo "$1 applied."
        ;;
    lock)
        terraform providers lock
        echo "$1 applied."
        ;;
    *)
        echo "erro, selecione uma opcao valida."
        ;;
esac