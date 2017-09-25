#!/bin/bash

################################################################ STARTING THE PACKAGES DOWNLOAD #####################################################

clear
cd /usr/src
echo -e "\n"
echo -e "DOWNLOADING ASTERISK CODE\n"
sleep 2

wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-11-current.tar.gz
tar -zxvf asterisk-11-current.tar.gz


asteriskDir=$(ls | grep asterisk-11.*)
eval "cd '$asteriskDir'"
echo -e "\n"
echo -e "INSTALING PRE-REQUERIMENTS \n"
pwd
sleep 2

./contrib/scripts/install_prereq install

###################################################################### DAHDI #########################################################################

aptitude update
aptitude upgrade -y 
aptitude install -y build-essential subversion libncurses5-dev libssl-dev libxml2-dev libsqlite3-dev uuid-dev vim-nox linux-headers-$(uname -r) ntp libpq-dev

cd /usr/src
echo -e "\n"
echo -e "DOWNLOADING DAHDI CODE\n"
pwd
sleep 2

wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-2.10.1+2.10.1.tar.gz
tar -zxvf dahdi-linux-complete-2.10.1+2.10.1.tar.gz

cd dahdi-linux-complete-2.10.1+2.10.1/
#dahdiDir=$(ls | grep dahdi-linux-complete-2.*)
#eval "cd '$dahdiDir'"

make all
make install
make config

/etc/init.d/dahdi start

#################################################################### ASTERISK ########################################################################

echo -e "CONFIGURING ASTERISK LIBRARIES & PACKAGES\n"
sleep 1
cd /

eval "cd /usr/src/'$asteriskDir'"

./configure

ldconfig -v

./contrib/scripts/get_mp3_source.sh
menuselect/menuselect --enable-category MENUSELECT_ADDONS \ 
--enable format_mp3 \
--enable res_config_mysql \
--enable app_mysql \
--enable cdr_mysql \
--enable app_meetme \
--enable MOH-OPSOUND-GSM \
--enable CORE-SOUNDS-EN-GSM \
--enable CORE-SOUNDS-ES-GSM \
--enable EXTRA-SOUNDS-EN-GSM

make
make install
make addons-install
make config
make samples

cd /
safe_asterisk
sleep 5

echo -e "FINALIZADO SCRIPT DE INSTALACIÓN \n"

##### END #####
