#!/bin/bash
set -ex  

# Update system
apt update -y

# Install Nginx
apt install -y nginx
systemctl enable nginx  
systemctl restart nginx  

# Install Java
apt install -y openjdk-17-jdk

# Add Jenkins repository and key
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | tee \
                /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                https://pkg.jenkins.io/debian binary/" | tee \
                /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
apt update
apt install -y jenkins
systemctl daemon-reload  
systemctl enable jenkins  
systemctl restart jenkins  

# Get instance public IP dynamically
INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Configure Nginx as a reverse proxy for Jenkins
cat <<EOT > /etc/nginx/sites-available/jenkins
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }  
}
EOT

# Enable the Jenkins site and restart Nginx
ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl restart nginx

# Output Jenkins initial password
cat /var/lib/jenkins/secrets/initialAdminPassword
