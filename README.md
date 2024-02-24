# **NGINX** built with **LibreSSL**

### Docker image

[![](https://img.shields.io/docker/automated/denji/nginx-libressl.svg)](https://hub.docker.com/r/denji/nginx-libressl/builds/) [![](https://img.shields.io/docker/pulls/denji/nginx-libressl.svg)](https://hub.docker.com/r/denji/nginx-libressl/) [![](https://img.shields.io/docker/stars/denji/nginx-libressl.svg)](https://hub.docker.com/r/denji/nginx-libressl/)

[![Docker Image CI](https://github.com/nginx-modules/docker-nginx-libressl/actions/workflows/docker-image.yml/badge.svg)](https://github.com/nginx-modules/docker-nginx-libressl/actions/workflows/docker-image.yml)

### Supported tags and respective `Dockerfile` links

* Stable Release
  - `docker.io/denji/nginx-libressl:stable-alpine` - (Linux x86_64-v4)
  - `docker.io/denji/nginx-libressl:stable-aarch64-alpine` - (Linux AArch64 - ARMv8)
  - `docker.io/denji/nginx-libressl:stable-armv7-alpine` - (Linux ARMv7 - 32-bit)
  - `docker.io/denji/nginx-libressl:stable-ppc64le-alpine` - (Linux ppc64le - 64-bit PowerPC little-endian)

* Mainline Release
  - `docker.io/denji/nginx-libressl:mainline-alpine` - (Linux x86_64-v4)
  - `docker.io/denji/nginx-libressl:mainline-aarch64-alpine` - (Linux AArch64 - ARMv8)
  - `docker.io/denji/nginx-libressl:mainline-armv7-alpine` - (Linux ARMv7 - 32-bit)
  - `docker.io/denji/nginx-libressl:mainline-ppc64le-alpine` - (Linux ppc64le - 64-bit PowerPC little-endian)

#### Features

- Images are used Alpine Linux.
- PCRE with JIT enabled.
- HTTP/2.0 (+NPN) support.
- Async I/O using threads support.
- Dynamic TLS records patch CloudFlare support (and configured).
- Gzip static `.gz` files support enabled
- Brotli static `.br` files support (and configured).
  - Brotli on-the-fly disabled (dynamic compression unstable)

#### Based on the Official NGINX Dockerfile & `Wonderfall/boring-nginx`
