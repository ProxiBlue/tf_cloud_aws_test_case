#!/bin/bash

# Make sure every command send output. Also make sure, that the program exits after an error.
set -x

# To get the whole user_data output, we save it to a log file under /var/log/user_data.log
exec > >(tee /var/log/deploy.log|logger -t user-data -s 2>/dev/console) 2>&1

mkdir /mnt/media
#mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns}:/ /mnt/media
chmod 777 /mnt/media
chown ubuntu:www-data /mnt/media -R

export DEBIAN_FRONTEND=noninteractive
apt -y update && apt install apt-transport-https unzip
apt -y install software-properties-common tzdata curl sudo && \
DEBIAN_FRONTEND=noninteractive && \
echo "Australia/Perth" tee /etc/timezone && \
dpkg-reconfigure --frontend noninteractive tzdata && \
apt -y upgrade && \
apt -y --allow-unauthenticated --no-install-recommends install \
bzip2 \
ca-certificates \
wget \
curl \
joe \
net-tools \
mcrypt \
git \
mc \
nginx \
php7.2-fpm \
php7.2-cli \
php7.2-mysql \
php7.2-curl \
php7.2-gd \
php7.2-redis \
php7.2-xml \
php7.2-soap \
php7.2-mbstring \
php7.2-zip \
php7.2-common \
php7.2-intl \
php7.2-xsl \
php7.2-bcmath \
php7.2-iconv \
php7.2-intl \
composer \
nano \
pv \
screen \
inetutils-ping \
rsync \
s3fs \
sendmail \
mailtools \
dos2unix \
imagemagick \
gettext-base \
mysql-client \
nfs-common

#cp -xav /tmp/sites_nginx.conf /etc/nginx/sites-available/default

chown ubuntu:www-data /var/www -R

usermod -a -G www-data ubuntu

sudo su root -c "sed -i s/1000\:Ubuntu/33:Ubuntu/g /etc/passwd"
service nginx restart
