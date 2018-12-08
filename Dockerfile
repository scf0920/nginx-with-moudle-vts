FROM nginx:1.14.2

ENV NGINX_VERSION     "1.14.2"
ENV NGINX_VTS_VERSION "0.1.18"

RUN apt-get update && \
    apt-get install -y git wget libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential zlib1g-dev && \
    cd /tmp/ && \
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    git clone git://github.com/vozlt/nginx-module-vts.git && \
    tar zxvf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    sed -i -r -e "s/\.\/configure(.*)/.\/configure\1 --add-module=\/tmp\/nginx-module-vts-${NGINX_VTS_VERSION}/" /tmp/nginx-${NGINX_VERSION}/debian/rules && \
    make && make install && \
    cp -f objs/nginx /usr/sbin/nginx && \
    apt-get remove --purge -y git wget && apt-get -y --purge autoremove && rm -rf /var/lib/apt/lists/*

CMD ["nginx", "-g", "daemon off;"]