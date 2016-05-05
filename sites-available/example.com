# www to non-www redirect -- duplicate content is BAD.
# Choose between www and non-www, listen on the *wrong* one and redirect to
# the right one -- http://wiki.nginx.org/Pitfalls#Server_Name

server {
  # listen 80 default_server;
  # If IPv6 is supported.
  # listen [::]:80 default_server ipv6only=on;
  listen 80;
  # If IPv6 is supported.
  # listen [::]:80 ipv6only=on;

  # listen on the www host.
  server_name example.com;

  # and redirect to the non-www host (declared below).
  return 301 $scheme://example.com$request_uri;
}

server {
  # listen 80 default_server;
  # If IPv6 is supported.
  # listen [::]:80 default_server ipv6only=on;
  listen 80;
  # If IPv6 is supported.
  # listen [::]:80 ipv6only=on;

  # The host name to respond to.
  server_name example.com;

  # Specify a charset.
  charset utf-8;

  location / {
    # Path for static files.
    root /var/www/example.com/current;

    index index.html;
  }

  # Custom 404 page.
  error_page 404 /404.html;
}