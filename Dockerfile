FROM nvidia/cuda:11.2.2-base-ubuntu20.04

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y wget git bzip2 libcairo2-dev ca-certificates curl numactl libjemalloc-dev make automake gcc g++ subversion build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev liblzma-dev ffmpeg libsm6 libxext6 && \
    wget https://www.python.org/ftp/python/3.10.6/Python-3.10.6.tgz && \
    tar -xf Python-3.10.6.tgz && \
    cd Python-3.10.6 && \
    ./configure --enable-optimizations && \
    make altinstall && \
    ln -sf /Python-3.10.6 /python3 && \
    /python3/python -m pip install --upgrade pip setuptools wheel Cython
    
ENV python_cmd=/python3/python
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git && \
  cd stable-diffusion-webui && \
  git config --global --add safe.directory /stable-diffusion-webui && \
  git checkout 1.1.1 && \
  /bin/bash webui.sh -f --skip-torch-cuda-test --exit
  
WORKDIR /stable-diffusion-webui 


CMD ["/bin/bash"]
