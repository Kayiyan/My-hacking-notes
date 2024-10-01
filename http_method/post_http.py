import requests

def httppost(url, user, password):
    payload = {'username': user, 'password': password}
    
    response = requests.post(url, data=payload)
    
    if response.status_code == 200:
        print(f"User {user} đăng nhập thành công")
    else:
        print(f"User {user} đăng nhập thất bại với mã lỗi {response.status_code}")

httppost("https://httpbin.org/post", "test", "test123QWE@AD")
