# RE Basic 
# My write up practice at reverse engineering 

* `PicoCTF 2019` :

# asm3 :

Source code :
  ```assembly
  asm3:
	push   ebp                        		;asm3(0xba6c5a02,0xd101e3dd,0xbb86a173) 
	mov    ebp,esp 
	xor    eax,eax                    
	mov    ah,BYTE PTR [ebp+0xb]      
	shl    ax,0x10					  
	sub    al,BYTE PTR [ebp+0xd]	  
	add    ah,BYTE PTR [ebp+0xc]      
	xor    ax,WORD PTR [ebp+0x12]	  
	nop
	pop    ebp
	ret 
```

First solution : running code on Assembly X86 emulator will give the flag ( value in hex ) in the fastest way : ( the value store in `eax` register ) 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/c7c1861e-256e-476e-87aa-4b9dbd1ea71d)

Explain the code :

I will split out the hex value for easy to look : 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/3ec90cb3-213b-49c6-ae7d-6c226daf7421)

Beside that , need follow this theory to understand the code :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/c369815b-9a1b-40f4-86df-07047fb0fa70)

Note value eax change :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/fc64b3d4-9c06-4457-9db2-4811e73e5a77)


# asm4

Source Code ( add some variable to complie with C ) :

```assembly
.intel_syntax noprefix
.global asm4
asm4:
	push   ebp
	mov    ebp,esp
	push   ebx
	sub    esp,0x10
	mov    DWORD PTR [ebp-0x10],0x246
	mov    DWORD PTR [ebp-0xc],0x0
	jmp    asm4+27
	add    DWORD PTR [ebp-0xc],0x1
	mov    edx,DWORD PTR [ebp-0xc]
	mov    eax,DWORD PTR [ebp+0x8]
	add    eax,edx
	movzx  eax,BYTE PTR [eax]
	test   al,al
	jne    asm4+23
	mov    DWORD PTR [ebp-0x8],0x1
	jmp    asm4+138
	mov    edx,DWORD PTR [ebp-0x8]
	mov    eax,DWORD PTR [ebp+0x8]
	add    eax,edx
	movzx  eax,BYTE PTR [eax]
	movsx  edx,al
	mov    eax,DWORD PTR [ebp-0x8]
	lea    ecx,[eax-0x1]
	mov    eax,DWORD PTR [ebp+0x8]
	add    eax,ecx
	movzx  eax,BYTE PTR [eax]
	movsx  eax,al
	sub    edx,eax
	mov    eax,edx
	mov    edx,eax
	mov    eax,DWORD PTR [ebp-0x10]
	lea    ebx,[edx+eax*1]
	mov    eax,DWORD PTR [ebp-0x8]
	lea    edx,[eax+0x1]
	mov    eax,DWORD PTR [ebp+0x8]
	add    eax,edx
	movzx  eax,BYTE PTR [eax]
	movsx  edx,al
	mov    ecx,DWORD PTR [ebp-0x8]
	mov    eax,DWORD PTR [ebp+0x8]
	add    eax,ecx
	movzx  eax,BYTE PTR [eax]
	movsx  eax,al
	sub    edx,eax
	mov    eax,edx
	add    eax,ebx
	mov    DWORD PTR [ebp-0x10],eax
	add    DWORD PTR [ebp-0x8],0x1
	mov    eax,DWORD PTR [ebp-0xc]
	sub    eax,0x1
	cmp    DWORD PTR [ebp-0x8],eax
	jl     asm4+51
	mov    eax,DWORD PTR [ebp-0x10]
	add    esp,0x10
	pop    ebx
	pop    ebp
	ret    
```
Some explain:

1. `.intel_syntax noprefix`: Sets the assembly language syntax to Intel style without requiring register prefixes (like `%` before registers).

2. `.global asm4`: Declares a global symbol named `asm4`, making it visible and accessible to other parts of the program or code.


File C to call asm4 : 

```C
#include <stdio.h>

int asm3(int, int, int);

int main(int argc, char* argv[])
{
    printf("FLAG: 0x%x\n", asm4("picoCTF_a3112"));
    return 0;
}
```
Complie 2 file and a file to call :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/fa1494bb-2285-4d11-af3b-88e07f513712)

# vault-door-3

The challange is very easy , just take a char following the code :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/71b6407f-b9a1-41a1-8cc7-981a17abe7f3)

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/7df77893-09c6-4e1f-992a-8bcdd572d90f)




 
