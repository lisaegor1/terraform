#!/bin/bash
sudo apt update
sudo apt install -y apache2
sudo echo "by terraform Yehor" > /var/www/html/index.html
