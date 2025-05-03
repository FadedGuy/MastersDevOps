#!/bin/bash

AMI_ID=$1
AWS_REGION=$2
EC2_INSTANCE_TYPE=$3
EC2_KEYPAIR_NAME=$4
EC2_SECURITY_GROUP_IDS=$5
SUBNET_ID=$6

echo "Desplegando la AMI: $AMI_ID en la región: $AWS_REGION"

# Comando para lanzar una instancia EC2 usando la AWS CLI:
aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$EC2_INSTANCE_TYPE" \
  --key-name "$EC2_KEYPAIR_NAME" \
  --security-group-ids "$EC2_SECURITY_GROUP_IDS" \
  --subnet-id "$SUBNET_ID" \
  --region "$AWS_REGION" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=MEAN-PHP-Instance}]" \
  --user-data file://user-data.txt

echo "Instancia EC2 lanzada.  Verifica la consola de AWS para obtener la IP pública."
