# Web2py docker for production
This is an attempt to create a dockerized web2py suitable for production. It can be used as a standalone container, 
behind a reversed proxy.

## Usage
Running a new instance of web2py:
```
docker run -p 80:80 -p 443:443 -d acidjunk/web2py
Running an instance of web2py to include an existing web2py application:
```
---
```
docker run -p 80:80 -p 443:443 -v /local/path/to/web2py_app:/home/www-data/web2py/applications/web2py_app -d acidjunk/web2py
```
---

Inspired by: [thehipbot](https://hub.docker.com/r/thehipbot/web2py/) and [rafs](https://hub.docker.com/r/rafs/web2py/)
