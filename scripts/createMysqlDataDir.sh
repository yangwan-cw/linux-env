#!/bin/bash


base_dir="/opt/mysql"
instance_prefix="mysql_cluster_instance"

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

# 查询是否存在 opt 目录
if [ ! -d "/opt" ]; then
    echo "=== 创建 /opt 目录 ==="
    mkdir -p /opt
else
  echo "=== /opt 目录已存在 ==="
fi

# 查询是否存在 mysql 目录
if [ ! -d "/opt/mysql" ]; then
    echo "=== 创建 /opt/mysql 目录 ==="
    echo "mysql 目录" ${base_dir}
    mkdir -p ${base_dir}
else
  echo "=== ${base_dir} 目录已存在 ==="
fi

echo "=== 创建 mysql_cluster_instance 目录 ==="
create_instance_dirs(){
   local instance_num=$1
   local instance_dir="${base_dir}/${instance_prefix}${instance_num}"
   echo "=== Creating instance ${instance_num} directories ==="
   mkdir -p "${instance_dir}/config"
   mkdir -p "${instance_dir}/data"
   echo "Created: ${instance_dir}"
   echo "  ├── config"
   echo "  └── data"
}


if [ $# -eq 0 ]; then
  echo "Usage: $0 <number_of_instances>"
  exit 1
fi

# 读取到参数
num_instances=$1

# Create directories for each instance
for (( i=1; i<=${num_instances}; i++ )); do
    create_instance_dirs $i
done
echo "=== Directory creation completed ==="




