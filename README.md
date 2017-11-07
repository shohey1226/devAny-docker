
```
$ docker build -t webdav1 .
$ docker run -d -v $HOME/devany:/home/shohey1226 -e HOME=/home/shohey1226 -e USERNAME=shohey1226 -e PASSWORD=test -p 8888:8888  devany:latest
```
