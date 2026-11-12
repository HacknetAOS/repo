# repo

[![Deploy Pages](https://github.com/HacknetAOS/repo/actions/workflows/deploy-pages.yml/badge.svg)](https://github.com/HacknetAOS/repo/actions/workflows/deploy-pages.yml)

Pacman binary package repository for HacknetOS, served via GitHub Pages.

- **Repository URL**: `https://hacknetaos.github.io/repo/$arch`
- **Signing Key Fingerprint**: `6D9D 481F 4ACB 997F 919B CA90 D906 9C15 6B0C 606C`
- **Public Key**: [`hacknetaos.asc`](hacknetaos.asc) / [`hacknetaos.gpg`](hacknetaos.gpg)

## Adding the Repository

1. Import and locally sign the packaging key:

```bash
curl -fsSL https://hacknetaos.github.io/repo/hacknetaos.asc | sudo pacman-key --add -
sudo pacman-key --lsign-key 6D9D481F4ACB997F919BCA90D9069C156B0C606C
```

2. Add `[hacknetos]` to `/etc/pacman.conf`:

```ini
[hacknetos]
SigLevel = Required DatabaseOptional
Server = https://hacknetaos.github.io/repo/$arch
```

3. Synchronize and install:

```bash
sudo pacman -Syu hacknet-os
```

## Updating Packages

Copy newly built `.pkg.tar.zst` files into `x86_64/` and run:

```bash
./update.sh
```

`update.sh` generates detached GPG signatures (`.sig`) for all packages, updates and signs `hacknetos.db.tar.gz` and `hacknetos.files.tar.gz`, and writes regular file copies (`hacknetos.db`, `hacknetos.files`) for static hosting on GitHub Pages.

## GitHub Pages Configuration

In the GitHub repository settings under **Settings -> Pages -> Build and deployment**, set **Source** to **GitHub Actions**. Pushes to `main` automatically publish the repository via `.github/workflows/deploy-pages.yml`.
