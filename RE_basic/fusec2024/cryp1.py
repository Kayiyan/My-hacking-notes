import socket
import struct

def cipher(k, d):
    S = list(range(256))
    j = 0
    o = []
    for i in range(256):
        j = (j + S[i] + k[i % len(k)]) % 256
        S[i], S[j] = S[j], S[i]
    i = j = 0
    for c in d:
        i = (i + 1) % 256
        j = (j + S[i]) % 256
        S[i], S[j] = S[j], S[i]
        o.append(c ^ S[(S[i] + S[j]) % 256])
    return bytearray(o)

def ip2d(ip_list):
    d = bytearray()
    for ip in ip_list:
        d.extend(struct.unpack('!I', socket.inet_aton(ip))[0].to_bytes(4, byteorder='big'))
    return d

def decr(ip_list, k):
    d = ip2d(ip_list)
    ed = d[:-d[-1]]  # Remove padding
    pt = cipher(k, ed)
    return pt.decode('utf-8')

def main():
    ip_list = ['159.96.34.204', '136.182.188.58', '155.20.31.30', '12.234.113.15', '153.170.118.69', '189.152.240.17', '180.27.111.161', '87.205.101.118', '45.1.136.2', '122.3.3.3']
    key = bytearray('supersecretkey', 'utf-8')
    plaintext = decr(ip_list, key)
    print("Decoded Text:", plaintext)

if __name__ == "__main__":
    main()
