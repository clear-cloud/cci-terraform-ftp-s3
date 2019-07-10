# cci-terraform-ftp-s3
Creates a FTP service backed by s3

### Userdata will install the following components by default:
1. Amazon SSM Agent
2. https://github.com/s3fs-fuse/s3fs-fuse --branch v1.85
3. VSFTPD - "very secure FTP daemon"
4. Amazon CodeDeploy agent

#### Default installations are added by default. It is advised to then deploy configuration via CodeDeploy, Ansible etc to ensure a secure deployment. 

#### * N.B. * s3fs has a bug whereby for a recently created s3 bucket you will initially receive a "307 Temporary Redirect" message when attempting to mount an s3 bucket to a folder. Once AWS's DNS updates this will go away.

#### Currently s3fs only works with access key pairs ( not IAM roles ). Credentials need to be placed in /etc/passwd-s3fs as AKIA6LMAACCESSKEYID:9BuRf1QGXEDEIy5WBMuACCESSKEYSECRET

#### userdata will automatically download import_users.sh from s3://cci-import-users-iam/import_users.sh and copy to /opt/import_users.sh. This script can be used to manage user accounts via IAM.
