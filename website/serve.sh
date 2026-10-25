#!/bin/bash
# Open the ROB550 website (with the MBot Ubuntu Server pages) on this computer.
#
#   website/serve.sh             build the first time, then open it on port 4000
#   website/serve.sh --rebuild   build again (after changing a page in website/overlay)
#   website/serve.sh 4001        use another port
#
# Needs Docker (only to build the site) and python3.

set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
build="$here/_build"
site="$build/_site"

rebuild=false
if [[ "${1:-}" == "--rebuild" ]]; then
    rebuild=true
    shift
fi
port="${1:-4000}"

if $rebuild || [[ ! -f "$site/index.html" ]]; then
    [[ -f "$here/rob550-docs/_config.yml" ]] || {
        echo "The course site is missing. Run this in the repository folder first:"
        echo "    git submodule update --init"
        exit 1
    }
    command -v docker >/dev/null || { echo "Docker is needed to build the site: https://www.docker.com/products/docker-desktop/"; exit 1; }
    docker info >/dev/null 2>&1 || {
        echo "Docker is installed but not running. Start it, then run this again:"
        echo "    Docker Desktop: open the Docker app"
        echo "    Colima: colima start"
        exit 1
    }
    echo "Building the website (the first time takes a few minutes)..."
    rm -rf "$build"
    mkdir -p "$build"
    rsync -a --exclude .git "$here/rob550-docs/" "$build/"
    rsync -a "$here/overlay/" "$build/"
    docker run --rm -v "$build:/site" -w /site ruby:3.3 bash -c '
        set -e
        gem install --silent bundler:2.6.2 >/dev/null
        bundle install --quiet
        bundle exec jekyll build -d /site/_site 2>&1 | grep -E "done|rror" || true
    '
    [[ -f "$site/index.html" ]] || { echo "The build failed, see the messages above."; exit 1; }
fi

echo
echo "Open this page in your browser:"
echo "    http://localhost:$port/docs/botlab/mbot-system-setup-Pi5.html"
echo "Press Ctrl+C to stop."
cd "$site"
exec python3 -m http.server "$port" --bind 127.0.0.1
