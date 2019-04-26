#!/bin/bash
sudo yum install git
sudo yum install nodejs
sudo yum install npm
cd /etc
mkdir webApp
cd webApp
git clone https://github.com/ranaware/frontend.git
cd frontend
npm install react-app
npm install update
npm start

