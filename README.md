# stable-diffusion-webui-docker
由于stable-diffusion-webui运行时占用内存过多经常被操作系统给杀掉，所以想到使用docker来部署，但docker部署时遇到了不少坑，故将其记录希望能对你有帮助。
### 安装nvidia-container-toolkit
```
# 安装nvidia-container-toolkit以支撑容器内使用GPU，如果安装完成并一切顺利，运行下面命令
docker run --rm --runtime=nvidia --gpus all nvidia/cuda:11.2.2-base-ubuntu20.04 nvidia-smi
# 正常的输出如下：
Thu May 18 06:08:20 2023       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 460.91.03    Driver Version: 460.91.03    CUDA Version: 11.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Tesla T4            On   | 00000000:00:08.0 Off |                    0 |
| N/A   39C    P0    27W /  70W |   7967MiB / 15109MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+
```
### 构建镜像
```
# 构建过程比较久，请耐心等待
# 这里的stable-diffusion-webui tag切换到了1.1.1，因为最新的两个tag构建会报错，详情可看https://github.com/AUTOMATIC1111/stable-diffusion-webui/issues/10494
docker build  -t sd .
```
### 运行容器
```
# 这里挂载了模型到容器，如果你没提前下载首次运行会进行下载
docker run -it -d --name sd --gpus all -p 7860:7860 -v /data/models:/stable-diffusion-webui/models sd /bin/bash webui.sh --share --no-half --enable-insecure-extension-access --xformers
```
### 使用docker-compose运行
```
# 下载docker-compose,下载的版本必须>=1.29.2
# curl -SL https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64 -o /usr/bin/docker-compose
docker-compose up -d
```