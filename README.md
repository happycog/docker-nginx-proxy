nginx Proxy
----

This container must be run with access to the host Docker instance. However you wish to do that is fine, but the easiest (and maybe most insecure) is to just pass the socket into the container with soemthing like,

```
docker run -d -v /var/run:/host/var/run -e DOCKER_HOST=unix:///host/var/run/docker.sock -p "7999:80" --dns 127.0.0.1 proxy
```

You also must override Docker's default control over the DNS services and specific the internal `dnsmasq` be used with the `--dns` flag.
