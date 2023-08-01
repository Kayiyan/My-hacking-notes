`GOBUSTER`
gobuster dir -u http://10.10.252.123/myfolder -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x.html,.css,.js : dir model

-k : `Skip TLS certificate verification` (use when HTTPS on)

gobuster dns -d mydomain.thm -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt : DNS model

gobuster vhost -u http://example.com -w /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt : `vhost` model -> brute-force the virtual hosts -> run on the same server.

common wordlists :

`/usr/share/wordlists/dirbuster/directory-list-2.3-*.txt
/usr/share/wordlists/dirbuster/directory-list-1.0.txt
/usr/share/wordlists/dirb/big.txt
/usr/share/wordlists/dirb/common.txt
/usr/share/wordlists/dirb/small.txt
/usr/share/wordlists/dirb/extensions_common.txt - Useful for when fuzzing for files! `

echo "10.10.106.175 webenum.thm" >> /etc/hosts
echo "10.10.106.175 mysubdomain.webenum.thm" >> /etc/hosts

gobuster dir -u http://webenum.thm -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 64


gobuster dir -u http://webenum.thm/Changes -w /usr/share/wordlists/dirbustemedium.txt -x.html,.css,.js,.conf,.txt -t 64
->conf,js


gobuster dir -u http://webenum.thm/VIDEO/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,txt,html -t 50


curl "http://webenum.thm/VIDEO/flag.php " -> `thm{n1c3_w0rk}`

gobuster vhost -u http://webenum.thm -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt -t 50

-> learning and products.webenum.thm -> set to hosts and scan -> get flag.txt -> `thm{gobuster_is_fun}`

`WPScan`

wpscan --url http://wpscan.thm/ --enumerate t -> twentynineteen
wpscan --url http://wpscan.thm/ --enumerate p 
-> nextgen-gallery

wpscan --url http://wpscan.thm/ --enumerate u
-> Phreakazoid

wpscan --url http://wpscan.thm/ --passwords /usr/share/wordlists/rockyou.txt --usernames Phreakazoid
-> linkinpark

`Nikto`

nikto -h http://10.10.125.98:80 -> Apache/2.4.7(Ubuntu)

nikto -h 10.10.125.98 -p 80,8000,8080 
-> Apache-Coyote/1.1 
-> JSESSIONID