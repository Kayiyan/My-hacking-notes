from Crypto.Cipher import Salsa20

key = b"ef39f4f20e76e33bd25f4db338e81b10"  
nonce = b"d4c270a3"  
# Password: TheCrucialRustEngineering@2021;)
cipher = Salsa20.new(key=key, nonce=nonce)
data = (bytes.fromhex("05055FB1A329A8D558D9F556A6CB31F324432A31C99DEC72E33EB66F62AD1BF9"))
password = cipher.decrypt(data)
print(password)
# Fake flag: HTB{F4k3_f74g_4_t3s7ing}
cipher = Salsa20.new(key=key, nonce=nonce)
data = ((bytes.fromhex("193978899768A08F66D39017B2E040C237193763C581E261")))
fakeflag = cipher.decrypt(data)
print(fakeflag)
