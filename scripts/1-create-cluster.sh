#!/bin/bash
#클러스터 원클릭 생성(학습 재개)

set -e #에러 발생시 중단용

#환경 변수 로드
source "$(dirname "$0")/config.env"

echo "GKE 클러스터 생성"
echo "Project: $PROJECT_ID"
echo "Cluster: $CLUSTER_NAME"
echo "Region: $ZONE"
echo "Nodes: $NODE_COUNT"


echo "1 프로젝트 설정 진행중..."
gcloud config set project "$PROJECT_ID"
gcloud config set compute/zone "$ZONE"

if gcloud container clusters describe "$CLUSTER_NAME" --zone="$ZONE" &>/dev/null; then
	echo "클러스터가 이미 존재합니다."
	read -p "삭제후 생성? (y/n):" -n 1 -r
	echo
	if [[$REPLY =~ ^[Yy]$ ]]; then
		echo "기존 클러스터 삭제 중..."
		gcloud container clusters delete "$CLUSTER_NAME" --zone"$ZONE" --quiet
	else
		echo "생성 취소됨"
		exit 0
	fi
fi

# 클러스터 생성
echo "2 클러스터 생성중..."
gcloud container clusters create "$CLUSTER_NAME" \
    --zone="$ZONE" \
    --num-nodes="$NODE_COUNT" \
    --machine-type="$MACHINE_TYPE" \
    --disk-size="$DISK_SIZE" \
    --disk-type=pd-standard \
    $ENABLE_AUTOSCALING \
    --min-nodes="$MIN_NODES" \
    --max-nodes="$MAX_NODES" \
    --enable-autorepair \
    --enable-autoupgrade \
    $ENABLE_LOGGING \
    $ENABLE_MONITORING

# kubectl 컨텍스트 설정
echo "kubectl 설정중..."
gcloud container clusters get-credentials "$CLUSTER_NAME" --zone="$ZONE"


# 클러스터 상태 확인
echo "클러스터 생성 완료!"
kubectl cluster-info
echo ""
echo "Node Status:"
kubectl get nodes -o wide


# 백업이 있을 경우 복원 여부 확인
if [ -d "$BACKUP_DIR" ] && [ "$(ls -A $BACKUP_DIR)" ]; then
	echo ""
	echo -p "이전 백업을 복원하시겠습니까? (y/N): " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		bash "$(dirname "$0")/4-restore-state.sh"
	fi
fi

