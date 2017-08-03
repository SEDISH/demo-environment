# demo-environment
Docker Compose configuration that will be used on the demo server.

In order to have the local version working:

1. Copy the local env configuration to the directory you launch the environment from: 

```bash
	cp conf/.env-local .env
```

2. Generate self signed certificates, using a script we provide:
```bash
	./scripts/generate-cert.sh
```
