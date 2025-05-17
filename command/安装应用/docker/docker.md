![docker.png](../../../assets/docker.png)

# Docker

## 简介

Docker 是一个完整的容器化平台，它包含多个工具和技术，用于开发、部署和运行容器化应用程序。
Docker 提供了从开发到生产的一体化工作流，帮助开发者和运维团队构建和管理容器。
本文档主要是帮助用户在 Centos7.6 Linux 下安装 Docker。本文档的Docker 采用

- Docker v24.0.7
- Docker Compose v2.27.1

## 安装方式

docker 安装的方式很多种，可根据不同的场景进行安装

- **使用官方安装脚本**：适合快速安装。
- **通过包管理器安装**：如 `yum` 或 `apt`，适合有特定版本需求的用户。
- **使用二进制文件安装**：适合需要手动控制安装过程的用户。
- **通过容器化方式安装**：适合测试或临时使用。
- **使用云服务提供的镜像**：适合在云环境中快速部署。

> 本文档为了应对不同的需求，上方的方式都会经过真是的 CentOs 7.6 服务器进行安装，保证用户更好的使用 Docker

## 安装前准备

### 检测环境

```bash
docker info
```

### 检测系统版本

```bash
cat /etc/centos-release
```

### 检查 SELinux

```bash
sestatus
```

### 关闭 Selinux

```bash
setenforce 0
```

### 开启 Selinux

```bash
setenforce 1
```

> 说明一下为什么要关闭 selinux，selinux 是 Linux 系统的一种安全机制，它会限制 Docker 的一些操作，导致 Docker 无法正常工作。
>
> 关闭 selinux 可以避免这些问题，但也会降低系统的安全性。

## 官方安装脚本

## 包管理器

### 更新 yum 程序

```bash
yum update -y
```

### 安装必要的依赖

```shell
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

### 添加 Docker 仓库

```bash
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

### 安装指定版本 Docker

```bash
# 查看可用版本
sudo yum list docker-ce --showduplicates | sort -r

# 安装指定版本 Docker v24.0.7
sudo yum install -y docker-ce-24.0.7 docker-ce-cli-24.0
```

### 启动并设置开机自启

```bash 
# 启动 Docker 服务
sudo systemctl start docker

# 设置开机自启
sudo systemctl enable docker

# 验证安装
docker --version
```

### 设置镜像加速

```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://mirror.ccs.tencentyun.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

```

### sudo 权限

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```
>

## 二进制文件

## 容器化方式安装

## 常见镜像


## Docker 学习教程

本文档不提供学习，如需学习请转至官网 [docker 教程](https://docs.docker.com/)