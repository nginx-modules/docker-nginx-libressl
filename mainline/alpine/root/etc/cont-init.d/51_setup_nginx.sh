#!/usr/bin/with-contenv bash
set -x

# Set worker_processes
: ${WORKER_PROCESSES:="auto"}

grep -q "@@WORKER_PROCESSES@@" /etc/nginx/nginx.conf

if [[ $? -eq 0 ]]
 then
	sed -i "s|@@WORKER_PROCESSES@@|$WORKER_PROCESSES|" /etc/nginx/nginx.conf
fi

# chown'ning the entire /var/www may not be desireable

: ${CHOWN_WWWDIR:="TRUE"}

[ -w /var/www ] || CHOWN_WWWDIR="FALSE"

if [[ $CHOWN_WWWDIR == "TRUE" ]]
 then
	chown -R app:app /var/www
fi

# Make sure the app user is able to write to nginx directories
chown -R app:app /var/log/nginx /var/cache/nginx 
