# cci-terraform-ftp-s3
Creates a FTP service backed by s3

### Userdata will install the following components by default:
1. Amazon SSM Agent
2. https://github.com/s3fs-fuse/s3fs-fuse --branch v1.85
3. VSFTPD - "very secure FTP daemon"
4. Amazon CodeDeploy agent

#### Default installations are added by default. It is advised to then deploy configuration via CodeDeploy, Ansible etc to ensure a secure deployment. 
