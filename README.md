# NGINX with LibreSSL

[**NGINX built with LibreSSL**](https://github.com/nginx-modules/docker-nginx-libressl)

---

[![Pulls](https://img.shields.io/docker/pulls/denji/nginx-libressl.svg)](https://hub.docker.com/r/denji/nginx-libressl/) 
[![Stars](https://img.shields.io/docker/stars/denji/nginx-libressl.svg)](https://hub.docker.com/r/denji/nginx-libressl/)

[![Docker Image CI](https://github.com/nginx-modules/docker-nginx-libressl/actions/workflows/docker-image.yml/badge.svg)](https://github.com/nginx-modules/docker-nginx-libressl/actions/workflows/docker-image.yml)

## Docker Image

Images are published to both registries:
- `docker.io/denji/nginx-libressl`
- `ghcr.io/nginx-modules/nginx-libressl`

---

## Supported tags and architectures (compact)

| Tag pattern | Architectures |
|-------------|---------------|
| `stable-alpine`, `mainline-alpine` | x86_64, ARMv6/7 (32-bit), AArch64 (ARMv8), RISC-V64, LoongArch64, PPC64LE |
| `stable-aarch64-alpine`, `mainline-aarch64-alpine` | AArch64 (ARMv8) |
| `stable-armv6-alpine`, `mainline-armv6-alpine` | ARMv6 (32-bit) |
| `stable-armv7-alpine`, `mainline-armv7-alpine` | ARMv7 (32-bit) |
| `stable-riscv64-alpine`, `mainline-riscv64-alpine` | RISC-V 64 |
| `stable-loong64-alpine`, `mainline-loong64-alpine` | LoongArch 64-bit |
| `stable-ppc64le-alpine`, `mainline-ppc64le-alpine` | PPC64LE (64-bit PowerPC little-endian) |

---

## Features

- Based on **Alpine Linux**.
- **PCRE** with JIT enabled.
- **HTTP/2** (+NPN) support.
- **Async I/O** using threads supported.
- **Dynamic TLS record patch** for Cloudflare (enabled).
- **Gzip static `.gz` files** support enabled.
- **Brotli static `.br` files** support enabled.
  - On-the-fly Brotli compression is **disabled** (unstable).
- Based on **Official NGINX Dockerfile** and [`Wonderfall/boring-nginx`](https://github.com/Wonderfall/boring-nginx).

---
