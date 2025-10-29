#!/bin/bash
# 현재 클러스터 상태를 YAML로 백업
#

set -e

source "$(dirname "$0")/config.env"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/cluster-state-$TIMESTAMP.yaml"

echo "클러스터 상태 백업"

# 1 백업 디렉토리 생성
mkdir -p "$BACKUP_DIR"


# 2 모든 리소스 백업
echo "리소스 추출중..."
kubectl get all,pv,pvc,configmap,secret \
	--all-namespaces \
	-o yaml > "$BACKUP_FILE" 2>/dev/null || true

# 3 백업 크기 확인
BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
echo ""
echo "백업 완료!"
echo "파일: $BACKUP_FILE"
echo "크기: $BACKUP_SIZE"
echo ""
echo "복원 명령은 다음과 같습니다: ./scripts/4-restore-state.sh"
echo "클러스터 생성 1-create-cluster 스크립트에서 복원 외 다른 복원시 사용"
