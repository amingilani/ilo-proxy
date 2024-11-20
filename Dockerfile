FROM nginx:latest

# Create directory for certificates
RUN mkdir -p /etc/nginx/ssl

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy OpenSSL configuration
COPY openssl.cnf /etc/ssl/openssl.cnf

# Generate self-signed certificate for testing
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/proxy.key \
    -out /etc/nginx/ssl/proxy.crt \
    -subj "/CN=proxy"

# Script to replace IP in config
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
