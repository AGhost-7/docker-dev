#!/usr/bin/env bash

#sleep 1

if [ ! -z "$PGWEB_URL" ]; then
	exec pgweb --url "$PGWEB_URL"
fi

if [ -z "$PGWEB_USER" ]; then
	PGWEB_USER=postgres
fi

if [ -z "$PGWEB_DATABASE" ]; then
	PGWEB_DATABASE=template1
fi

pgweb \
	--bind 0.0.0.0 \
	--user "$PGWEB_USER" \
	--db "$PGWEB_DATABASE" \
	--ssl disable
