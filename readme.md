# RPFM-Docker

A docker container to use RPFM, the Total War mod creation tool, on any OS.
More about RPFM: https://github.com/Frodo45127/rpfm

## Ideas

I struggled to build RPFM on my Ubuntu 22.08 machine due to libraries being at the wrong version etc., and rather than
tinkering with my files too much, I decided to do it all inside of a docker container.

## Usage

```sh
# 1. Move to this directory and build the rpfm-docker image (one-off)
docker build -t rpfm-docker:latest .

# 2. Open xhost access so that the docker container can connect to the host display
xhost +

# 3. Run an rpfm-docker image connecting the volumes which contain your Total War files (and any other
# volume that you want). Snippet below is for TWWH2 on Linux.
docker run -it --rm \
  -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "~/.steam/steamapps/common/Total War WARHAMMER II:/Total War WARHAMMER 2" \
  -v "~/.steam/steamapps/workshop/content/594570:/Workshop" \
  rpfm-docker:latest

# After all is done, close xhost access
xhost -
```

