#!/bin/bash

yum install -y httpd
service httpd start
chkconfig httpd on
echo "<h1>OOPS its working</h1>" > /var/www/html/index.html
echo "<h1>EC2 launched by code - Mayank</h1>" > /var/www/html/index.html

#END
