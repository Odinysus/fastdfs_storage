FROM johndric/fastdfs_base
MAINTAINER <caidongqiang@hotmail.com>

ENV TRACKER_SERVER="172.17.0.2"

# install nginx
## install dependen tool
RUN yum -y install pcre-devel openssl openssl-devel wget && yum clean all

## download nginx
RUN cd /tmp && \
    wget http://nginx.org/download/nginx-1.10.3.tar.gz && \ 
    tar zxvf nginx-1.10.3.tar.gz && \
    git clone https://github.com/happyfish100/fastdfs-nginx-module.git 

## install
RUN cd /tmp/nginx-1.10.3 && ./configure --with-http_stub_status_module --with-http_ssl_module \
     --with-http_realip_module --add-module=../fastdfs-nginx-module/src && \
    make && \ 
    make install && \ 
    rm -rf /tmp/*

# volume storage data
VOLUME /mnt/storage
    

COPY nginx.conf /usr/local/nginx/conf/
COPY http.conf mime.types mod_fastdfs.conf storage.conf /etc/fdfs/

EXPOSE 80 23000 

ADD start.sh /usr/bin/
RUN chmod 777 /usr/bin/start.sh

ENTRYPOINT /usr/bin/start.sh $TRACKER_SERVER

