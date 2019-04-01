FROM alpine:3.9

RUN apk update && apk add aria2 nginx --no-cache

RUN mkdir /run/nginx /var/www/html /var/www/html/aria2 /usr/local/aria2 \
     && touch /usr/local/aria2/aria2.session
COPY ./service.sh /root/service.sh
COPY ./aria2.conf /usr/local/aria2/aria2.conf
COPY ./nginx-default.conf /etc/nginx/conf.d/default.conf
ADD https://github.com/mayswind/AriaNg/releases/download/1.0.1/AriaNg-1.0.1.zip /var/www/html/aria2 
RUN cd /var/www/html/aria2 && unzip AriaNg-1.0.1.zip && rm -f AriaNg-1.0.1.zip

EXPOSE 80 6800

CMD ["/bin/sh", "/root/service.sh"]
