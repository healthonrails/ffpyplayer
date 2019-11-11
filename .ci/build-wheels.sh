#!/bin/bash
set -e -x

yum -y install libass libass-devel autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial \
pkgconfig zlib-devel enca-devel fontconfig-devel openssl openssl-devel wget openjpeg openjpeg-devel \
libtiff libtiff-devel dbus-devel ibus-devel libsamplerate-devel \
libudev-devel xz
mkdir ~/ffmpeg_sources;
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/ffmpeg_build/lib;
export PATH="$HOME/ffmpeg_build/bin:$PATH"
export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig:/usr/lib/pkgconfig/"

FFPY_ROOT=/io

cd ~/ffmpeg_sources
CMAKE_VERSION=3.15.5
wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz
tar xzf cmake-${CMAKE_VERSION}.tar.gz
cd cmake-${CMAKE_VERSION}
./configure --prefix=/usr/local/cmake-${CMAKE_VERSION}
gmake
make
make install

cd ~/ffmpeg_sources
ALSA=alsa-lib-1.1.9
curl -sL ftp://ftp.alsa-project.org/pub/lib/${ALSA}.tar.bz2 > ${ALSA}.tar.bz2
tar xjf ${ALSA}.tar.bz2
cd ${ALSA}
./configure --with-configdir=/usr/share/alsa --prefix="$HOME/ffmpeg_build"
make
make install
rm /lib64/libasound.so.2.0.0
ln -s $HOME/ffmpeg_build/lib/libasound.so.2.0.0 /lib64/

cd ~/ffmpeg_sources
FLAC=flac-1.3.3
curl -sL http://downloads.xiph.org/releases/flac/${FLAC}.tar.xz > ${FLAC}.tar.xz
# The tar we have is too old to handle .tar.xz directly
unxz ${FLAC}.tar.xz
tar xf ${FLAC}.tar
cd $FLAC
./configure --prefix="$HOME/ffmpeg_build"
make
make install

cd ~/ffmpeg_sources
PNG=libpng-1.6.37
curl -sL http://download.sourceforge.net/libpng/${PNG}.tar.gz > ${PNG}.tar.gz
tar xzf ${PNG}.tar.gz
cd $PNG
./configure --prefix="$HOME/ffmpeg_build"
make
make install

cd ~/ffmpeg_sources
FREETYPE=freetype-2.10.1
curl -sL http://download.savannah.gnu.org/releases/freetype/${FREETYPE}.tar.gz > ${FREETYPE}.tar.gz
tar xzf ${FREETYPE}.tar.gz
cd $FREETYPE
./configure --prefix="$HOME/ffmpeg_build"
make
make install

cd ~/ffmpeg_sources
WEBP=1.0.3
curl -sL https://github.com/webmproject/libwebp/archive/v${WEBP}.tar.gz > libwebp-v${WEBP}.tar.gz
tar xzf libwebp-v${WEBP}.tar.gz
cd libwebp-$WEBP
./autogen.sh
./configure --prefix="$HOME/ffmpeg_build"
make
make install

cd ~/ffmpeg_sources;
wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz;
tar xzf openssl-1.1.1d.tar.gz;
cd openssl-1.1.1d;
./config -fpic shared --prefix="$HOME/ffmpeg_build";
make;
make install;

cd ~/ffmpeg_sources;
wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz;
tar xzf yasm-1.3.0.tar.gz;
cd yasm-1.3.0;
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/ffmpeg_build/bin";
make;
make install;
make distclean;

cd ~/ffmpeg_sources;
wget http://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.gz;
tar -xvzf nasm-2.14.02.tar.gz;
cd nasm-2.14.02;
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/ffmpeg_build/bin";
make;
make install;
make distclean;

cd ~/ffmpeg_sources;
wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2;
tar xjf last_x264.tar.bz2;
cd x264-snapshot*;
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/ffmpeg_build/bin" --enable-shared --extra-cflags="-fPIC";
make;
make install;
make distclean;

cd ~/ffmpeg_sources;
curl -kLO https://managedway.dl.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz;
tar xzf lame-3.100.tar.gz;
cd lame-3.100;
./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --enable-shared;
make;
make install;
make distclean;

cd ~/ffmpeg_sources
curl -sLO https://github.com/fribidi/fribidi/releases/download/v1.0.7/fribidi-1.0.7.tar.bz2
tar xjf fribidi-1.0.7.tar.bz2
cd fribidi-1.0.7
./configure --prefix="$HOME/ffmpeg_build" --enable-shared;
make
make install

cd ~/ffmpeg_sources
curl -sLO https://github.com/libass/libass/releases/download/0.14.0/libass-0.14.0.tar.gz
tar xzf libass-0.14.0.tar.gz
cd libass-0.14.0
./configure --prefix="$HOME/ffmpeg_build" --enable-shared --disable-require-system-font-provider;
make
make install

cd ~/ffmpeg_sources
wget https://bitbucket.org/multicoreware/x265/get/default.tar.gz
tar xzf default.tar.gz
cd multicoreware-x265-*/build/linux
PATH="/usr/local/cmake-${CMAKE_VERSION}/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=on ../../source
make
make install

cd ~/ffmpeg_sources
git clone --depth 1 --branch v2.0.1 https://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
git apply ${FFPY_ROOT}/.ci/fdk.patch
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
make
make install

cd ~/ffmpeg_sources
curl -LO https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz
tar xzvf opus-1.3.1.tar.gz
cd opus-1.3.1
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
make
make install

cd ~/ffmpeg_sources
curl -LO http://downloads.xiph.org/releases/ogg/libogg-1.3.4.tar.gz
tar xzvf libogg-1.3.4.tar.gz
cd libogg-1.3.4
./configure --prefix="$HOME/ffmpeg_build" --enable-shared
make
make install

cd ~/ffmpeg_sources;
curl -LO http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
tar xzvf libtheora-1.1.1.tar.gz
cd libtheora-1.1.1
./configure --prefix="$HOME/ffmpeg_build" --enable-shared --disable-examples --disable-doc;
make;
make install

cd ~/ffmpeg_sources
curl -LO http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.gz
tar xzvf libvorbis-1.3.6.tar.gz
cd libvorbis-1.3.6
./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --enable-shared
make
make install

cd ~/ffmpeg_sources
git clone --depth 1 --branch v1.8.1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="$HOME/ffmpeg_build" --disable-examples  --as=yasm --enable-shared --disable-unit-tests
make
make install

cd ~/ffmpeg_sources
FSYNTH="2.0.8"
curl -sL https://github.com/FluidSynth/fluidsynth/archive/v${FSYNTH}.tar.gz > v${FSYNTH}.tar.gz
tar xzf v${FSYNTH}.tar.gz
cd fluidsynth-$FSYNTH
mkdir build
cd build
PATH="/usr/local/cmake-${CMAKE_VERSION}/bin:$PATH" cmake -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" ..
make
make install

cd ~/ffmpeg_sources;
wget https://www.libsdl.org/release/SDL2-2.0.10.tar.gz;
tar xzf SDL2-2.0.10.tar.gz;
cd SDL2-2.0.10;
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/ffmpeg_build/bin";
make;
make install;
make distclean;

cd ~/ffmpeg_sources;
wget http://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.tar.gz;
tar xzf SDL2_mixer-2.0.4.tar.gz;
cd SDL2_mixer-2.0.4;
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/ffmpeg_build/bin" \
    --disable-dependency-tracking \
    --disable-music-flac-shared \
    --disable-music-midi-fluidsynth \
    --disable-music-midi-fluidsynth-shared \
    --disable-music-mod-mikmod-shared \
    --disable-music-mod-modplug-shared \
    --disable-music-mp3-mpg123 \
    --disable-music-mp3-mpg123-shared \
    --disable-music-ogg-shared;
make;
make install;
make distclean;

cd ~/ffmpeg_sources;
wget http://ffmpeg.org/releases/ffmpeg-4.2.1.tar.bz2;
tar xjf ffmpeg-4.2.1.tar.bz2;
cd ffmpeg-4.2.1;
./configure --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include -fPIC" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --bindir="$HOME/ffmpeg_build/bin" --enable-gpl --enable-libmp3lame --enable-libx264 --enable-libx265 --enable-libfdk_aac --enable-nonfree --enable-libass --enable-libvorbis --enable-libtheora --enable-libfreetype --enable-libopus --enable-libvpx --enable-openssl --enable-libwebp --enable-shared;
make;
make install;
make distclean;
hash -r;

# Compile wheels
for PYBIN in /opt/python/*3*/bin; do
    if [[ $PYBIN != *"34"* ]]; then
        "${PYBIN}/pip" install --upgrade setuptools pip
        "${PYBIN}/pip" install --upgrade cython nose
        USE_SDL2_MIXER=1 "${PYBIN}/pip" wheel ${FFPY_ROOT}/ -w dist/
    fi
done

# Bundle external shared libraries into the wheels
for whl in dist/*.whl; do
    auditwheel repair --plat manylinux2010_x86_64 "$whl" -w ${FFPY_ROOT}/dist/
done
