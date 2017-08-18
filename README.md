#  **[nginx][3]** built with **[LibreSSL][4]**

## Features

- Uses [Alpine Linux][5] as base
- PCRE with JIT enabled
- HTTP/2.0 (+NPN) support
- Async I/O using threads support
- Dynamic TLS records patch support (and configured) - From [Cloudflare][6]
- [Brotli][7] compression support (and configured)

Currently the HPACK patch from Cloudflare is not used because it does not apply clean against mainline.

Originally based on the official nginx Dockerfile & `Wonderfall/boring-nginx` - Forked from [denji/nginx-libressl][1] - This version uses [tini][2], a tiny but valid `init` for containers

[1]: https://github.com/nginx-modules/docker-nginx-libressl/
[2]: https://github.com/krallin/tini/
[3]: http://nginx.org/
[4]: https://libressl.org/
[5]: https://alpinelinux.org/
[6]: https://blog.cloudflare.com/optimizing-tls-over-tcp-to-reduce-latency/
[7]: https://en.wikipedia.org/wiki/Brotli
