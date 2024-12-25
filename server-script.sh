#!/bin/bash

sudo  yum update -y
sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
sudo yum install maven -y 


if [ -d "basictoadvance" ]
then
    echo "repo is cloned and exists"
    cd /home/ec2-user/basictoadvance
    git pull origin b1
else 
    git clone https://github.com/jaysh-rob/basictoadvance.git
fi

cd /home/ec2-user/basictoadvance

mvn package
