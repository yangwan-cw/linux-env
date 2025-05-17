#!/bin/bash

# 查询系统版本
echo "=== 系统版本信息 ==="
echo "操作系统: $(uname -o)"
cat /etc/centos-release

# 查询磁盘信息
echo "=== 磁盘信息 ==="
df -h /

# 查询当前运行内存
echo -e "\n=== 当前运行内存 ==="
free -h

# 查询防火墙状态
echo -e "\n=== 防火墙状态 ==="
systemctl status firewalld


# 查询 SELinux 状态
echo -e "\n=== SELinux 状态 ==="
sestatus


# 查询网络信息
echo -e "\n=== 网络信息 ==="
ip addr

# 查询已安装的软件包
echo -e "\n=== 已安装的软件包 ==="
yum list installed | less