This show you how to run Docker container on merced.

1) your folder shoudl contain a `Dockerfile` with the instructions on how to build a docker image. 

2) BUild the docker image, you likely want to give a nice name to your image:

```
docker build . -t docker-merced --build-arg GID=$(id -g) --build-arg UID=$(id -u) --build-arg USER=$USER
```

3) to access your file your docker image MUST do the following:


```
RUN groupadd -g $GID $USERNAME
RUN useradd -r -u $UID -g $GID $USERNAME
USER $USERNAME
```

Where $GID is the value of `id -g`, $UID is the value of `id -u` and $USERNAME is your usaername



`.` indicate to build current folder and `-t docker-merced` give a name to the image. 
please give a unique name or you may run or erase some else image. 



```
docker run  -v $(pwd):$(pwd) -w $(pwd)  --rm -u $(id -u ${USER}):$(id -g ${USER}) -it docker-merced
```

The -v make sure that the current workign directory is mounted inside eh container with the same path and is set as the current working directory when inside docker.



