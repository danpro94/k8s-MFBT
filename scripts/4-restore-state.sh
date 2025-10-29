#!/bin/bash
# 백업된 상태를 새 클러스터에 복원

set -e

source "$(dirname "$0")/config.env"

echo "클러스터 상태 복원"
echo ""

# 1 백업 파일 목록
if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A $BACKUP_DIR)" ]; then
	echo "백업된 파일이 없습니다."
	exit 1
fi

echo "사용 가능한 백업: "
ls -1t "$BACKUP_DIR" | nl
echo ""

read -p "어떤걸 복원하시겠습니까? (최신=1): " BACKUP_NUM
BACKUP_FILE=$(ls -1t "$BACKUP_DIR" | sed -n "${BACKUP_NUM}p")

if [ -z "$BACKUP_FILE" ]; then
	echo "잘못된 번호입니다."
	exit 1
fi

BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILE"

echo "복원 파일: $BACKUP_FILE"
echo ""
echo " 경고 : 이전 상태의 모든 리소스가 적용됩니다."
echo "현재 클러스터의 리소스: "
kubectl get all --all-namespaces 2>/dev/null | head -20
echo ""

read -p "계속 하시겠습니까? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo "복원을 취소합니다."
	exit 0
fi

# 2 복원 전 기존 파드 정리 (권장)
read -p "기존 리소스를 먼저 정리하겠습니까? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
	echo "기존 리소스 정리 중..."
	kubectl delete namespace --all --ignore-not-found=true
	sleep 5
fi

# 3 복원 실행
echo "복원중..."
kubectl apply -f "$BACKUP_PATH" 2>/dev/null || true

echo ""
echo "복원 완료!"
kubectl get pods --all-namespaces
