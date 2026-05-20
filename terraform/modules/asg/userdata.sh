#!/bin/bash

# =========================
# System Update
# =========================

apt update -y
apt upgrade -y

# =========================
# Install Java
# =========================

apt install -y openjdk-17-jdk wget curl unzip

# =========================
# Create Tomcat User
# =========================

useradd -m -U -d /opt/tomcat -s /bin/false tomcat

# =========================
# Download Tomcat
# =========================

cd /tmp

wget https://downloads.apache.org/tomcat/tomcat-10/v10.1.41/bin/apache-tomcat-10.1.41.tar.gz

mkdir -p /opt/tomcat

tar -xzf apache-tomcat-10.1.41.tar.gz -C /opt/tomcat --strip-components=1

# =========================
# Permissions
# =========================

chown -R tomcat:tomcat /opt/tomcat
chmod -R u+x /opt/tomcat/bin

# =========================
# Create Tomcat Service
# =========================

cat <<EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# =========================
# Reload Systemd
# =========================

systemctl daemon-reload

# =========================
# Enable and Start Tomcat
# =========================

systemctl enable tomcat
systemctl start tomcat

# =========================
# Verify Status
# =========================

systemctl status tomcat