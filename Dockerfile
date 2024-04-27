FROM busybox
RUN echo "Hello, world" > /www/index.html
CMD nohup busybox httpd -f -p 8080 -h /www
