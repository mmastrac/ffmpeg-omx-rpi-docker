# FFMPEG configured for OMX on Raspberry Pi

This is an experiment to build a simple docker image that supports ffmpeg w/OMX and MMAL support on the Raspberry Pi, allowing hardware support for encode and decode.

Run it:

```
docker run -it --rm --device=/dev/vchiq mmastrac/ffmpeg-omx-rpi:latest ffmpeg ...
```

You might need to add the following to your Pi's boot configuration:

```
gpu_mem = 128
```

Find it on Docker Hub here: https://hub.docker.com/r/mmastrac/ffmpeg-omx-rpi/
