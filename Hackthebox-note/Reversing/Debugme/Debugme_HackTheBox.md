# Debugme _ Reversing Challenge 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/8ed2ee2d-400d-4e45-b52a-389f88d8a1cf)

Checking the file : 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/cc8c621b-fd88-426a-9979-dbad2f9fd1eb)

It's a 32bit executable. I prefer to use 32bit IDA to decomplie :

Start looking at `mainCRTStartup`  :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/7320edb2-485c-432c-bf10-6ab411a51138)

Hight light this instruction : 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/2902c2cf-8c86-4b90-9715-6eca29b6e8e9)

In this situation , `fs 0x30` register is move to `eax` register , `fs 0x30` is the linear address of PEB struct , in next instruction is mov `eax + 2` this make `fs 0x30` has a role as Anti-debug :

Read more about PEB struct in this link to know why it is the anti-debug in this situation : [link](https://learn.microsoft.com/en-us/windows/win32/api/winternl/ns-winternl-peb)

So this make program always turn to true when debugging , bypass it by change the ZF flag .

Trace the program and stop here : 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/002e8c85-bde9-4197-a1a6-ce1322060212)

Meet the `fs 0x30` again , but remember not everytime this register has a role like anti-debug, but this situation it had , read more about it why offset 0x68 make this register has a role is antidebug in this link : [link](https://unprotect.it/technique/ntglobalflag/)

Bypass it by change the ZF flag .

Trace the program :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/a0bf0abf-11f6-4eea-8f68-12e289c732ab)

In this , the program use [Self-modifying code](https://en.wikipedia.org/wiki/Self-modifying_code) to change the main , we can show the opcode to look the changing in detail , I will pass all after the xoring and fix the function to make it more clear to see.

Set the break and continue the program to stop after the xor math which is Self-modifying code in main :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/76b69c1a-7324-451a-9495-2c9a458c902a)

Click view the main , Undefine the code -> Make Code and Make function to make the Main look more clear :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/9eb4d9f5-aa74-4d7f-8b76-ae318fbddb91)

Undefine :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/ce4331b2-8519-41be-8b7a-90f3021aee6f)

Make Code and Make func : 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/b45b5019-7b29-4dbf-8710-24d7e266cdfb)

Now we can view the graph view , it look very beautifull right now : 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/f30b59ff-a675-423c-b065-08fb15db1d0c)

Now , the security_cookie function not make any problem to program so we can trace through that , but in the tmainCRTStartup it call the main func again which is the main we had fix before :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/fbfafeae-b03d-48b2-abb9-4d483fb5161a)

So the main have 2 antidebug , set the break point to stop at here and bypass like we do before : 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/c3cce622-ce5c-49cc-854e-6533c7a82f37)

Set breakpoint in the last here to trace throught the math xoring the flag :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/51fc805b-c4e6-4504-879f-46d20f4b469a)

Because it is the 32bit program so view the stack to see the flag like the message said we can see the flag in debugger :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/e7763317-daab-4f09-8687-f30d473cae49)

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/24fccf8b-c733-4999-ba4f-e68a7347bc8e)

Submit the flag to challenge : 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/69c83013-97ce-425e-8c10-90ef68b2362e)

