# Docker / Container Project Rules

> Auto-loaded when working in containerized project directories.

## Python Environment

- Inside containers, use `python3` and `pip3` explicitly — never bare `python` or `pip`.
- Always pin dependency versions in `requirements.txt`. No floating versions.
- If a package install fails, check whether build tools (`gcc`, `make`, `libffi-dev`) are in the Dockerfile.

## Dependency Persistence

- Never install packages at runtime that should be in the Dockerfile.
- For development dependencies, use a separate `requirements-dev.txt`.
- Mount volumes for data directories — do not store state inside the container filesystem.
- Use multi-stage builds to keep final images small.

## Networking

- Use Docker Compose service names for inter-container communication, not `localhost`.
- Expose ports explicitly in `docker-compose.yml` — do not rely on `--network=host`.
- For services that need to talk to the host machine, use `host.docker.internal`.

## Debugging

- Always check `docker logs <container>` before assuming a service is down.
- If a container exits immediately, check the entrypoint script for issues.
- Use `docker exec -it <container> sh` for interactive debugging — prefer `sh` over `bash` (Alpine images don't have bash).

## File Paths

- Use forward slashes in all path references, even in Windows-host docker-compose files.
- Bind mount paths must be absolute. Use `${PWD}` or `.` notation in compose files.
- Watch out for line ending issues (CRLF vs LF) — add `.gitattributes` with `* text=auto eol=lf`.

## Security

- Never run containers as root in production. Add `USER nonroot` to Dockerfile.
- Do not hardcode secrets in Dockerfiles or compose files — use `.env` files or Docker secrets.
- The `.env` file must be in `.gitignore`.
