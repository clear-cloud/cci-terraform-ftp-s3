# cci-terraform-ftp-s3
Creates a FTP service backed by s3

### Userdata will install the following components by default:
1. Amazon SSM Agent
2. https://github.com/s3fs-fuse/s3fs-fuse --branch v1.85
3. VSFTPD - "very secure FTP daemon"
4. Amazon CodeDeploy agent

#### Default installations are added by default. It is advised to then deploy configuration via CodeDeploy, Ansible etc to ensure a secure deployment. 

#### * N.B. * s3fs has a bug whereby for a recently created s3 bucket you will initially receive a "307 Temporary Redirect" message when attempting to mount an s3 bucket to a folder. Once AWS's DNS updates this will go away.
