![mysql.jpg](../../../../assets/mysql.jpg)
# Mysql
## 简介

Mysql 集群是一个分布式数据库系统，它可以将多个 Mysql 实例组合在一起，形成一个高可用、高性能的数据库集群。
Mysql 集群可以自动处理故障转移、负载均衡和数据复制等任务，从而提高系统的可靠性和性能。
>本文档采用 Docker 部署 Mysql 集群，
方便用户快速搭建 Mysql 集群环境。

## 环境版本
- Mysql 8.0.23
- Docker 24.0.7
- Docker Compose 2.27.1

## 镜像下载
```bash
docker pull mysql:8.0.23
```

