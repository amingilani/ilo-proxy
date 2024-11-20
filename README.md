# ILO2 Legacy TLS Proxy

THIS DOES NOT WORK! OPENSSL NEEDS TO BE CONFIGURED TO USE THE OUTDATED CIPHER SUITES.


This project provides a Docker-based reverse proxy solution for accessing HP ILO 2 management interfaces from modern browsers. It addresses the issue where modern browsers block access to ILO 2 due to its outdated TLS 1.0 implementation.

## Problem

HP ILO 2 remote management interfaces use TLS 1.0 with outdated cipher suites, which are no longer supported by modern web browsers for security reasons. This makes it impossible to access these interfaces directly from current browsers.

## Solution

This proxy:
- Terminates modern TLS connections from your browser
- Connects to the ILO 2 interface using TLS 1.0
- Rewrites URLs in the response to maintain proxy connection
- Handles both HTTP and HTTPS protocols
- Runs in a Docker container for easy deployment

## Prerequisites

- Docker installed on your system
- Network access to the ILO 2 interface
- The IP address of your ILO 2 interface

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/amingilani/ilo2-proxy
cd ilo2-proxy
```

2. Build the Docker image:
```bash
docker build -t ilo2-proxy .
```

3. Run the proxy (replace with your ILO 2's IP address):
```bash
docker run -d \
  -p 80:8080 \
  -p 443:4343 \
  -e REMOTE_IP=192.168.1.20 \
  --name ilo2-proxy \
  ilo2-proxy
```

4. Access your ILO 2 interface through the proxy:
- Open your browser
- Navigate to `https://localhost` (or your proxy server's IP address)
- Accept the self-signed certificate warning

## Configuration

### Environment Variables

- `REMOTE_IP`: (Required) The IP address of your ILO 2 interface

### Custom SSL Certificates

To use your own SSL certificates instead of the self-signed ones:

```bash
docker run -d \
  -p 80:8080
  -p 443:4343\
  -e REMOTE_IP=192.168.1.20 \
  -v /path/to/your/cert.crt:/etc/nginx/ssl/proxy.crt \
  -v /path/to/your/key.key:/etc/nginx/ssl/proxy.key \
  --name ilo2-proxy \
  ilo2-proxy
```

## Security Considerations

- This proxy deliberately enables legacy TLS 1.0 support to communicate with ILO 2
- Use only on trusted networks (preferably local network only)
- Consider restricting access to specific IP ranges in your network
- The proxy should be deployed as close to the ILO 2 interface as possible
- All traffic between your browser and the proxy uses modern TLS

## Files

- `Dockerfile`: Builds the Nginx-based proxy container
- `nginx.conf`: Nginx configuration template with TLS and proxy settings
- `entrypoint.sh`: Container startup script that configures the remote IP

## Troubleshooting

1. Certificate Errors
   - By default, the proxy uses a self-signed certificate
   - Accept the certificate warning in your browser or use your own certificates

2. Connection Refused
   - Verify the ILO 2 IP address is correct
   - Ensure network connectivity to the ILO 2 interface
   - Check if ports 80/443 are available on your system

3. Pages Not Loading Correctly
   - Clear your browser cache
   - Try accessing the page in incognito/private mode
   - Verify the ILO 2 interface is responsive

## Limitations

- Java-based remote console features may not work through the proxy
- Some dynamic content might not be properly rewritten
- Session timeouts may occur differently than with direct access

## Contributing

Contributions are welcome! Please feel free to submit pull requests or create issues for bugs and feature requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
