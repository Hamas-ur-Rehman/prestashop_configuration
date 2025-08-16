# PrestaShop with SSL via Nginx Proxy Setup

## Overview
This setup provides a secure PrestaShop installation with:
- SSL/TLS encryption via Let's Encrypt
- Nginx reverse proxy for better performance
- Automatic SSL certificate renewal
- Security headers and optimizations

## Prerequisites
1. A domain name pointing to your server's IP address
2. Ports 80 and 443 open on your server
3. Docker and Docker Compose installed

## Setup Instructions

### 1. Update Domain Configuration
Before starting, you need to replace the placeholder values in `docker-compose.yml`:

- Replace `your-domain.com` with your actual domain name
- Replace `your-email@domain.com` with your actual email address

### 2. Required Changes in docker-compose.yml
Update these environment variables:
```yaml
# In nginx-proxy service
DEFAULT_HOST=your-actual-domain.com

# In letsencrypt service  
DEFAULT_EMAIL=your-actual-email@domain.com

# In prestashop service
PS_DOMAIN=your-actual-domain.com
VIRTUAL_HOST=your-actual-domain.com
LETSENCRYPT_HOST=your-actual-domain.com
LETSENCRYPT_EMAIL=your-actual-email@domain.com
```

### 3. Start the Services
```bash
docker-compose up -d
```

### 4. Monitor SSL Certificate Generation
```bash
# Check nginx-proxy logs
docker logs nginx-proxy -f

# Check Let's Encrypt logs
docker logs letsencrypt -f
```

### 5. Access Your Site
- HTTP: http://your-domain.com (will redirect to HTTPS)
- HTTPS: https://your-domain.com

## Services Included

### nginx-proxy
- Handles SSL termination
- Automatic service discovery
- Load balancing and caching
- Security headers

### letsencrypt (acme-companion)
- Automatic SSL certificate generation
- Certificate renewal (every 60 days)
- Multiple domain support

### prestashop
- No longer directly exposed to internet
- Communicates through nginx proxy
- Enhanced security configuration

## Security Features
- TLS 1.2 and 1.3 support
- Strong cipher suites
- HSTS headers
- XSS protection
- Content type sniffing protection
- Frame options protection
- File upload size limits
- Static file caching

## Troubleshooting

### SSL Certificate Issues
1. Ensure your domain points to the server
2. Check that ports 80 and 443 are accessible
3. Verify email address is valid
4. Check Let's Encrypt rate limits

### PrestaShop Access Issues
1. Wait for SSL certificate generation (can take 5-10 minutes)
2. Clear browser cache
3. Check container logs: `docker logs prestashop`

### Performance Optimization
The nginx configuration includes:
- Gzip compression
- Static file caching
- Optimized SSL settings
- Security headers

## Maintenance
- SSL certificates auto-renew every 60 days
- Monitor logs regularly
- Keep Docker images updated
- Backup volumes regularly

## Volumes
- `prestashop_data`: PrestaShop files and uploads
- `nginx_certs`: SSL certificates
- `nginx_vhost`: Virtual host configurations
- `nginx_html`: Web root for challenges
- `acme_data`: ACME client data
