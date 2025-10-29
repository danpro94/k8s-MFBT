#!/bin/bash
# 학습 종료시 클러스터 삭제(비용 절감)

set -e

# 환경 변수 로드
source "$(dirname "$0")/config.env"

echo "GKE 클러스터 삭제"

# 1 삭제 전 백업 여부 확인
read -p "현재 상태를 백업하시겠습니까? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
	echo "백업중 ..."
	bash "$(dirname "$0")/3-backup-state.sh"
fi

# 2 클러스터 존재 여부 확인
if ! gcloud container clusters describe "$CLUSTER_NAME" --zone="$ZONE" &>/dev/null; then
	echo "클러스터가 존재하지 않습니다."
	exit 0
fi

# 3 현재 리소스 표시
echo ""
echo "삭제될 리소스:"
kubectl get all --all-namespaces 2>/dev/null || echo "(kubectl 연결 실패)"
echo ""

# 4 최종 확인
read -p "재확인: 클러스터를 정말 삭제하시겠습니까? (y/n): " -n 1 r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo " 삭제 취소"
	exit 0
fi

# 5 클러스터 삭제
echo " 클러스터 삭제중..."
gcloud container clusters delete "$CLUSTER_NAME" \
	--zone="$ZONE" \
	--quiet

echo ""
echo "클러스터 삭제 완료!"
echo "비용 발생 가능성 제거됨."
echo ""
