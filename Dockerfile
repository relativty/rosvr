FROM ubuntu:14.04

# Set workdir
WORKDIR /root/

# Add repo for CMake 3
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:george-edison55/cmake-3.x

# Install tools
RUN apt update
RUN apt -y upgrade
RUN apt install -y git cmake build-essential libboost-all-dev libusb-1.0-0-dev libopencv-dev wget

# Install libfunctionality
RUN git clone https://github.com/OSVR/libfunctionality.git
RUN mkdir libfunctionality/build
WORKDIR /root/libfunctionality/build
RUN cmake ..
RUN make
RUN make install
WORKDIR /root/

# Install jsoncpp
RUN git clone https://github.com/vrpn/jsoncpp.git
RUN mkdir -p jsoncpp/build/release
WORKDIR /root/jsoncpp/build/release
RUN cmake -DCMAKE_BUILD_TYPE=release -DBUILD_STATIC_LIBS=OFF -DBUILD_SHARED_LIBS=ON -DARCHIVE_INSTALL_DIR=. -G "Unix Makefiles" ../..
RUN make
RUN make install
WORKDIR /root/

# Install OSVR-Core
RUN git clone --recurse-submodules https://github.com/OSVR/OSVR-Core.git
RUN mkdir OSVR-Core/build
WORKDIR /root/OSVR-Core/build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=~/osvr
RUN make
RUN make install
WORKDIR /root/

# Install EMPY
RUN wget http://www.alcyone.com/software/empy/empy-3.3.3.tar.gz
RUN tar -xf empy-3.3.3.tar.gz
WORKDIR empy-3.3.3
RUN python setup.py install
WORKDIR /root/

# Add ROS repository & install tools
RUN echo "deb http://packages.ros.org/ros/ubuntu quantal main" > /etc/apt/sources.list.d/ros-latest.list
RUN wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
RUN apt update
RUN apt install -y python-catkin-pkg python-empy python-nose python-setuptools libgtest-dev

# Install catkin
RUN git clone https://github.com/ros/catkin.git
RUN mkdir catkin/build
WORKDIR /root/catkin/build
RUN cmake ..
RUN make
RUN make install
WORKDIR /root/

# Install serial
RUN git clone https://github.com/wjwwood/serial.git
WORKDIR /root/serial
RUN make
RUN make install
RUN cp -r /tmp/usr/local/ /usr
WORKDIR /root/

# Get the Relativ OSVR plugin
RUN git clone https://github.com/Xobtah/relativ-osvr-plugin
RUN mkdir relativ-osvr-plugin/relativ_osvr_plugin/build
WORKDIR /root/relativ-osvr-plugin/relativ_osvr_plugin/build
RUN cmake ..
RUN make
WORKDIR /root/

# Set workdir
WORKDIR /root/
