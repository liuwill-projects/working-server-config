#!/bin/bash

usage()
{
  echo "USAGE: $CALLER [-h] COMMANDS"
  echo "       $CALLER [ --help ]"
  echo "COMMANDS:"
  echo "    start    开启docker容器" 
  echo "    stop     关闭docker容器"
  echo "    status   查看容器状态"
  echo "    reload   重新加载nginx配置"
  echo "    remove   删除docker容器"
  echo "    install  安装nginx容器，仅需要执行一次"
  echo "    enter    进入docker容器"
  echo "Run '$CALLER COMMAND --help' for more information on a command."
  exit 1
}

if [ $# -ne 1 ] ; then
    usage
fi

if [ "$1" = "install" ]; then
    docker run -itd \
        --name server-nginx \
        --net=server \
        -v /usr/app/nginx:/usr/src/app \
        -v /usr/app/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
        -v /usr/app/nginx/conf/conf.d:/etc/nginx/conf.d \
        -v /usr/app/static:/usr/share/nginx/html:ro \
        -v /var/log/nginx:/var/log/nginx \
        --hostname web-server \
        -p 80:80 \
	nginx:1.13-alpine
elif [ "$1" = "start" ]; then
    docker start server-nginx
elif [ "$1" = "stop" ]; then
    docker stop server-nginx
elif [ "$1" = "status" ]; then
    docker inspect server-nginx
elif [ "$1" = "reload" ]; then
    docker exec server-nginx nginx -s reload
elif [ "$1" = "remove" ]; then
    docker rm server-nginx
elif [ "$1" = "enter" ]; then
    docker exec -it server-nginx /bin/sh
fi

