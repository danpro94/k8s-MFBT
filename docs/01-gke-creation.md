[200~### GKE Cluster 생성 및 확인

### Google Kubernetes Engine 클러스터 생성

*비용 최적화를 위해 2-node 클러스터로 시작

```bash
gcloud container clusters create kubia \
    --zone=asia-northeast3-a \
    --num-nodes=2 \
    --machine-type=e2-standard-2 \
    --disk-size=50 \
    --disk-type=pd-standard \
    --enable-autoscaling \
    --min-nodes=1 \
    --max-nodes=3 \
    --enable-autorepair \
    --enable-autoupgrade \
    --no-enable-cloud-logging \
    --no-enable-cloud-monitoring
    
# --zone: Seoul 리전 (Zonal = Free tier 적용)
# --machine-type: e2 시리즈 (e2-standard-2 = 2 vCPU, 8GB RAM)
#                 n1 대비 10% 저렴[280][292]
# --disk-size: 50GB (학습용)
# --enable-autoscaling: 사용량에 따라 노드 자동 조정
# --no-enable-cloud-logging: 로깅 비용 절감
```

< GCE 쿠버네티스 클러스터 대시보드 - 관리형 클러스트 생성 확인>

![image.png](attachment:b862472f-016b-45a3-8346-4422ea50c1a0:image.png)

**클러스터 생성 확인**

```bash
# 클러스터 상태
gcloud container clusters list

# kubectl 컨텍스트 확인
kubectl config get-contexts

# 노드 확인
kubectl get nodes
# NAME                                  STATUS   AGE
# gke-kubia-default-pool-12345678-a1b2  Ready    2m
# gke-kubia-default-pool-12345678-c3d4  Ready    2m

# 클러스터 상세 정보
kubectl cluster-info
gcloud container clusters describe kubia
```

[⚠️노드 확인 안될 경우:sudo apt-get install google-cloud-cli-gke-gcloud-auth-plugin](https://www.notion.so/DevOps-Action-PLAN-2480d93a2d04806c954ef2a218e9f24d?pvs=21)
