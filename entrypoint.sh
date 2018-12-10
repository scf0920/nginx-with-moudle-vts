#!/bin/bash
chown -R nginx:nginx /data/cache

exec "$@"