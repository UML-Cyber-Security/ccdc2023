# TODO
1. Make Quality Of Life Scripts
   1. Script to add user to docker group
2. Make Services with Security Standards enabled (Docker Stack/Compose Files)




sudo groupadd docker && sudo usermod -aG docker ubuntu
sudo groupadd docker && sudo gpasswd -a ${USER} docker && sudo service docker restart