#!/bin/bash

# 查询连接的 IP 数量
# 统计连接的 IP 数量
# 统计连接的 IP 数量
netstat -atn | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | awk '{print $2}' | head -n 10