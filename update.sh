#!/bin/bash
# HacknetAOS Package Repository Indexer & Signer
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCH_DIR="$SCRIPT_DIR/x86_64"
KEY_ID="${GPG_KEY_ID:-6D9D481F4ACB997F919BCA90D9069C156B0C606C}"

cd "$ARCH_DIR"

echo "=== Signing packages in x86_64 ==="
for pkg in *.pkg.tar.zst; do
    if [ ! -f "${pkg}.sig" ] || [ "$pkg" -nt "${pkg}.sig" ]; then
        echo "Signing $pkg..."
        rm -f "${pkg}.sig"
        gpg --batch --yes --detach-sign --no-armor -u "$KEY_ID" "$pkg"
    fi
done

echo "=== Updating and signing repository database ==="
rm -f hacknetos.db* hacknetos.files*
repo-add --sign --key "$KEY_ID" hacknetos.db.tar.gz *.pkg.tar.zst

# Replace symlinks with regular files for GitHub Pages static hosting
rm -f hacknetos.db hacknetos.db.sig hacknetos.files hacknetos.files.sig
cp -f hacknetos.db.tar.gz hacknetos.db
cp -f hacknetos.db.tar.gz.sig hacknetos.db.sig
cp -f hacknetos.files.tar.gz hacknetos.files
cp -f hacknetos.files.tar.gz.sig hacknetos.files.sig

echo "=== Repository index and signatures updated ==="
ls -la hacknetos.db* hacknetos.files*
