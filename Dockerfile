FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

# Install utilities
RUN apt-get update --fix-missing && apt-get -y upgrade && \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
wget zip curl build-essential pkg-config libssl-dev cmake extra-cmake-modules git \
python3-distutils zlib1g-dev gperf qttools5-dev libqt5svg5-dev libqt5x11extras5-dev \
qtdeclarative5-dev libxext-dev libkdecorations2-dev qtscript5-dev libkf5*-dev kirigami2-dev gettext \
libxcb-glx0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-sync-dev libxcb-xinput-dev libx11-xcb-dev \
libxrender-dev libxcb-keysyms1-dev libxcb-res0-dev flex bison libudev-dev libxslt-dev liburi-perl \
libgcrypt-dev ca-certificates unzip

# Install the dependencies speicified on the github page
# https://github.com/Frodo45127/rpfm
RUN apt-get install -y qt5-default xz-utils p7zip-full p7zip-rar

# Install rust / cargo
# https://unix.stackexchange.com/questions/532708/curl-in-non-interactive-mode
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Install KDE Framework (KF5)
# https://frodo45127.github.io/rpfm/chapter_comp.html
# https://www.linuxfromscratch.org/blfs/view/9.0-systemd/kde/krameworks5.html
RUN wget -r -nH -np -nd --no-check-certificate -A xz https://download.kde.org/Attic/frameworks/5.68/

# Install extra-cmake-modules
RUN git config --global http.sslverify false
RUN git clone https://invent.kde.org/frameworks/extra-cmake-modules.git
RUN cd extra-cmake-modules && git checkout v5.68.0
RUN cd extra-cmake-modules && mkdir build && cd build
RUN cd extra-cmake-modules && cmake .
RUN cd extra-cmake-modules && make && make install

COPY frameworks-5.68.0.md5  /

COPY as_root.sh /
RUN chmod +x /as_root.sh
RUN /as_root.sh

COPY install_kde.sh /
RUN chmod +x /install_kde.sh
RUN /install_kde.sh


# Download and unzip the source
RUN wget --no-check-certificate https://github.com/Frodo45127/rpfm/archive/refs/tags/v3.0.16.zip
RUN unzip v3.0.16.zip

# Build RPFM
RUN cd rpfm-3.0.16/ && source $HOME/.cargo/env && cargo build && cargo build --release

CMD rpfm-3.0.16/target/release/rpfm