#!/bin/bash
# =================== Security Setup Script ===================
# SCRIPT PARA CONFIGURAR VARIABLES DE ENTORNO SEGURAS

set -e

echo "Configurando variables de entorno seguras para Packer..."

# Verificar si AWS CLI está instalado
if ! command -v aws &> /dev/null; then
    echo "AWS CLI no está instalado. Por favor instalarlo primero:"
    echo "   curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\""
    echo "   unzip awscliv2.zip"
    echo "   sudo ./aws/install"
    exit 1
fi

# Verificar si Packer está instalado
if ! command -v packer &> /dev/null; then
    echo "Packer no está instalado. Por favor instalarlo primero:"
    echo "   wget https://releases.hashicorp.com/packer/1.9.4/packer_1.9.4_linux_amd64.zip"
    echo "   unzip packer_1.9.4_linux_amd64.zip"
    echo "   sudo mv packer /usr/local/bin/"
    exit 1
fi

echo "Herramientas verificadas: AWS CLI y Packer instalados"

# Solicitar credenciales AWS de forma segura
echo ""
echo "Configuración de credenciales AWS"
echo "IMPORTANTE: Estas credenciales NO se guardarán en archivos"
echo "    Solo se configurarán como variables de entorno temporales"
echo ""

read -p "AWS Region (us-east-1): " AWS_REGION
AWS_REGION=${AWS_REGION:-us-east-1}

read -p "AWS Access Key ID: " AWS_ACCESS_KEY
if [ -z "$AWS_ACCESS_KEY" ]; then
    echo "AWS Access Key es requerido"
    exit 1
fi

read -s -p "AWS Secret Access Key: " AWS_SECRET_KEY
echo ""
if [ -z "$AWS_SECRET_KEY" ]; then
    echo "AWS Secret Key es requerido"
    exit 1
fi

read -p "SSH Key Pair Name en AWS: " KEY_PAIR_NAME
if [ -z "$KEY_PAIR_NAME" ]; then
    echo "SSH Key Pair Name es requerido"
    exit 1
fi

# Exportar variables de entorno
export PKR_VAR_access_key="$AWS_ACCESS_KEY"
export PKR_VAR_secret_key="$AWS_SECRET_KEY"
export PKR_VAR_region="$AWS_REGION"
export PKR_VAR_key_pair_name="$KEY_PAIR_NAME"

echo ""
echo "Variables de entorno configuradas exitosamente"

# Verificar credenciales AWS
echo ""
echo "Verificando credenciales AWS..."
if aws sts get-caller-identity >/dev/null 2>&1; then
    echo "Credenciales AWS válidas"
    aws sts get-caller-identity --query 'Account' --output text | sed 's/^/   Cuenta AWS: /'
else
    echo "Error: Credenciales AWS inválidas"
    exit 1
fi

# Verificar que el Key Pair existe
echo ""
echo "Verificando SSH Key Pair..."
if aws ec2 describe-key-pairs --key-names "$KEY_PAIR_NAME" >/dev/null 2>&1; then
    echo "SSH Key Pair '$KEY_PAIR_NAME' encontrado"
else
    echo "Error: SSH Key Pair '$KEY_PAIR_NAME' no existe en AWS"
    echo "   Crear el key pair con:"
    echo "   aws ec2 create-key-pair --key-name $KEY_PAIR_NAME --query 'KeyMaterial' --output text > $KEY_PAIR_NAME.pem"
    echo "   chmod 400 $KEY_PAIR_NAME.pem"
    exit 1
fi

# Crear archivo de variables de entorno temporal
cat > .env.tmp << EOF
# =================== Variables de Entorno Temporales ===================
# ESTE ARCHIVO ES TEMPORAL Y NO DEBE SER COMMITEADO
# Configurado por security-setup.sh en $(date)

export PKR_VAR_access_key="$AWS_ACCESS_KEY"
export PKR_VAR_secret_key="$AWS_SECRET_KEY"
export PKR_VAR_region="$AWS_REGION"
export PKR_VAR_key_pair_name="$KEY_PAIR_NAME"

# Adicionales para scripts
export AWS_DEFAULT_REGION="$AWS_REGION"
export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_KEY"

echo "Variables de entorno cargadas para región: $AWS_REGION"
EOF

# Agregar .env.tmp al .gitignore si no está
if [ -f .gitignore ]; then
    if ! grep -q ".env.tmp" .gitignore; then
        echo ".env.tmp" >> .gitignore
        echo ".env.tmp agregado a .gitignore"
    fi
else
    echo ".env.tmp" > .gitignore
    echo ".gitignore creado con .env.tmp"
fi

echo ""
echo "¡Configuración completada!"
echo ""
echo "Próximos pasos:"
echo "   1. Cargar variables: source .env.tmp"
echo "   2. Validar Packer: cd amis/apollo && packer validate template.pkr.hcl"
echo "   3. Construir AMIs: packer build template.pkr.hcl"
echo ""
echo "Notas de seguridad:"
echo "   - Las credenciales están solo en memoria y .env.tmp (temporal)"
echo "   - .env.tmp está en .gitignore para evitar commits accidentales"
echo "   - Eliminar .env.tmp después del despliegue: rm .env.tmp"
echo ""
echo "Comando rápido para continuar:"
echo "   source .env.tmp && cd amis/apollo"
