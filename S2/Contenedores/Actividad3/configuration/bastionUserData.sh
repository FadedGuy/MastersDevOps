#!/bin/bash

# Install git 
yum update -y 
yum install -y git

# Install kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.3/2025-08-03/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p /home/ec2-user/bin
cp ./kubectl /home/ec2-user/bin/kubectl
echo 'export PATH=$PATH:/home/ec2-user/bin' >> /home/ec2-user/.bashrc

# # Install eksctl
# ARCH=amd64
# PLATFORM=$(uname -s)_$ARCH
# curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
# tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
# sudo mv /tmp/eksctl /usr/local/bin

# Create and add ~/.aws/credentials
mkdir -p /home/ec2-user/.aws
chmod 700 /home/ec2-user/.aws
cat <<EOF > /home/ec2-user/.aws/credentials
[default]
aws_access_key_id = <YOUR_ACCESS_KEY_ID_HERE>
aws_secret_access_key = <YOUR_SECRET_ACCESS_KEY_HERE>
aws_session_token = <YOUR_SESSION_TOKEN_IF_REQUIRED>
EOF
chown -R ec2-user:ec2-user /home/ec2-user/.aws
chmod 600 /home/ec2-user/.aws/credentials

# Create kubeconfig from cluster
aws eks update-kubeconfig --name <CLUSTER_NAME> --region us-east-1

# Copy repository with manifests
cd /home/ec2-user
git clone https://github.com/FadedGuy/MastersDevOps.git
chwon -R ec2-user:ec2-user /home/ec2-user/MasterDevOps
