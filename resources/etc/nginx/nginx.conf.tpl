user  nginx nginx;
worker_processes  2;

error_log  /var/log/nginx/error.log {{ .Env.Get "LOG_LEVEL" }};
pid        /var/run/nginx.pid;

events {
  worker_connections  2048;
}

http {
  ##
  # Basic Settings
  ##
  sendfile on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  client_max_body_size 0;
	# server_tokens off;
  default_type  application/octet-stream;

  # logging
  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log  /var/log/nginx/access.log  main;

	##
	# Gzip Settings
	##

	gzip on;
	gzip_disable "msie6";

	gzip_vary on;
	gzip_types text/plain text/css application/javascript;

	server {
        listen 8080;
        location /swaggerui {
          absolute_redirect off;
          alias /var/www/html;
          expires 1d;
          include mime.types;
        }
    }

}
