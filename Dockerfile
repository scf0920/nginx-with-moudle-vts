FROM nginx:1.15.7

ENV NGINX_VERSION     "1.15.7"
ENV NGINX_VTS_VERSION "0.1.18"

RUN apt-get update && \
    apt-get install -y git wget libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential zlib1g-dev && \
    cd /tmp/ && \
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    git clone git://github.com/vozlt/nginx-module-vts.git && \
    tar zxvf nginx-${NGINX_VERSION}.tar.gz && \
    rm -f nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    ./configure --prefix=/tmp/nginx-${NGINX_VERSION} --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module \
    --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module \
    --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module \
    --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream \
    --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module \
    --with-cc-opt='-g -O2 -fdebug-prefix-map=/data/builder/debuild/nginx-1.15.7/debian/debuild-base/nginx-1.15.7=. -specs=/usr/share/dpkg/no-pie-compile.specs -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
    --with-ld-opt='-specs=/usr/share/dpkg/no-pie-link.specs -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
    --add-module=/tmp/nginx-module-vts && \
    make && make install && \
    cp -f objs/nginx /usr/sbin/nginx && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["nginx", "-g", "daemon off;"]