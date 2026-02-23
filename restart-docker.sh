#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$ROOT_DIR/.env" ]; then
  source "$ROOT_DIR/.env"
fi

echo "==> 기존 컨테이너 중지 및 삭제..."
docker compose down

echo "==> 도커 컨테이너 재생성 및 재실행..."
docker compose up -d openclaw-gateway

echo "==> 재실행 완료!"
echo "로그 확인: docker compose logs -f openclaw-gateway"
