#!/bin/bash.sh

# download sudo 1.8.20
wget https://www.sudo.ws/dist/sudo-1.8.20p2.tar.gz

# install sudo 1.8.20 as root user
tar zxvf sudo-1.8.20p2.tar.gz
cd sudo-1.8.20p2
./configure
make clean;make;make install
