![mysql.jpg](../../../../assets/mysql.jpg)

# Mysql

## 简介

Mysql 集群是一个分布式数据库系统，它可以将多个 Mysql 实例组合在一起，形成一个高可用、高性能的数据库集群。
Mysql 集群可以自动处理故障转移、负载均衡和数据复制等任务，从而提高系统的可靠性和性能。
> 本文档采用 云服务器 + Docker 部署 Mysql 集群， 方便用户快速搭建 Mysql 集群环境。

## 环境版本

- Mysql 8.0.23
- Docker 24.0.7
- Docker Compose 2.27.1

## 镜像下载

```bash
docker pull mysql:8.0.23
```

## 分配端口

这里搭建 Mysql 集群,打算使用 5 个 Mysql 实例,分别使用 3001-3005。

- 3001-3004 做为集群
- 3005 做为事务处理

## 创建网络

```bash
docker network create mysql-cluster
```

## 创建数据目录

> 为了方便数据持久化,我们在宿主机上创建一个目录,用来存放 Mysql 的数据。
>
我这里编写了一个脚本,用来创建数据目录,并且将数据目录挂载到容器中。[createMysqlDataDir.sh](../../../../scripts/createMysqlDataDir.sh)

```bash
mkdir /opt/mysql/mysql-cluster/config
mkdir /opt/mysql/mysql-cluster/data
```

## 创建集群方式

- 运行 docker 命令
- 使用 docker-compose

### 运行 docker 命令

**实例1**

```shell
docker run -it -d \     # -it: 以交互模式运行容器（保留终端输入能力）
  --name mysql_instance_1 \  # 容器名称
  -p 3001:3306 \  # 将宿主机的 3001 端口映射到容器的 3306 端口（MySQL 默认端口）
  --net mysql-cluster \      # 使用名为 mysql-cluster 的自定义 Docker 网络
  -m 400m \   # 设置容器内存限制为 400MB
  -v /opt/mysql/mysql_cluster_instance1/data:/var/lib/mysql \        # 挂载数据目录
  -v /opt/mysql/mysql_cluster_instance1/config:/etc/mysql/conf.d \   # 挂载配置目录
  -e MYSQL_ROOT_PASSWORD=instance_1 \  # 设置 MySQL root 用户的密码
  -e TZ=Asia/Shanghai \   # 设置时区为上海
  --privileged=true \  # 允许容器访问宿主机的所有设备
  mysql:8.0.23 \     # 使用 MySQL 8.0.23 镜像
  --lower_case_table_names=1   # 设置表名不区分大小写
```

**实例2**

```shell
docker run -it -d \     # -it: 以交互模式运行容器（保留终端输入能力）
  --name mysql_instance_2 \  # 容器名称
  -p 3002:3306 \  # 将宿主机的 3001 端口映射到容器的 3306 端口（MySQL 默认端口）
  --net mysql-cluster \      # 使用名为 mysql-cluster 的自定义 Docker 网络
  -m 400m \   # 设置容器内存限制为 400MB
  -v /opt/mysql/mysql_cluster_instance2/data:/var/lib/mysql \        # 挂载数据目录
  -v /opt/mysql/mysql_cluster_instance2/config:/etc/mysql/conf.d \   # 挂载配置目录
  -e MYSQL_ROOT_PASSWORD=instance_2 \  # 设置 MySQL root 用户的密码
  -e TZ=Asia/Shanghai \   # 设置时区为上海
  --privileged=true \  # 允许容器访问宿主机的所有设备
  mysql:8.0.23 \     # 使用 MySQL 8.0.23 镜像
  --lower_case_table_names=1   # 设置表名不区分大小写
```

**实例2**

```shell
docker run -it -d \     # -it: 以交互模式运行容器（保留终端输入能力）
  --name mysql_instance_3 \  # 容器名称
  -p 3003:3306 \  # 将宿主机的 3001 端口映射到容器的 3306 端口（MySQL 默认端口）
  --net mysql-cluster \      # 使用名为 mysql-cluster 的自定义 Docker 网络
  -m 400m \   # 设置容器内存限制为 400MB
  -v /opt/mysql/mysql_cluster_instance3/data:/var/lib/mysql \        # 挂载数据目录
  -v /opt/mysql/mysql_cluster_instance3/config:/etc/mysql/conf.d \   # 挂载配置目录
  -e MYSQL_ROOT_PASSWORD=instance_2 \  # 设置 MySQL root 用户的密码
  -e TZ=Asia/Shanghai \   # 设置时区为上海
  --privileged=true \  # 允许容器访问宿主机的所有设备
  mysql:8.0.23 \     # 使用 MySQL 8.0.23 镜像
  --lower_case_table_names=1   # 设置表名不区分大小写
```

> 上述方式中,我们需要手动创建数据目录,并且在每次启动容器时都需要指定数据目录的挂载路径,比较麻烦。
> 下面我们使用 docker-compose 来创建 Mysql 集群。

### 使用 docker-compose 创建 Mysql 集群
#### 目录结构
.
├── docker-compose.yml  # 容器编排配置
├── .env                # 环境变量
└── mysql/      # 数据与配置目录（自动生成）
├── mysql_cluster_instance1/
├── mysql_cluster_instance2/
└── mysql_cluster_instance3/

#### 创建 .env 文件
```shell
# .env
MYSQL_VERSION=8.0.23
TZ=Asia/Shanghai
MEMORY_LIMIT=400m

INSTANCE_NUM=1

INSTANCE_COUNT=3

# 实例基础配置（按序号递增）
INSTANCE_PORT_START=3001
MYSQL_ROOT_PASSWORD_PREFIX=instance_
```

#### compose 文件 <img src="https://img.shields.io/badge/Status-Pending-yellow" alt="Status"></img>

```shell
# docker-compose.yml
# version: '3.8'

services:
  # 动态生成多个实例
  mysql-instance:
    image: mysql:${MYSQL_VERSION}
    container_name: mysql_instance_${INSTANCE_COUNT}
    ports:
      - ${INSTANCE_PORT_START}:3306
    networks:
      - mysql-cluster
    volumes:
      - ./mysql/mysql_cluster_instance${INSTANCE_COUNT}/data:/var/lib/mysql
      - ./mysql/mysql_cluster_instance${INSTANCE_COUNT}/config:/etc/mysql/conf.d
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD_PREFIX}${INSTANCE_COUNT}
      TZ: ${TZ}
    command: --lower_case_table_names=1
    privileged: true
    deploy:
      resources:
        limits:
          memory: ${MEMORY_LIMIT}
    # 通过 --scale 参数控制实例数量
    scale: ${INSTANCE_COUNT}

# 自定义网络
networks:
  mysql-cluster:
    driver: bridge

```

#### 启动实例
```shell
# 启动所有实例（3个）
docker compose --env-file .env up -d

# 验证运行状态
docker compose ps
```


## 题外话: 为什么我在window navicat 连接不到虚拟机的 mysql？

> virtualbox 这种方式需要做端口转发，才能让 Windows 上的 Navicat 连接到虚拟机内的 MySQL 服务。

### 为什么虚拟机需要端口转发？

端口转发是解决网络隔离和端口冲突的关键技术，具体原因如下：

1. 解决容器端口冲突问题

> MySQL 容器默认端口均为 3306：
> 如果直接在虚拟机（Linux）中运行多个 MySQL 容器，它们的 3306 端口会冲突，无法同时对外暴露。
> 通过映射不同宿主机端口区分容器：
> 将每个容器的 3306 映射到宿主机的不同端口（如 12001-12005），实现多容器共存且独立访问。

2. 突破虚拟机的网络隔离

> 虚拟机默认使用 NAT 网络模式：
> 虚拟机的网络与宿主机（Windows）是隔离的，外部（Windows）无法直接访问虚拟机的内部服务（如 Linux 的 12001 端口）。
> 端口转发打通内外网络：
> 通过将虚拟机的 12001-12005 端口映射到宿主机的相同端口，使得 Windows 上的 Navicat 可以通过 localhost:12001 直接访问虚拟机内的服务。

3. 分层映射的完整链路
   你的场景需要 两次端口转发 才能实现端到端通信：

容器 → 虚拟机（Linux）：
每个容器 3306 映射到 Linux 的 12001-12005 端口（通过 docker run -p 12001:3306 实现）。
虚拟机 → 宿主机（Windows）：
虚拟机的 12001-12005 端口再映射到 Windows 的相同端口（通过图片中的虚拟机端口转发规则配置）。
最终链路：
Navicat (Windows) → localhost:12001 → 虚拟机:12001 → 容器:3306

端口转发规则解读
规则名称 协议 主机端口 子系统端口 作用
Rule1 TCP 5022 22 SSH 访问虚拟机（非 MySQL 相关）
Rule2-6 TCP 12001-5 12001-5 将 Linux 的 MySQL 映射端口传递到 Windows

### 如果不做端口转发会怎样？

容器间端口冲突：多个 MySQL 容器无法同时运行。
外部无法访问服务：Navicat 无法通过 Windows 直接连接虚拟机内的 MySQL。
网络隔离失效：虚拟机内的服务完全封闭，无法对外提供服务。

