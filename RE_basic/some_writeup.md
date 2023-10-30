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


# vault-door-4 :

source code :

```java
import java.util.*;

class VaultDoor4 {
    public static void main(String args[]) {
        VaultDoor4 vaultDoor = new VaultDoor4();
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter vault password: ");
        String userInput = scanner.next();
	String input = userInput.substring("picoCTF{".length(),userInput.length()-1);
	if (vaultDoor.checkPassword(input)) {
	    System.out.println("Access granted.");
	} else {
	    System.out.println("Access denied!");
        }
    }

    // I made myself dizzy converting all of these numbers into different bases,
    // so I just *know* that this vault will be impenetrable. This will make Dr.
    // Evil like me better than all of the other minions--especially Minion
    // #5620--I just know it!
    //
    //  .:::.   .:::.
    // :::::::.:::::::
    // :::::::::::::::
    // ':::::::::::::'
    //   ':::::::::'
    //     ':::::'
    //       ':'
    // -Minion #7781
    public boolean checkPassword(String password) {
        byte[] passBytes = password.getBytes();
        byte[] myBytes = {
            106 , 85  , 53  , 116 , 95  , 52  , 95  , 98  ,
            0x55, 0x6e, 0x43, 0x68, 0x5f, 0x30, 0x66, 0x5f,
            0142, 0131, 0164, 063 , 0163, 0137, 0146, 064 ,
            'a' , '8' , 'c' , 'd' , '8' , 'f' , '7' , 'e' ,
        };
        for (int i=0; i<32; i++) {
            if (passBytes[i] != myBytes[i]) {
                return false;
            }
        }
        return true;
    }
}
```

Just take date in myBytes and change to char : I use javascript to covert that :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/16a299d0-7f21-48ec-acec-e26a2990b498)

# vault-door-5 

source code :

```java
import java.net.URLDecoder;
import java.util.*;

class VaultDoor5 {
    public static void main(String args[]) {
        VaultDoor5 vaultDoor = new VaultDoor5();
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter vault password: ");
        String userInput = scanner.next();
	String input = userInput.substring("picoCTF{".length(),userInput.length()-1);
	if (vaultDoor.checkPassword(input)) {
	    System.out.println("Access granted.");
	} else {
	    System.out.println("Access denied!");
        }
    }

    // Minion #7781 used base 8 and base 16, but this is base 64, which is
    // like... eight times stronger, right? Riiigghtt? Well that's what my twin
    // brother Minion #2415 says, anyway.
    //
    // -Minion #2414
    public String base64Encode(byte[] input) {
        return Base64.getEncoder().encodeToString(input);
    }

    // URL encoding is meant for web pages, so any double agent spies who steal
    // our source code will think this is a web site or something, defintely not
    // vault door! Oh wait, should I have not said that in a source code
    // comment?
    //
    // -Minion #2415
    public String urlEncode(byte[] input) {
        StringBuffer buf = new StringBuffer();
        for (int i=0; i<input.length; i++) {
            buf.append(String.format("%%%2x", input[i]));
        }
        return buf.toString();
    }

    public boolean checkPassword(String password) {
        String urlEncoded = urlEncode(password.getBytes());
        String base64Encoded = base64Encode(urlEncoded.getBytes());
        String expected = "JTYzJTMwJTZlJTc2JTMzJTcyJTc0JTMxJTZlJTY3JTVm"
                        + "JTY2JTcyJTMwJTZkJTVmJTYyJTYxJTM1JTY1JTVmJTM2"
                        + "JTM0JTVmJTM4JTM0JTY2JTY0JTM1JTMwJTM5JTM1";
        return base64Encoded.equals(expected);
    }
}
```

decode Base64 is very easy , Javascript can help this again in fastest way :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/422ab31a-e295-446e-a940-be7b77bcdda2)

# ARMssembly 0 (arm0)

Source code + explain value print out:

```assembly
	.arch armv8-a
	.file	"chall.c"
	.text
	.align	2
	.global	func1
	.type	func1, %function
func1:
	sub	sp, sp, #16
	str	w0, [sp, 12]   // store w0 -> stack + 12
	str	w1, [sp, 8]   // store w1 -> stack + 8
	ldr	w1, [sp, 12]  // load w1 -> stack + 12
	ldr	w0, [sp, 8]  // load wo -> stack + 8
	cmp	w1, w0    // cmp w1 and w0  (4004594377 and 4110761777)
	bls	.L2     // same wiht jump in x86 , this will branch (jump) if lower or equal 
	ldr	w0, [sp, 12]
	b	.L3
.L2:
	ldr	w0, [sp, 8]  // load w0 -> stack + 8
.L3:
	add	sp, sp, 16
	ret
	.size	func1, .-func1
	.section	.rodata
	.align	3
.LC0:
	.string	"Result: %ld\n"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	str	w0, [x29, 44]
	str	x1, [x29, 32]
	ldr	x0, [x29, 32]
	add	x0, x0, 8
	ldr	x0, [x0]
	bl	atoi
	mov	w19, w0
	ldr	x0, [x29, 32]
	add	x0, x0, 16
	ldr	x0, [x0]
	bl	atoi
	mov	w1, w0
	mov	w0, w19
	bl	func1   // note this -> call the func1
	mov	w1, w0  // move w1 -> w0
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf -> so the result will be w1 -> which is 4110761777 -> and turn to hex is 0xf5053f31 
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
```

*  ARMssembly 1 (arm0)

Source code + explain value print out :

```assembly
	.arch armv8-a
	.file	"chall_1.c"
	.text
	.align	2
	.global	func
	.type	func, %function
func:
	sub	sp, sp, #32
	str	w0, [sp, 12]    // store w0 -> stack + 12 (parameter store in [stack + 12])
	mov	w0, 83          
	str	w0, [sp, 16]    // (stack + 16)= 83
	str	wzr, [sp, 20]  // (stack + 20) = 0
	mov	w0, 3          
	str	w0, [sp, 24]        // (stack + 24) = 3
	ldr	w0, [sp, 20]       // w0 = (stack + 20) = 0
	ldr	w1, [sp, 16]       // w1 = stack + 16 = 83
	lsl	w0, w1, w0         //  w0 = w1 << w0 ( 83 << 0) = 83
	str	w0, [sp, 28]       // ( stack + 28 ) = 83
	ldr	w1, [sp, 28]       // w1 = stack + 28 = 83
	ldr	w0, [sp, 24]      //  w0 = stack + 24 = 3
	sdiv	w0, w1, w0    // w0 = w1 / w0 (83//3) = 27
	str	w0, [sp, 28]      //   ( stack + 28 ) = 27
	ldr	w1, [sp, 28]      //  w1 = (stack + 28) = 27
	ldr	w0, [sp, 12]      //  w0 = ( stack + 12 ) 
	sub	w0, w1, w0        // w0 = w1 - w0 = 27 - [stack + 12]
	str	w0, [sp, 28]      //  w0 = (stack + 28)
	ldr	w0, [sp, 28]     //  w0 = (stack + 28 ) = 0
	add	sp, sp, 32  
	ret
	.size	func, .-func
	.section	.rodata
	.align	3
.LC0:
	.string	"You win!"
	.align	3
.LC1:
	.string	"You Lose :("
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	str	w0, [x29, 28]
	str	x1, [x29, 16]
	ldr	x0, [x29, 16]
	add	x0, x0, 8
	ldr	x0, [x0]
	bl	atoi
	str	w0, [x29, 44]
	ldr	w0, [x29, 44]
	bl	func  -> call the func 
	cmp	w0, 0  -> compare w0 to 0
	bne	.L4   // branch if not equal --> need bad value from this --> [stack + 12 ] = 27 -> 0x0000001b
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	puts
	b	.L6
.L4:
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	puts
.L6:
	nop
	ldp	x29, x30, [sp], 48
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits

```



 
