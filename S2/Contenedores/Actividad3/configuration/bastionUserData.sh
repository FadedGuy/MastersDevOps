#!/bin/bash

# Install kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p /home/ec2-user/bin
cp ./kubectl /home/ec2-user/bin/kubectl
echo 'export PATH=$PATH:/home/ec2-user/bin' >> /home/ec2-user/.bashrc

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