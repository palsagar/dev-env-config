#!/usr/bin/env bash
# Run the playbook against a throwaway container, then run it again: the second run must report changed=0.
# Usage: tests/container-test.sh <image> <root|user-name> [extra ansible-playbook arguments]
# Example: tests/container-test.sh debian:13 root
# Installs Docker but skips starting it (no systemd in a container). data_disk needs a real disk, so it stays off.
set -euo pipefail
cd "$(dirname "$0")/.."

image=${1:?usage: container-test.sh <image> <root|user-name> [ansible args]}
user=${2:?usage: container-test.sh <image> <root|user-name> [ansible args]}
shift 2
extra=("$@")

name="dev-env-test-${image//[:.]/-}-$user"
docker rm -f "$name" >/dev/null 2>&1 || true
docker run -d --name "$name" "$image" sleep infinity >/dev/null
[ -n "${KEEP:-}" ] || trap 'docker rm -f "$name" >/dev/null' EXIT

# Root starts from the bare image, which also tests the python3 and sudo bootstrap.
if [ "$user" != root ]; then
  docker exec "$name" bash -c "
    apt-get update -qq && apt-get install -y -qq python3 sudo >/dev/null &&
    useradd -m -s /bin/bash $user &&
    echo '$user ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$user"
fi

inv="$(mktemp -d)/inventory.yml"
cat > "$inv" <<YAML
all:
  hosts:
    $name:
      ansible_connection: community.docker.docker
      ansible_user: $user
YAML

run() { uv run ansible-playbook -i "$inv" site.yml --skip-tags docker_service ${extra[@]+"${extra[@]}"}; }
run
echo "=== Idempotence check ==="
run | tee /dev/stderr | grep -E "^$name +:.* changed=0 " >/dev/null \
  || { echo "FAIL: second run changed something" >&2; exit 1; }

docker exec -u "$user" "$name" zsh -ic 'set -e; command -v fzf eza fd bat zoxide yazi lazygit btop tmux uv ipdb nvim docker dig; nvim --version | head -1; fzf --version; lazygit --version | head -c 60; echo; uv --version; hf version; claude --version; node --version; gh --version | head -1; docker --version; docker compose version; docker buildx version; locale -a | grep -qi en_US.utf8'
echo "PASS: $image as $user"
