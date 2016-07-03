# Run windows programs like a champion

FROM ubuntu:14.04
MAINTAINER Arpit Nagar <arpitgold@gmail.com>

RUN locale-gen en_US.UTF-8

RUN apt-get update && apt-get install -y software-properties-common \
      && add-apt-repository -y ppa:ubuntu-wine/ppa

# versions for wine things here: https://launchpad.net/~ubuntu-wine/+archive/ubuntu/ppa
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
      wine1.8 \
      wine-mono4.5.6 \
      wine-gecko2.40 \
      wine-gecko2.40:i386 \
      xvfb \
      && rm -rf /var/lib/apt/lists/*
      
# Generate wine settings, waiting for wineserver to finish
RUN xvfb-run wine "wineboot" && while pgrep -u `whoami` wineserver > /dev/null; do sleep 1; done

# For reference, generate wine settings for 32 bit windows in a custom location
#RUN WINEPREFIX="/root/.wine32" WINEARCH="win32" xvfb-run wine "wineboot"

#CMD wine "/root/.wine/drive_c/Program Files/Internet Explorer/iexplore.exe"

# Installing Mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list
RUN echo "deb http://download.mono-project.com/repo/debian wheezy-apache24-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list
RUN apt-get update && apt-get install -yf mono-complete mono-devel nuget ca-certificates-mono fsharp
