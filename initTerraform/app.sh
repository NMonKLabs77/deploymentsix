#!/bin/bash

#Application dependencies install
sudo apt update
sudo apt install -y software-properties-common 
sudo add-apt-repository -y ppa:deadsnakes/ppa 
sudo apt install -y python3.7 
sudo apt install -y python3.7-venv
sudo apt install -y build-essential 
sudo apt install -y libmysqlclient-dev
sudo apt install -y python3.7-dev


cd /home/ubuntu

python3.7 -m venv test
source test/bin/activate
git clone https://github.com/NMonKLabs77/deployment6.git
cd deployment6
pip install pip --upgrade
pip install -r requirements.txt
pip install mysqlclient
pip install gunicorn
python database.py
sleep 1
python load_data.py
sleep 1 
python -m gunicorn app:app -b 0.0.0.0 -D && echo "Done"
