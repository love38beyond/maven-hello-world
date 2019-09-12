#!/bin/bash

# Program:
#     deploy hello
# Version:
#     1.0
# History:
#     Created on 2019/09/11
#     Last modified on 2019/09/11

# 容器名称
CONTAINER="jenkins_hello"
# 镜像名称（以日期时间为镜像标签，防止重复）
IMAGE=$CONTAINER":"$(date -d "today" +"%Y%m%d_%H%M%S")

# 删除滚动更新残留的容器
docker stop `docker ps -a | grep -w $CONTAINER"_"$CONTAINER | awk '{print $1}'`
docker rm `docker ps -a | grep -w $CONTAINER"_"$CONTAINER | awk '{print $1}'`
# 强制删除滚动更新残留的镜像
docker rmi --force `docker images | grep -w $CONTAINER | awk '{print $3}'`

#mvn编译打包war包
#删除可能已经启动的容器名为mymaven的容器
if docker ps -a | grep -i mymaven;then
	docker rm -f mymaven
fi

#启动maven容器，命名为mymaven，设置宿主机和容器的挂载点，mvn package给工程打包，-w设置工作目录
#docker run --name mymaven -v /root/data/jenkins/workspace/jenkins_demo/hello-world:/usr/src/jenkins_demo/hello-world -w /usr/src/jenkins_demo/hello-world maven mvn package

#新建dummy文件
touch ./dummy

#创建新镜像
docker build -t $IMAGE . && \

# 删除 docker-compose.hello.yml 文件，防止使用相同镜像
rm -rf docker-compose.hello.yml && \

# 复制 docker-compose.src.yml 文件，防止污染原文件
cp docker-compose.src.yml docker-compose.hello.yml && \

# 替换镜像名标志位为最新镜像
sed -i s%IMAGE_LATEST%$IMAGE%g docker-compose.hello.yml && \

# 使用 docker stack 启动服务
docker stack deploy -c docker-compose.hello.yml $CONTAINER

#删除可能启动的hello容器
#if docker ps -a | grep -i hello;then
#	docker rm -f hello
#fi

#启动tomcat容器，命令为hello
#docker run -d -p 8090:8080 --name hello wxp/hello-world
