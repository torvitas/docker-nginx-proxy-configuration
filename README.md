# docker nginx reverse proxy configuration

In addition to providing configuration to jwilder/nginx-proxy, we also create a certificate for *.dev.localhost.

## Quickstart
```
mkdir nginx-proxy; cd nginx-proxy
git clone https://github.com/torvitas/docker-nginx-proxy-configuration.git ./
make init up log
```
