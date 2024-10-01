import requests

def httpdownload(url, remote_file):
  
    download_url = f"{url}{remote_file}"   
    response = requests.get(download_url)
    
    if response.status_code == 200:

        file_size = len(response.content)
        print(f"Kích thước file ảnh: {file_size} bytes")

        with open("downloaded_image.png", "wb") as file:
            file.write(response.content)
    else:
        print(f"Không tồn tại file ảnh với mã lỗi {response.status_code}")

httpdownload("https://httpbin.org", "/image/png")
