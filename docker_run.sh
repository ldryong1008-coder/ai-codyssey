#!/bin/bash
DL="/Users/ldryong10097422/dev-workstation/docker.log"

echo "=== Docker Basics Log ===" > $DL
echo "$ docker images" >> $DL
docker images | head -n 5 >> $DL

echo "$ docker run hello-world" >> $DL
docker run --rm hello-world >> $DL

echo "$ docker run ubuntu" >> $DL
docker run --rm ubuntu /bin/bash -c "cat /etc/os-release | grep PRETTY_NAME" >> $DL

echo "=== Custom Image Build ===" >> $DL
echo "$ docker build -t my-web:1.0 ." >> $DL
docker build -t my-web:1.0 . >> $DL 2>&1

echo "=== Port Mapping & Volume Test ===" >> $DL
echo "$ docker volume create mysite_data" >> $DL
docker volume create mysite_data >> $DL

echo "$ docker run -d -p 8080:80 -v mysite_data:/usr/share/nginx/html --name my-web-8080 my-web:1.0" >> $DL
docker run -d -p 8080:80 -v mysite_data:/usr/share/nginx/html --name my-web-8080 my-web:1.0 >> $DL

sleep 2

echo "$ curl http://localhost:8080" >> $DL
curl -s http://localhost:8080 >> $DL
echo "" >> $DL

echo "$ echo 'Updated by Volume Mount' > practice/new_index.html" >> $DL
echo 'Updated by Volume Mount' > practice/new_index.html

echo "$ docker cp practice/new_index.html my-web-8080:/usr/share/nginx/html/index.html" >> $DL
docker cp practice/new_index.html my-web-8080:/usr/share/nginx/html/index.html >> $DL

sleep 1
echo "$ curl http://localhost:8080" >> $DL
curl -s http://localhost:8080 >> $DL
echo "" >> $DL

echo "$ docker rm -f my-web-8080" >> $DL
docker rm -f my-web-8080 >> $DL

echo "$ docker run -d -p 8081:80 -v mysite_data:/usr/share/nginx/html --name my-web-8081 my-web:1.0" >> $DL
docker run -d -p 8081:80 -v mysite_data:/usr/share/nginx/html --name my-web-8081 my-web:1.0 >> $DL

sleep 2
echo "$ curl http://localhost:8081" >> $DL
curl -s http://localhost:8081 >> $DL
echo "" >> $DL

echo "$ docker rm -f my-web-8081" >> $DL
docker rm -f my-web-8081 >> $DL

echo "=== Git Log ===" >> $DL
echo "$ git init" >> $DL
git init >> $DL 2>&1
echo "$ git add ." >> $DL
git add . >> $DL 2>&1
echo "$ git config user.name 'Your Name' && git config user.email 'your.email@example.com'" >> $DL
git config user.name 'Your Name'
git config user.email 'your.email@example.com'
echo "$ git commit -m 'Initial commit'" >> $DL
git commit -m 'Initial commit' >> $DL 2>&1
echo "$ git log -1" >> $DL
git log -1 >> $DL 2>&1
