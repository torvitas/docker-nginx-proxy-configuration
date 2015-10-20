#!/bin/bash
set -e

# Warn if the DOCKER_HOST socket does not exist
if [[ $DOCKER_HOST == unix://* ]]; then
	socket_file=${DOCKER_HOST#unix://}
	if ! [ -S $socket_file ]; then
		cat >&2 <<-EOT
			ERROR: you need to share your Docker host socket with a volume at $socket_file
			Typically you should run your jwilder/nginx-proxy with: \`-v /var/run/docker.sock:$socket_file:ro\`
			See the documentation at http://git.io/vZaGJ
		EOT
		socketMissing=1
	fi
fi

# If the user has run the default command and the socket doesn't exist, fail
if [ "$socketMissing" = 1 -a "$1" = forego -a "$2" = start -a "$3" = '-r' ]; then
	exit 1
fi

if [[ ! -d /etc/nginx/certs/localhost.crt ]]; then
    DIR=$(pwd)
    cd /etc/nginx/certs/
    openssl req \
        -new \
        -newkey rsa:4096 \
        -days 36500 \
        -nodes \
        -x509 \
        -subj "/C=DE/ST=Baden-Württemberg/L=Reutlingen/O=Dis/CN=localhost" \
        -keyout localhost.key \
        -out localhost.crt
    cp localhost.crt default.crt
    cp localhost.key default.key
    cd ${DIR}
fi

exec "$@"
