# Version: 0.0.1

FROM ubuntu:latest

MAINTAINER Rene Dohmen <acidjunk@gmail.com>
ENV REFRESHED_AT 2017-02-02

# env vars
ENV PW admin
ENV INSTALL_DIR /home/www-data
ENV W2P_DIR $INSTALL_DIR/web2py
ENV CERT_PASS web2py
ENV CERT_DOMAIN www.example.com

WORKDIR $INSTALL_DIR
USER root

# update ubuntu and install necessary packages
RUN apt-get update && \
	apt-get autoremove && \
	apt-get autoclean && \
	apt-get -y install nginx-full && \
	apt-get -y install build-essential python-dev libxml2-dev python-pip unzip wget supervisor && \
    pip install -U six && \
    pip install -U pip setuptools && \
    pip install -U gdata && \
    pip install -U uwsgi && \
	mkdir /etc/nginx/conf.d/web2py

# copy nginx config files from repo
COPY gzip_static.conf /etc/nginx/conf.d/web2py/gzip_static.conf
COPY gzip.conf /etc/nginx/conf.d/web2py/gzip.conf
COPY web2py /etc/nginx/sites-available/web2py

# setup nginx
RUN ln -s /etc/nginx/sites-available/web2py /etc/nginx/sites-enabled/web2py && \
	rm /etc/nginx/sites-enabled/default && \
	mkdir /etc/nginx/ssl && cd /etc/nginx/ssl && \
	openssl genrsa -passout pass:$CERT_PASS 1024 > web2py.key && \
	chmod 400 web2py.key && \
	openssl req -new -x509 -nodes -sha1 -days 1780 -subj "/C=US/ST=Denial/L=Chicago/O=Dis/CN=$CERT_DOMAIN" -key web2py.key > web2py.crt && \
	openssl x509 -noout -fingerprint -text < web2py.crt > web2py.info && \
	mkdir /etc/uwsgi && \
	mkdir /var/log/uwsgi

# copy Emperor config files from repo
COPY web2py.ini /etc/uwsgi/web2py.ini
COPY uwsgi-emperor.conf /etc/init/uwsgi-emperor.conf

# copy Supervisor config file from repo
COPY supervisor-app.conf /etc/supervisor/conf.d/

# get and install web2py
RUN wget http://web2py.com/examples/static/web2py_src.zip && \
    mkdir tmp && \
    unzip web2py_src.zip -d tmp && \
    mv tmp/web2py web2py && \
    rm web2py_src.zip && \
    rm -rf tmp && \
    mv web2py/handlers/wsgihandler.py web2py/wsgihandler.py && \
    chown -R www-data:www-data web2py

EXPOSE 80 443

USER www-data

WORKDIR $W2P_DIR

RUN python -c "from gluon.main import save_password; save_password('$PW',80)" && \
    python -c "from gluon.main import save_password; save_password('$PW',443)"

USER root

CMD ["supervisord", "-n"]
