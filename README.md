# [sgtsquiggs/caddy-auth-portal](https://hub.docker.com/repository/docker/sgtsquiggs/caddy-auth-portal)

For configuration please see:
- [caddy-auth-portal](https://github.com/greenpau/caddy-auth-portal)
- [caddy-auth-jwt](https://github.com/greenpau/caddy-auth-jwt)

## Example:

###  docker-compose.yml
```yaml
version: "2.4"

services:
  portal:
    image: sgtsquiggs/caddy-auth-portal
    volumes:
      - /path/to/configs/portal/Caddyfile:/etc/caddy/Caddyfile:ro
      - /path/to/data/portal/users.json:/etc/caddy/auth/local/users.json
    ports:
      - 80:80
      - 443:443
    depends_on:
      - prometheus
  prometheus:
    image: prom/prometheus
    volumes:
      - /path/to/configs/prometheus:/etc/prometheus
      - /path/to/data/prometheus:/prometheus
    command: --web.enable-lifecycle  --config.file=/etc/prometheus/prometheus.yml
```

### Caddyfile
```
mydomain.tld {
  route /auth* {
    auth_portal {
      path /auth
      cookie_domain mux.dyn.squig.gs
      backends {
        local_backend {
          method local
          path /etc/caddy/auth/local/users.json
          realm local
        }
      }
      jwt {
        token_name access_token
        token_secret 0e2fdcf8-6868-41a7-884b-7308795fc286
        token_issuer e1008f2d-ccfa-4e62-bbe6-c202ec2988cc
      }
      ui {
        links {
          "Prometheus" /prometheus
        }
      }
    }
  }

  route /prometheus* {
    jwt {
      primary yes
      trusted_tokens {
        static_secret {
          token_name access_token
          token_secret 0e2fdcf8-6868-41a7-884b-7308795fc286
          token_issuer e1008f2d-ccfa-4e62-bbe6-c202ec2988cc
        }
      }
      auth_url /auth
      allow roles anonymous guest admin
      allow roles superadmin
    }
    reverse_proxy http://prometheus:9000
  }

  route {
    redir https://{hostport}/auth 302
  }
}
```
