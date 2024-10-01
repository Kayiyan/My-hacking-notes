import requests
import re

def httpget(url):
    response = requests.get(url)
    
    if response.status_code == 200:

        html_content = response.text

        title_search = re.search('<title>(.*?)</title>', html_content, re.IGNORECASE)

        if title_search:
            print(f"Title: {title_search.group(1)}")
        else:
            print("Không tìm thấy thẻ <title>")
    else:
        print(f"Request failed with status code {response.status_code}")

httpget("https://httpbin.org")
