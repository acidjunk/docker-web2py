# About this repo
The repo contains the Docker image for the [web2py](http://www.web2py.com/) web framework. See the hub page. 

## Usage:
`docker pull acidjunk/web2py`

`docker run -p 443:443 -p 80:80 -v my_app:/home/www-data/web2py/applications/webapp acidjunk/web2py`

## Todo:
- Add postgres support
- Make it possible to run without SSL so setup behind a reversed Nginx Proxy is easier
- Make it possible to add your own python requirements
- Upgrade python to 2.7.12

---
Inspired by: [thehipbot](https://hub.docker.com/r/thehipbot/web2py/) and [rafs](https://github.com/rafsAcorsi/docker-web2py/)
