# Anaconda envieonment
# - but use nvidia docker
# - build w/ CUDA
#
# less stuff in this than the object_detection_api 

FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04

WORKDIR /app

# this will eliminate interactive dialog on installation steps
ARG DEBIAN_FRONTEND=noninteractive
ARG USER_PASSWORD=none


LABEL author=jduff

ENV user jay
ENV group duff

# --- user: root
RUN apt-get update && apt-get install -y apt-utils 
RUN apt-get install -y sudo
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

# installing gedit - very problematic!!! 
# RUN sudo apt-get install -y gedit

# add user
RUN useradd -m -d /home/${user} ${user} && \
    chown -R ${user} /home/${user} && \
    adduser ${user} sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# --- user: jay

USER ${user}
WORKDIR /home/${user}

# Install apt dependencies
RUN sudo apt-get update 
RUN sudo apt-get install -y \
    nano \
    git \
    gpg-agent \
    python3-cairocffi \
    protobuf-compiler \
    python3-pil \
    python3-lxml \
    python3-tk \
    wget
      
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository ppa:deadsnakes/ppa
RUN sudo apt-get update
RUN sudo apt-get install -y apt-utils
RUN sudo apt-get install -y pigz
RUN sudo apt-get install -y awscli

# access python 3.9 with $ python3.9
RUN sudo apt-get install -y python3.7
RUN sudo apt-get install -y python3.9
RUN sudo apt-get install -y python3-pip
RUN sudo apt-get install -y python-dev
RUN sudo apt-get install -y python3-dev
RUN sudo apt-get install -y python3.7-dev
RUN sudo apt-get install -y python3.8-dev
RUN sudo apt-get install -y python3.9-dev
RUN sudo apt-get install -y python-setuptools
RUN sudo apt-get install -y python3-setuptools
RUN sudo apt-get install -y python3-testresources

# you should be at python 3.8 only
RUN sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
RUN sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 2
RUN sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.9 3
RUN sudo update-alternatives  --set python /usr/bin/python3.8


RUN python -m pip install --upgrade pip


# install Anaconda
RUN wget -O install_anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh
RUN bash install_anaconda.sh -bu
RUN ./anaconda3/bin/conda config --set auto_activate_base false

# -- do not create any environments --

RUN echo "*** finished - /project/docker/object_detection_api$ bash ./post_build.sh"


