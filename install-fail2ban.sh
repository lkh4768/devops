sudo apt-get install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
sudo fail2ban-cli status sshd
