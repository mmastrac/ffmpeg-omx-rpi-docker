FROM debian:buster
ARG FFMPEG_VERSION=4.0.2

RUN echo "Building FFMPEG (${FFMPEG_VERSION})"

# Setup
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -qq install build-essential cmake cmake-data curl git libomxil-bellagio-dev libx264-dev pkg-config sudo xz-utils

# Build rpi userland
WORKDIR "/root"
RUN git clone --depth 1 https://github.com/raspberrypi/userland.git
WORKDIR "/root/userland"
RUN ./buildme
# Required to link deps
RUN echo "/opt/vc/lib" > /etc/ld.so.conf.d/00-vmcs.conf

# Build FFMPEG
RUN curl https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz -o ffmpeg.tar.xz
RUN tar xf ffmpeg.tar.xz
WORKDIR "ffmpeg-${FFMPEG_VERSION}"
RUN PKG_CONFIG_PATH=/opt/vc/lib/pkgconfig ./configure --arch=armel --target-os=linux \
	--enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree --enable-mmal \
	--incdir=/opt/vc/include/IL
RUN make -j4

RUN ldconfig

# Maybe necessary?
#ADD omx.patch .
#RUN patch -p0 < omx.patch
#RUN make -j4

# TODO: Use a multi-stage build to pull down that binary
RUN ln -s `pwd`/ffmpeg /usr/local/bin/ffmpeg
WORKDIR "/root"
