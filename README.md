# Docker container with Mapproxy on apache2

This container runs Apache 2 with Mapproxy configured to working together.

This container has the following parameters:

* Port "80", where Apache 2 listens on.
* Folder "mapproxy/cache_data/", where cahed tiles are placed.

The following URLs are available:

* Mapproxy interface http://container-ip/mapproxy/
* WMS service URL: http://container-ip/mapproxy/service

# Create and run a container

```sh
git clone https://github.com/itkoblov/mapproxy.git
cd mapproxy
sudo chmod a+rwx -R cache_data/
docker compose build && docker compose up -d
```

# Run the container

```sh
cd mapproxy
docker compose up -d
```

# To view maps from OpenStreetMap servers instead of cached maps from the cache_data/ folder, follow these steps
```sh
cd mapproxy
docker compose down
sudo chmod a-rwx -R cache_data/
docker compose up -d
```
