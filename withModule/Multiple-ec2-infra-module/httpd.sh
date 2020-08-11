#!/bin/bash

yum install -y httpd
service httpd start
chkconfig httpd on
echo "<h1>OOPS its working</h1>" > /var/www/html/index.html
echo "<h1>EC2 launched by code - Me</h1>" > /var/www/html/index.html

echo "You can access your weather applcation by accessing" > /var/www/html/index.html


#END
