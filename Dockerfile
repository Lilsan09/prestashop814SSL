FROM prestashop/base:8.1-apache
LABEL maintainer="PrestaShop Core Team <coreteam@prestashop.com>"
ENV PS_VERSION 8.1.4

# Installation d'OpenSSL
RUN apt-get update && apt-get install -y openssl

# Génération de la clé privée et du certificat SSL
RUN openssl genrsa -out /etc/ssl/private/ssl_key.key 2048 \
   && openssl req -new -x509 -key /etc/ssl/private/ssl_key.key -out /etc/ssl/certs/ssl_cert.crt -subj "/CN=dev.boutique-poubeau.fr" -days 365

# Configuration d'Apache pour utiliser SSL
RUN a2enmod ssl 
RUN a2enmod rewrite
RUN sed -i '1s/^/ServerName localhost\n\n/' /etc/apache2/sites-available/000-default.conf
RUN sed -i '/<VirtualHost \*:80>/,/<\/VirtualHost>/c\    <VirtualHost \*:80>\n    <\/VirtualHost>\n\n<VirtualHost *:443>\n    SSLEngine on\n    SSLCertificateFile /etc/ssl/certs/ssl_cert.crt\n    SSLCertificateKeyFile /etc/ssl/private/ssl_key.key\n<\/VirtualHost>' /etc/apache2/sites-available/000-default.conf


RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN echo "good atm"
RUN service apache2 start