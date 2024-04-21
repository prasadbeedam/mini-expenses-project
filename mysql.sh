#!/bin/bash

USERID=$(id -u)

echo "Please enter DB password:"
read -s mysql_root_password

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "FAILURE"
        exit 1
    else
        echo -e "SUCCESS"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi


dnf install mysql-server -y 
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld 
VALIDATE $? "Enabling MySQL Server"

systemctl start mysqld 
VALIDATE $? "Starting MySQL Server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
mysql -h 172.31.87.132 -uroot -p${mysql_root_password} -e 'show databases;' 
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} 
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi
