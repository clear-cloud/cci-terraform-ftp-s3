#!/bin/sh
# ----------------
# Install custom additional set-up PRE
# ----------------
${supplementary_user_data_pre}
# ----------------
# Update host
# ----------------
yum update -y
# ----------------
# Install required utilities 
# ----------------
RequiredPackages=(awscli lsof git wget ruby)
yum install -y "$${RequiredPackages[@]}"
# ----------------
# Setup DNS record update
# ----------------
PUBLICIP=$(curl -s 'http://169.254.169.254/latest/meta-data/public-ipv4')
cat << EOF > /root/dns_update.json
{"Comment": "FTP Server DNS record update","Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"${hostname}.${dns_domain_name}","Type":"A","TTL":300,"ResourceRecords":[{"Value":"$PUBLICIP"}]}}]}
EOF
# ----------------
# Update DNS record
# ----------------
aws route53 change-resource-record-sets --hosted-zone-id ${hosted_zone_id} --change-batch file:///root/dns_update.json
# ----------------
# Set hostname
# ----------------
hostname ${hostname}.${dns_domain_name}
hostnamectl set-hostname ${hostname}.${dns_domain_name}
# ----------------
# Setup SSM Agent
# ----------------
yum install amazon-ssm-agent python-deltarpm -y
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
echo "systemctl start amazon-ssm-agent" >> /etc/rc.local
# ----------------
# Install s3fs-fuse
# ----------------
yum install amazon-ssm-agent python-deltarpm gcc libstdc++-devel gcc-c++ fuse fuse-devel curl-devel libxml2-devel mailcap git automake fuse git openssl-devel jq -y
git clone https://github.com/s3fs-fuse/s3fs-fuse --branch v1.85
cd s3fs-fuse/
./autogen.sh
./configure --prefix=/usr --with-openssl
make
make install
# ----------------
# Install VSFTPD 
# ----------------
yum install -y vsftpd
systemctl enable vsftpd && systemctl start vsftpd
# ----------------
# Install CodeDeploy agent
# ----------------
wget https://bucket-name.s3.${region}.amazonaws.com/latest/install
chmod +x ./install
./install auto
# ----------------
# Allow for additional commands
# ----------------
${supplementary_user_data}

