#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Select one of the options"
    echo "To initialize config, run 'source deploy.sh config'"
    echo "$0 <config | fmt | init | plan | apply | destroy | clean | go | goodbye | import | find | output>"
    exit 1
fi 

case $1 in
    config)
        export TF_LOG=debug                                             # DEBUG mode
        export TF_LOG_PATH=./terraform.log                              # creates a LOG file
        export TF_PLUGIN_CACHE_DIR="$APPDATA/terraform.d/plugin-cache"  # provides a directory for plugin cache
        export TF_VAR_repo=`echo "${PWD##*/}"`                          # sets the repository name
        export ENV="your_env"
        ;; 
    fmt)
        echo "## Starting $1. ##"
        terraform fmt
        terraform fmt tfvars/
        terraform validate
        duration=$SECONDS # stores the duration of the process in the 'duration' variable
        echo "Took $duration seconds to execute $1."
        ;; 
    init)
        SECONDS=0
        echo "## Starting $1. ##"
        terraform init
        duration=$SECONDS # stores the duration of the process in the 'duration' variable
        echo "Took $duration seconds to execute $1."
        ;;
    plan)
        SECONDS=0
        echo "## Starting $1. ##"
        terraform fmt
        terraform validate
        terraform plan 
        # -var-file="tfvars/$ENV.tfvars" -out="$ENV.tfplan"
        duration=$SECONDS # stores the duration of the process in the 'duration' variable
        echo "## Took $duration seconds to execute $1. ##"
        ;;
    apply)
        SECONDS=0
        echo "## Starting $1. ##"
        terraform apply -auto-approve 
        # "$ENV.tfplan"
        duration=$SECONDS # stores the duration of the process in the 'duration' variable
        echo "Took $duration seconds to execute $1."
        ;;
    go)
        SECONDS=0
        echo "## Starting $1. ##"
        terraform plan -var-file="tfvars/$ENV.tfvars" -out="$ENV.tfplan"
        terraform apply -auto-approve "$ENV.tfplan"
        duration=$SECONDS # stores the duration of the process in the 'duration' variable
        echo "Took $duration seconds to execute $1."
        ;;
    goodbye)
        SECONDS=0
        echo "## Starting $1. ##"
        terraform plan -var-file="tfvars/$ENV.tfvars" -out="$ENV.tfplan"
        terraform destroy -auto-approve "$ENV.tfplan"
        duration=$SECONDS # stores the duration of the process in the 'duration' variable
        echo "Took $duration seconds to execute $1."
        ;;
    destroy)
        SECONDS=0
        echo "## Executing $1. ##"
        terraform destroy -auto-approve -var-file="tfvars/$ENV.tfvars"
        duration=$SECONDS # stores the duration of the process in the 'duration' variable
        echo "## Took $duration seconds to execute $1."
        ;;
    clean)
        rm -rf .terraform
        rm -rf *.tfplan
        rm -rf *.log
        rm -rf *.lock.hcl
        rm -rf *.tfstate
        rm -rf *.backup
        rm -rf .terraform.lock.hcl
        echo "$1 completed."
        ;;
    lock)
        terraform providers lock
        echo "$1 completed."
        ;;
    import)
        echo "## Starting $1. ##"
        # Asks the user for the resource type and ID to import
        read -p "Enter the resource type and ID to import (in the format <resource_type>.<resource_name> <id_console_resource>): " terraform_resource
        # Executes the 'terraform import' command with the provided resource and ID
        terraform import $terraform_resource
        duration=$SECONDS # stores the duration of the process in the 'duration' variable
        echo "## Took $duration seconds to execute $1."
        ;;
    find)
        echo "## Starting $1. ##"
        # Asks the user for the resource to find
        read -p "Enter the resource to find (in the format <resource_type>.<resource_name> or -id=<resource_id>): " resource_identifier
        # Executes the 'terraform state list' command with the provided resource identifier
        terraform state list $resource_identifier
        duration=$SECONDS # stores the duration of the process in the 'duration' variable
        echo "## Took $duration seconds to execute $1."
        ;;
    show_properties)
        echo "## Starting $1. ##"
        # Asks the user for the resource to find
        read -p "Enter the resource to find (in the format <resource_type>.<resource_name> or -id=<resource_id>): " resource_identifier
        # Executes the 'terraform state list' command with the provided resource identifier
        terraform state show "$resource_identifier"
        duration=$SECONDS # stores the duration of the process in the 'duration' variable
        echo "## Took $duration seconds to execute $1."
        ;;
    output)
        echo "## Starting $1. ##"
        # Asks the user for the output name to retrieve, or leave blank to retrieve all outputs
        read -p "Enter the output name to retrieve (leave blank for all outputs): " output_name
        terraform output $output_name
        duration=$SECONDS # stores the duration of the process in the 'duration' variable
        echo "## Took $duration seconds to execute $1."
        ;;
esac
