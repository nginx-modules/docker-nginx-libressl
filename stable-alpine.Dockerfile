FROM alpine:latest

ENV NGINX_VERSION=1.24.0
ENV LIBRESSL_VERSION=3.8.2

RUN GPG_KEYS=13C82A63B603576156E30A4EA0EA981B66B0D967 \
	&& CONFIG="\
		--prefix=/etc/nginx \
		--sbin-path=/usr/sbin/nginx \
		--modules-path=/usr/lib/nginx/modules \
		--conf-path=/etc/nginx/nginx.conf \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
		--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
		--user=nginx \
		--group=nginx \
		--with-http_ssl_module \
		--with-http_realip_module \
		--with-http_addition_module \
		--with-http_sub_module \
		--with-http_dav_module \
		--with-http_flv_module \
		--with-http_mp4_module \
		--with-http_gunzip_module \
		--with-http_gzip_static_module \
		--with-http_random_index_module \
		--with-http_secure_link_module \
		--with-http_stub_status_module \
		--with-http_auth_request_module \
		--with-http_xslt_module=dynamic \
		--with-http_image_filter_module=dynamic \
		--with-http_geoip_module=dynamic \
		--with-http_perl_module=dynamic \
		--with-threads \
		--with-stream \
		--with-stream_ssl_module \
		--with-stream_ssl_preread_module \
		--with-stream_realip_module \
		--with-stream_geoip_module=dynamic \
		--with-http_slice_module \
		--with-mail \
		--with-mail_ssl_module \
		--with-compat \
		--with-file-aio \
		--with-http_v2_module \
		--with-ipv6 \
		--with-openssl=/usr/src/libressl-$LIBRESSL_VERSION \
		--add-dynamic-module=/usr/src/ngx_headers_more \
		--add-dynamic-module=/usr/src/ngx_brotli \
	" \
	&& addgroup -S nginx \
	&& adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
	&& apk add --no-cache --virtual .build-deps \
		autoconf \
		automake \
		bind-tools \
		binutils \
		build-base \
		ca-certificates \
		cmake \
		curl \
		gcc \
		gd-dev \
		geoip-dev \
		git \
		gnupg \
		gnupg \
		go \
		libc-dev \
		libgcc \
		libstdc++ \
		libtool \
		libxslt-dev \
		linux-headers \
		make \
		pcre \
		pcre-dev \
		perl-dev \
		su-exec \
		tar \
		tzdata \
		zlib \
		zlib-dev \
	\
	&& curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx-$NGINX_VERSION.tar.gz \
	&& curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc  -o nginx-$NGINX_VERSION.tar.gz.asc \
	&& curl -fSL https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$LIBRESSL_VERSION.tar.gz -o libressl-$LIBRESSL_VERSION.tar.gz \
	&& curl -fSL https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$LIBRESSL_VERSION.tar.gz.asc -o libressl-$LIBRESSL_VERSION.tar.gz.asc \
	&& curl -fSL https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl.asc -o libressl.asc \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& found=''; \
	for server in \
		ha.pool.sks-keyservers.net \
		hkp://keyserver.ubuntu.com:80 \
		hkp://p80.pool.sks-keyservers.net:80 \
		pgp.mit.edu \
	; do \
		echo "Fetching GPG key $GPG_KEYS from $server"; \
		gpg --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$GPG_KEYS" && found=yes && break; \
	done; \
	test -z "$found" && echo >&2 "error: failed to fetch GPG key $GPG_KEYS" && exit 1; \
	gpg --batch --verify nginx-$NGINX_VERSION.tar.gz.asc nginx-$NGINX_VERSION.tar.gz \
	&& gpg --import libressl.asc \
	&& gpg --batch --verify libressl-$LIBRESSL_VERSION.tar.gz.asc libressl-$LIBRESSL_VERSION.tar.gz \
	&& rm -rf "$GNUPGHOME" libressl.asc "libressl-$LIBRESSL_VERSION.tar.gz.asc" \
	&& mkdir -p /usr/src \
	&& tar -zxC /usr/src -f nginx-$NGINX_VERSION.tar.gz \
	&& rm nginx-$NGINX_VERSION.tar.gz \
	&& git clone --depth=1 --recurse-submodules https://github.com/google/ngx_brotli /usr/src/ngx_brotli \
	&& git clone --depth=1 https://github.com/openresty/headers-more-nginx-module /usr/src/ngx_headers_more \
	&& tar -zxC /usr/src -f libressl-$LIBRESSL_VERSION.tar.gz \
	&& cd /usr/src/nginx-$NGINX_VERSION \
	&& curl -fSL https://raw.githubusercontent.com/nginx-modules/ngx_http_tls_dyn_size/0.5/nginx__dynamic_tls_records_1.17.7%2B.patch -o dynamic_tls_records.patch \
	&& patch -p1 < dynamic_tls_records.patch \
	&& ./configure $CONFIG --with-debug \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& mv objs/nginx objs/nginx-debug \
	&& mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so \
	&& mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so \
	&& mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so \
	&& mv objs/ngx_http_perl_module.so objs/ngx_http_perl_module-debug.so \
	&& mv objs/ngx_stream_geoip_module.so objs/ngx_stream_geoip_module-debug.so \
	&& ./configure $CONFIG \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& make install \
	&& rm -rf /etc/nginx/html/ \
	&& mkdir /etc/nginx/conf.d/ \
	&& mkdir -p /usr/share/nginx/html/ \
	&& install -m644 html/index.html /usr/share/nginx/html/ \
	&& install -m644 html/50x.html /usr/share/nginx/html/ \
	&& install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
	&& install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so \
	&& install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so \
	&& install -m755 objs/ngx_http_geoip_module-debug.so /usr/lib/nginx/modules/ngx_http_geoip_module-debug.so \
	&& install -m755 objs/ngx_http_perl_module-debug.so /usr/lib/nginx/modules/ngx_http_perl_module-debug.so \
	&& install -m755 objs/ngx_stream_geoip_module-debug.so /usr/lib/nginx/modules/ngx_stream_geoip_module-debug.so \
	&& ln -s ../../usr/lib/nginx/modules /etc/nginx/modules \
	&& strip /usr/sbin/nginx* \
	&& strip /usr/lib/nginx/modules/*.so \
	&& rm -rf /usr/src/nginx-$NGINX_VERSION \
	&& rm -rf /usr/src/libressl* /usr/src/ngx_* \
	\
	# Bring in gettext so we can get `envsubst`, then throw
	# the rest away. To do this, we need to install `gettext`
	# then move `envsubst` out of the way so `gettext` can
	# be deleted completely, then move `envsubst` back.
	&& apk add --no-cache --virtual .gettext gettext \
	&& mv /usr/bin/envsubst /tmp/ \
	\
	&& runDeps="$( \
		scanelf --needed --nobanner /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	) tzdata ca-certificates" \
	&& apk add --no-cache --virtual .nginx-rundeps $runDeps \
	&& apk del .build-deps \
	&& apk del .gettext \
	&& mv /tmp/envsubst /usr/local/bin/ \
	\
	# forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY conf/stable/nginx.conf /etc/nginx/nginx.conf
COPY conf/stable/nginx.vh.no-default.conf /etc/nginx/conf.d/default.conf

RUN APK_ARCH="$(cat /etc/apk/arch)"

LABEL description="NGINX Docker built top of LibreSSL" \
      maintainer="Denis Denisov <denji0k@gmail.com>" \
      openssl="LibreSSL $LIBRESSL_VERSION" \
      nginx="nginx $NGINX_VERSION" \
      arch="$APK_ARCH"

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
