groupadd dba -g 1600
useradd -g dba -G dba -s /bin/bash oracle -u 1601
passwd oracle
yum install -y ksh
yum install -y linbnsl
yum install -y libnsl
yum install -y sysstat
yum install -y xterm
yum install -y compat-openssl10
yum install -y xorg-x11-utils
yum install -y libstdc++-devel
yum install -y libaio-devel
yum install -y compat-libcap1
wget https://rpmfind.net/linux/centos/7.9.2009/os/x86_64/Packages/compat-libcap1-1.10-7.el7.x86_64.rpm
rpm -ivh compat-libcap1-1.10-7.el7.x86_64.rpm
wget https://rpmfind.net/linux/centos/7.9.2009/os/x86_64/Packages/compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm
rpm -ivh compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm
curl -o oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm
yum -y localinstall oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm
cd /etc/security/limits.d/
vi /etc/security/limits.conf
mkdir -p /dbi/oracle/V19BaseDatabaseq       
mkdir -p /dbi/oracle/V19Database
chmod 777 /dbi
chmod 777 /dbi/oracle/

chown oracle:dba /dbi/oracle/V19Database
chown oracle:dba /dbi/oracle/V19BaseDatabase

cd /dbi/oracle/; ls -l

ORACLE_HOME=/dbi/oracle/V19Database
ORACLE_BASE=/dbi/oracle/V19BaseDatabase

Download Oracle 19c
unzip -qq package -d /V19Database

PATH=$PATH:$HOME/bin                                    ; export PATH
TMP=/tmp                                                ; export TMP
TMPDIR=$TMP                                             ; export TMPDIR
ORACLE_SID=oral9c                                       ; export ORACLE_SID
ORACLE_UNQNAME=oral9c                                   ; export ORACLE_UNQNAME
ORACLE_BASE=/dbi/oracle/V19BaseDatabase                 ; export ORACLE_BASE        
ORACLE_HOME-/dbi/oracle/vdatabase                       ; export ORACLE_HOME
ORACLE_HOSTNAME=localhost.localdomain                             ; export ORACLE_HOSTNAME
PATH=/usr/sbin:$PATH                                   ; export PATH
PATH=$ORACLE_HOME/bin:$PATH                           ; export PATH
LD_LIBRARY_PATH=$ORACLE HOME/lib:/lib:/usr/lib         ; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib     ; export CLASSPATH
CLASSPATH=$ORACLE_HOME/JRE:$CLASSPATH                  ; export CLASSPATH
export DISPLAY=192.168.1.8:7.0


https://oracledbwr.com/step-by-step-oracle-19c-installation-on-linux/

https://medium.com/geekculture/oracle-database-19c-installation-on-linux-e184dde4ce03
