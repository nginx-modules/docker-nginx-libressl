#  **[nginx][3]** built with **[LibreSSL][4]**

## Features

- Uses [Alpine Linux][5] as base
- PCRE with JIT enabled
- HTTP/2.0 (+NPN) support
- Async I/O using threads support
- Dynamic TLS records patch support (and configured) - From [Cloudflare][6]
- [Brotli][7] compression support (and configured)

Currently the HPACK patch from Cloudflare is not used because it does not apply cleanly against mainline.

## Usage

```docker run --rm --name nginx -v ./htdocs:/var/www -p 80:80 -p 443:443 -d ajoergensen/nginx-libressl:tag```

Available tags are `stable` and `mainline`

## Environment

- **PUID**: Change the uid of the user running nginx
- **PGID**: Change the gid of the user running nginx
- **CHOWN_WWWDIR**: Enable/disable the change of ownership of /var/www to $PUID:$PGID, defaults to TRUE. Note, if /var/www read only this variable will always be FALSE
- **WORKER_PROCESSES**: Change the value of nginx worker_processes, defaults to auto.

## Other

Though not defined as a volume, I recommend mapping a folder to /etc/nginx/conf.d to store your vhost definitions.

This image works great with [docker-gen][8] and [docker-letsencrypt-nginx-proxy-companion][9] (as a drop-in replacement for the nginx-proxy image)

----

Originally based on the official nginx Dockerfile & `Wonderfall/boring-nginx` - Forked from [denji/nginx-libressl][1]

[1]: https://github.com/nginx-modules/docker-nginx-libressl/
[3]: http://nginx.org/
[4]: https://libressl.org/
[5]: https://alpinelinux.org/
[6]: https://blog.cloudflare.com/optimizing-tls-over-tcp-to-reduce-latency/
[7]: https://en.wikipedia.org/wiki/Brotli
[8]: https://github.com/jwilder/nginx-proxy
[9]: https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion
