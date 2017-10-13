
```
$ docker build -t webdav1 .
$ docker run -d -e HOME=/home/shohey1226 -e USERNAME=shohey1226 -e PASSWORD=test -p 8888:80 -p 8080:8080 webdav1:latest
```
