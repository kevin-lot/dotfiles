# macOS: replace OrbStack with Colima + Docker CLI

Docker engine runs in the Colima VM; `docker` is only the CLI. Needed for LocalStack with Testcontainers (Java, Rust, Node.js).

## 1. Update repos

```bash
git -C ~/bin pull && git -C ~/.dotfiles pull
```

## 2. Save OrbStack data

Images can be pulled again, volume data is lost (e.g. local databases).

```bash
docker volume ls
# back up a volume
docker run --rm -v <volume>:/data -v "$PWD":/backup alpine tar czf /backup/<volume>.tgz -C /data .
```

## 3. Uninstall OrbStack

Quit OrbStack, then:

```bash
brew uninstall --zap --cask orbstack   # if installed with brew
# otherwise: delete OrbStack from /Applications, then
rm -rf ~/.orbstack
```

## 4. Remove OrbStack leftovers

- `~/.zprofile`: delete the `~/.orbstack/shell/init.zsh` line
- `~/.ssh/config`: delete the `Include ~/.orbstack/...` line
- `~/.docker/config.json`: delete `"currentContext": "orbstack"`
- dangling symlinks: `ls -l /usr/local/bin | grep -i orbstack`, delete what is listed

## 5. Install Docker + Colima

```bash
bin_install_update
```

It installs `colima docker docker-buildx docker-compose docker-credential-helper`, creates the VM on first run (4 CPU, 8 GB RAM, 100 GB disk, Rosetta for amd64 images) and starts it at login with `brew services`.

Then, once:

```bash
docker context rm orbstack
```

and add to `~/.docker/config.json` so `docker compose` / `docker buildx` are found:

```json
"cliPluginsExtraDirs": ["/opt/homebrew/lib/docker/cli-plugins"]
```

## 6. Check

Open a new terminal: `brew services` lists `colima`, `zinfo` loads list `colima`.

```bash
docker run --rm hello-world
docker compose version
echo "$DOCKER_HOST"   # unix:///Users/<me>/.colima/default/docker.sock
```

Then run a project's Testcontainers/LocalStack tests.

## Notes

- zsh config (`config/zsh/zshrc.main`) sets `DOCKER_HOST` and `TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE` when `colima` is installed: Testcontainers ignores docker contexts, and Ryuk/LocalStack mount the socket path inside the VM.
- Resize the VM: `colima stop && colima start --cpu 6 --memory 12` (settings are kept), then `brew services restart colima`.
