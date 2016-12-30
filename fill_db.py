import requests

url = "http://kodev.ru:4000/api/concerts/create"


for i in range(30):
    data = {
        "concert[name]": "Concert %d" % i,
        "concert[description]": "description %d" % i,
        "concert[date][day]": 1,
        "concert[date][month]": 2,
        "concert[date][year]": 1999,
    }
    file = open("/home/konstantin/Pictures/noimagefound.jpg", "rb")
    files = {"concert[picture]": file}
    requests.post(url, data=data, files=files)
    file.close()

