# To install spacewalk 2.10 in Red Hat Enterprise Linux 7, Scientific Linux 7, CentOS 7

firewall-cmd --add-service=https --permanent
firewall-cmd --add-service=http --permanent
firewall-cmd --reload

yum install -y yum-plugin-tmprepo
yum install -y spacewalk-repo --tmprepo=https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.10/epel-7-x86_64/repodata/repomd.xml --nogpg
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Here we are using PostgreSQL database. To Configure the Spacewalk database.
yum install spacewalk-setup-postgresql -y

# Install Spacewalk
yum install spacewalk-postgresql -y
# Create an answer file for the configuration of Spacewalk, adjusting the values as required.

cat > /tmp/answer-file.txt <<EOF
admin-email = root@localhost
ssl-set-cnames = spacewalk2
ssl-set-org = Spacewalk Org
ssl-set-org-unit = spacewalk
ssl-set-city = Dhaka
ssl-set-state = Dhaka
ssl-set-country = BN
ssl-password = spacewalk
ssl-set-email = root@localhost
ssl-config-sslvhost = Y
db-backend=postgresql
db-name=spaceschema
db-user=spaceuser
db-password=spacepw
db-host=localhost
db-port=5432
enable-tftp=Y
EOF

# Configure Spacewalk using the answer file created previously.
# Run this first to get round UTF8 issue.
# It will remove any existing PostgreSQL database.
rm -Rf /var/lib/pgsql/data
postgresql-setup initdb

# Now run normal config.
spacewalk-setup --answer-file=/tmp/answer-file.txt

# You can restart the Spacewalk service using the following commands.
# /usr/sbin/spacewalk-service [stop|start|restart].

/usr/sbin/spacewalk-service start
