import requests

def httpupload(url, user, password, file_path):

    login_payload = {'username': user, 'password': password}
    file = {'file': open(file_path, 'rb')}
    
    response = requests.post(url, files=file, data=login_payload)
    
    if response.status_code == 200:
        print(f"Upload success. File upload url: {response.url}")
    else:
        print(f"Upload failed with status code {response.status_code}")

httpupload("https://httpbin.org/post", "test", "test123QWE@AD", "/home/kali/Desktop/bridge.jpg") # sửa param 3 thành path ảnh khác 
