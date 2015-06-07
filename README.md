# docker-play
---

This is a minimal docker container based on Debian 7.8 for Play Framework development.

# Description
You should run this container interactively and launch activator console commands from within your play projects directories.

Includes:

 - Oracle JDK 1.8
 - Typesafe Activator 1.3.2
 - `git`, `wget`, `curl`, `build-essential`

## Users
A `play` user with sudoers privileges. Home is at `/home/play`.

## Volumes
Exports a volume on `/home/play/Code`.
You can mount the volume on run to a local directory containing your code.

### ivy2 and sbt caches

Java `user.home` variable is defined, pointing to `/home/play/Code`.
In this way, all dependencies are kept if you mount the `/home/play/Code` volume on `/home/play/Code/.ivy2` and `/home/play/Code/.sbt` directories.

## Ports
Three ports are exposed:
 - 9000: default Play port.
 - 9999: default Play debug port.
 - 8888: default Activator UI port.

Remember to map the ports to the docker host on run.

# How to run the container
## Using docker
You need docker v1.3+ installed. To get the container up and running and drop to an interactive shell, run:

```
sudo docker run --rm -it -v "/home/dordoka/Code:/home/play/Code" -p 9000:9000 -p 9999:9999 -p 8888:8888 dordoka/play-framework
```
Remember to change `/home/dordoka/Code` to the directory where your code is stored.

## Using docker-compose
If you have `docker-compose` installed, you can just launch:

```
sudo docker-compose up
```
