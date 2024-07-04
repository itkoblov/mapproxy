from math import tan, pi, log, cos
import requests
import os

# Tileserver pattern
tileserver_pattern = "https://tile.openstreetmap.org/%d/%d/%d.png"

# Longitude
left_x = 7.413644
right_x = 7.519490

# Latitudes
left_y = 51.489529
right_y = 51.538781

# Zoom levels
zoom_min = 6
zoom_max = 7

def make_dirs(z, x):
    os.makedirs(f"tiles/{z}/{x}", exist_ok=True)

for zoom in range(zoom_min, zoom_max + 1):
    num_tiles = 2 ** zoom
    if zoom > 5:
        x = int(num_tiles * (left_x + 180.0) / 360.0)
        X = int(num_tiles * (right_x + 180.0) / 360.0)
        y = int(num_tiles * (1.0 - log(tan(left_y * pi / 180.0) + 1 / cos(left_y * pi / 180.0)) / pi) / 2.0)
        Y = int(num_tiles * (1.0 - log(tan(right_y * pi / 180.0) + 1 / cos(right_y * pi / 180.0)) / pi) / 2.0)
    else:
        x = 0
        y = 0
        X = num_tiles - 1
        Y = num_tiles - 1

    y, Y = sorted((y, Y))
    x, X = sorted((x, X))

    for q_x in range(x, X + 1):
        for q_y in range(y, Y + 1):
            filename = f"tiles/{zoom}/{q_x}/{q_y}.png"
            if not os.path.isfile(filename):
                url = tileserver_pattern % (zoom, q_x, q_y)
                print(url, "...")
                make_dirs(zoom, q_x)
                headers = {
                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
                    'Referer': 'https://www.openstreetmap.org/'
                }
                response = requests.get(url, headers=headers)
                if response.status_code == 200:
                    with open(filename, 'wb') as f:
                        f.write(response.content)
                    print("Saved:", filename)
                else:
                    print("Failed to fetch:", url, "Status code:", response.status_code)
            else:
                print("Already exists:", filename)

