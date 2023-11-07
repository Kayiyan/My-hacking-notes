# PicoCTF 

# GDB Test Drive

open on IDA :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/b55b1ff6-8890-4ff2-ba64-15597b03e241)

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/426c4ee5-3b1e-4698-9751-9a8bd53d194a)

The note here is the `call sleep` function , this will make the program run slower when the `sleep function` running, and hold code is encrypt and decrypt for us.
The solution is just change the time when call function `sleep` :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/e4c195ef-a52d-4da8-8215-866c4e2e29aa)

i use `keypatch` to patch the program :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/050ea113-897f-466e-9109-26e5abadc20f)

Then apply that patch to input file and running it or debug mode : 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/a3015b65-2867-4ca7-b59f-95f1281cf296)

# GDB baby step 1

Main function in IDA view :

Very simple , just know the value in eax register so IDA that help us all for this : 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/b10cd524-f1b3-4d58-aff6-fa2e0eaf9248)

the value is : `549698`

# GDB baby step 2

Open this file in IDA : 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/a2557509-be1b-45d8-b79d-5cd3cdc6127b)

first is compare two this register : `[rbp+var_8]` and `[rbp+var_C]` :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/7686db84-73bb-44fe-9991-49880bf6d074)

first :  `[rbp+var_8]` < `[rbp+var_C]` so it jump to the `loc_40112C` then `[rbp+var_4]` = `[rbp+var_4]` + `eax`, `[rbp+var_8]` = `[rbp+var_8]` + 1 

continue the loop back when `[rbp+var_8]` >`[rbp+var_C]` , the loop is break and the last value of `[rbp + 4]` is the value of `eax` register .

For easy to understand we can look at pesudocode : 

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/ab8e0183-8236-4e3b-9488-217f694cc908)

The last value of `eax` register is : `307019` 

# GDB baby step 3

This is very easy:

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/ec75d567-815b-4e30-85a7-2c03f54c09d8)

` 0x2262c96b` load into memory so four bytes as they are stored in memory is `6b`,`c9`,`62`,`22` , it is a basic theory.

# GDB baby step 4

View on IDA :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/617ff79f-6b22-4afa-8ac2-e53d119ed39a)

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/6ee0aecc-4008-4ebc-8814-39631d2656c2)

In decimal , the value `654` is load in to `[rbp+var_4]` , and follow the code in main and func1, we can see this load the value of `[rbp+var_4]` into `eax` register then mul eax with some value and that value is the constant we need .

The question of this challenge is the constant value which is `12905` :

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/b9d13f28-4b21-47a2-a7dd-d8b3217e1d8f)

![image](https://github.com/Kayiyan/My-hacking-notes/assets/126185640/802096ea-c3a2-4bf2-9102-c84c33a1ec0f)

Last answer is : `picoCTF{12905}` :




