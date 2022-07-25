# Install Docker and container image
`sudo systemctl start docker`  
`docker images`  
`sudo apt install docker`  
`docker pull ubuntu:latest`  
`docker images`  
# Create Dockerfile 
`mkdir docker`  
`cd docker`  
`vim Dockerfile`  
```
FROM ubuntu:latest

RUN apt update && apt install  openssh-server sudo -y

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo test

RUN  echo 'test:test' | chpasswd

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
```
`docker build -t ubuntu:latest .`  
`docker ps -a`  
`docker network create -d bridge my_network`  
`docker inspect ub-test | grep IPAddress`  
`ssh root@172.19.0.2`  
`docker images`  
`ping 172.19.0.2`  
`nmap -A 172.19.0.2`  
`lsof`  
`docker port ub-test`  
`docker stop 11d4a105ddc9`  
`docker ps -a`  
`docker run -it --name ub-test --network=my_network -P 22 b990d6de73d0 bash`  
`docker run -it --name ub-test --network=my_network -P b990d6de73d0 bash # the P publishes all exposed ports, including the one we published in the Dockerfile`  
`docker inspect ub-test | grep IPA`  
`ssh root@172.19.0.2`  
`nmap -A 172.19.0.2`  
`ssh root@172.19.0.2`  
`ssh test@172.19.0.2 -p 2222`  

# how to get back into a stopped container
`docker start be712a323385`  
`docker exec -it be712a323385 bash`  

# inside container
`apt install -y vim iproute2`  

## Setting up HAProxy
`/etc/haproxy/haproxy.cfg`  
```
defaults
  timeout client 10s
  timeout connect 5s
  timeout server 10s 

global
  chroot /var/lib/haproxy
  user haproxy
  group haproxy


frontend ssh1_fe
  mode tcp
  bind :2200
  use_backend ssh1_be

backend ssh1_be
  mode tcp
  server server1 127.0.0.1:22 check
```
