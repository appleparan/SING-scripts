# FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
FROM nvcr.io/nvidia/tensorrt:23.01-py3

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    MPLBACKEND=AGG \
    PIP_IGNORE_INSTALLED=0 \
    PYTHONUNBUFFERED=1

RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Add universe repository
RUN apt-get update
RUN apt-get install -y --no-install-recommends software-properties-common
RUN add-apt-repository universe
RUN apt-get update

RUN apt-get install -y --no-install-recommends locales tzdata

RUN apt-get install -y --no-install-recommends \
    build-essential automake libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    automake gfortran libtool pkg-config cmake

# Install node and npm for jupyterlab
RUn curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install additional packages
RUN apt-get install -y --no-install-recommends \
    libfreetype6-dev libpng-dev libopenblas-dev liblapack-dev \
    libhdf5-dev hdf5-tools \
    openssh-server openssh-client ncurses-term \
    htop zip unzip git wget curl glances vim dpkg-sig keychain fontconfig

# Install from modern-linux: https://github.com/ibraheemdev/modern-unix
RUN apt-get install -y --no-install-recommends \
    bat fd-find ripgrep silversearcher-ag

# Install Fonts
RUN apt-get install -y --no-install-recommends fonts-firacode
RUN apt-get install -y --no-install-recommends fonts-nanum fonts-nanum-extra
RUN apt-get install -y --no-install-recommends fonts-noto fonts-noto-cjk
RUN curl -L https://github.com/orioncactus/pretendard/raw/main/packages/pretendard/dist/public/variable/PretendardVariable.ttf -o /usr/local/share/fonts/PretendardVariable.ttf
RUN fc-cache -f -v

# Install git-lfs
WORKDIR /tmp
RUN curl -sLO https://github.com/git-lfs/git-lfs/releases/download/v3.2.0/git-lfs-linux-amd64-v3.2.0.tar.gz && \
    tar -zxf git-lfs-linux-amd64-v3.2.0.tar.gz && \
    cd git-lfs-3.2.0 && \
    bash install.sh && \
    rm -rf /tmp/*

# Install Code Server
RUN curl -fL https://github.com/coder/code-server/releases/download/v4.9.1/code-server-4.9.1-linux-amd64.tar.gz | tar -C /usr/local/lib -xz && \
    mv /usr/local/lib/code-server-4.9.1-linux-amd64 /usr/local/lib/code-server-4.9.1 && \
    ln -s /usr/local/lib/code-server-4.9.1/bin/code-server /usr/local/bin/code-server

# # Install Open MPI
RUN mkdir /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.gz && \
    tar zxf openmpi-4.1.4.tar.gz && \
    cd openmpi-4.1.4 && \
    ./configure --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && \
    ldconfig && \
    rm -rf /tmp/openmpi*

# Create a wrapper for OpenMPI to allow running as root by default
RUN mv /usr/local/bin/mpirun /usr/local/bin/mpirun.real && \
    echo '#!/bin/bash' > /usr/local/bin/mpirun && \
    echo 'mpirun.real --allow-run-as-root "$@"' >> /usr/local/bin/mpirun && \
    chmod a+x /usr/local/bin/mpirun

# Install OpenBlas
WORKDIR /tmp
RUN git clone -q --branch=v0.3.20 https://github.com/xianyi/OpenBLAS.git && \
    cd OpenBLAS && \
    make DYNAMIC_ARCH=1 NO_AFFINITY=1 NUM_THREADS=8 FC=gfortran && \
    make install

# Install Python
RUN apt-get install -y --no-install-recommends \
    python3-dev python3-pip python3-setuptools python3-wheel python3-venv python3-tk

RUN python3 -m pip install -U pip setuptools wheel
RUN python3 -m pip install -U python-lsp-server[all]
RUN python3 -m pip install -U jupyterlab \
    jupyterlab-lsp \
    jupyterlab-git \
    jupyter_contrib_nbextensions \
    jupyterlab_widgets \
    ipywidgets \
    jupyter-server-proxy \
    JLDracula

RUN jupyter nbextensions_configurator enable && \
    jupyter contrib nbextension install && \
    jupyter nbextension enable --py --sys-prefix widgetsnbextension && \
    jupyter serverextension enable --py jupyterlab --sys-prefix && \
    jupyter labextension install --no-build @jupyter-widgets/jupyterlab-manager && \
    jupyter labextension install --no-build @krassowski/jupyterlab-lsp && \
    jupyter serverextension enable --py jupyter_lsp && \
    jupyter labextension install --no-build @jupyterlab/toc && \
    jupyter nbextension enable execute_time/ExecuteTime && \
    jupyter nbextension enable toc2/main && \
    jupyter labextension install --no-build @jupyterlab/toc && \
    jupyter labextension install --no-build @jupyterhub/jupyter-server-proxy && \
    jupyter lab build

RUN apt-get autoclean && \
    sed -i 's/source \/usr\/local\/nvm\/nvm.sh//' /etc/bash.bashrc && \
    ln -sf /usr/share/terminfo/x/xterm-color /usr/share/terminfo/x/xterm-256color && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache && \
    rm -rf /tmp/*
