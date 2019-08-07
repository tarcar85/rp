#!/bin/bash -x

all=" api client server rp " ;

function scp_cp_chown
 {
  scp $x.$y $x:$y ;
  ssh $x " sudo cp $y $z && sudo chown root. $z/$y " ;
 }

path=$PWD ;

sudo yum update -y && sudo yum install git -y ;
cd / && sudo curl -o .gitignore https://raw.githubusercontent.com/secobau/linux/master/Scripts/rootfs.gitignore ;
cd / && sudo git init && sudo git add . && sudo git commit -m "Initial commit" ;

cd $path ;

sudo cp mgmt.hosts /etc/hosts ;

for x in $all ;
 do
  ssh -oStrictHostKeyChecking=no $x hostname ;
 done ;

for x in $all ;
 do
  ssh $x ' sudo yum update -y && sudo yum install git -y ' ;
  ssh $x ' cd / && sudo curl -o .gitignore https://raw.githubusercontent.com/secobau/linux/master/Scripts/rootfs.gitignore ' ;
  ssh $x ' cd / && sudo git init && sudo git add . && sudo git commit -m "Initial commit" ' ;
 done ;

for x in $all ;
 do
  for y in hosts ;
   do
    for z in /etc ;
     do
      scp_cp_chown ;
     done ;
   done ;
 done ;

for x in api ;
 do
  ssh $x ' curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash && . ~/.nvm/nvm.sh && nvm install 10 ' ;
  ssh $x ' sudo ln -s $( which node ) /usr/bin/node ' ;
  ssh $x ' sudo yum install git -y && git clone https://github.com/secobau/nodejs ' ;
  ssh $x ' cd nodejs/rest-api && rm package.json && npm init --yes && npm install express ' ;
  ssh $x ' file=nodejs/rest-api/index.js  && sed -i /app.listen/d $file && "echo app.listen(8080)" 1>>$file ' ;
 done ;

for x in api ;
 do
  for y in api.service ;
   do
    for z in /etc/systemd/system ;
     do
      scp_cp_chown ;
     done ;
   done ;
 done ;

for x in api ;
 do
  for y in api.service ;
   do
    ssh $x " sudo systemctl daemon-reload && sudo systemctl enable $y " ;
   done ;
 done ;

for x in rp ;
 do
  ssh $x ' sudo amazon-linux-extras install nginx1.12 -y && sudo systemctl enable nginx ' ;
  ssh $x ' sudo rm /usr/share/nginx/html/* ' ;
 done ;

for x in rp ;
 do
  for y in nginx.conf ;
   do
    for z in /etc/nginx ;
     do
      sed -i s/PUBLIC_IP_OF_SERVER/$( ssh server ' curl ifconfig.co ' )/g $x.$y ;
      scp_cp_chown ;
     done ;
   done ;
 done ;

for x in server ;
 do
  ssh $x ' sudo yum install -y httpd mod_ssl && sudo systemctl enable httpd ' ;
  ssh $x ' sudo rm /etc/httpd/conf.d/* ' ;
  ssh $x ' sudo htpasswd -b -c /etc/httpd/conf.d/secret.htpasswd user password ' ;
 done ;

for x in server ;
 do
  for y in httpd.conf ;
   do
    for z in /etc/httpd/conf ;
     do
      scp_cp_chown ;
     done ;
   done ;
 done ;

for x in server ;
 do
  for y in ssl.conf ;
   do
    for z in /etc/httpd/conf.d ;
     do
      scp_cp_chown ;
     done ;
   done ;
 done ;

for x in client ;
 do
  for y in init-api.sh ;
   do
    for z in $HOME ;
     do
      scp_cp_chown ;
     done ;
   done ;
 done ;

for x in mgmt $all ;
 do
  ssh $x ' sudo yum update -y ' ;
  ssh $x ' cd / && sudo git add . && sudo git commit -m "Final setup" ' ;
 done ;

for x in $all ;
 do
  ssh $x ' sudo init 6 ' ;
 done ;

sudo init 6 ;
