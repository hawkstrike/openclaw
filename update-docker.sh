#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$ROOT_DIR/.env" ]; then
  source "$ROOT_DIR/.env"
fi

IMAGE_NAME="${OPENCLAW_IMAGE:-openclaw:local}"
APT_PACKAGES="${OPENCLAW_DOCKER_APT_PACKAGES:-}"

echo "==> 최신 소스 코드로 업데이트 (git pull)..."
git pull

echo "==> 도커 이미지 재빌드 ($IMAGE_NAME)..."
docker build \
  --build-arg "OPENCLAW_DOCKER_APT_PACKAGES=${APT_PACKAGES}" \
  -t "$IMAGE_NAME" \
  -f "$ROOT_DIR/Dockerfile" \
  "$ROOT_DIR"

echo "==> 게이트웨이 컨테이너를 새 이미지로 재시작합니다..."
docker compose up -d openclaw-gateway

echo "==> 업데이트 완료!"
