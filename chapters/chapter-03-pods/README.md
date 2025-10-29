# Chapter 3: Pods
## 학습 목표
- Pod 생성
- Pod 상태 확인
- Pod 접근 및 로깅

## 실습 내용

### Pod 생성

1. **파드 생성**
    
    kubectl run webserver —image=nginx —port=80
    
    ⇒ ‘run’은 가장 간단하게 CLI로 모든 구성요소가 포함된 Pods를 생성할 수 있는 방법이다.
    

2. **파드 확인**
    1. 일반적인 확인
        
        kubectl get pods
        
        → 생성된 파드들의 현황 및 상태 요약 확인
        
        kubectl **describe** pod <파드이름> 
        
        → 파드의 **상세한 정보**를 확인
        
        kubectl logs <파드이름>
        
        → 파드의 로그 확인
        
    2. 상세한 확인
        
        kubectl get pod <파드이름> **-o yaml**
        
        → 파드 상세 정보를 **yaml output형태**로 확인
        
        kubectl get pod <파드이름> **-o wide**
        
        → 파드가 **어느 노드에서 실행되는지** 확인
        
        kubectl get pod kubia-imperative -o jsonpath='{.spec.containers[*].name}'
        → 파드 내부 컨테이너 확인
        

3. **파드 접근 테스트**
    1. Pod의 IP로 접근 (클러스터 내부)
        
        kubectl exec -it <파드이름> — curl [localhost:80](http://localhost:80)
        
    2. 로컬에서 접근
        
        [kubectl port-forward pod/<파드이름> 포트:포트
        
    
2. **yaml로 파드 생성**
    
    ```yaml
    #demo-webserver.yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: demo-wevbserver
      labels:
        app: nginx-webserver
        version: manual
    spec:
      containers:
        - name: webserver
          image: nginx
          ports:
          - containerPort: 8080
            protocol: TCP
    ```

## 학습 포인트
- Pod: 쿠버네티스의 가장 작은 배포 단위
- 항상 하나 이상의 컨테이너를 포함 in 컨테이너 안에는 하나의 앱
- kubectl run 은 모든 구성요소가 포함된 pod를 만들 수 있는 가장 간단한 CLI 방식

## 트러블 슈팅
Pod ngnix 로컬 접근(port-forward)시 에러 발생
### 문제(다음 에러 발생)
Unable to listen on port 80: Listeners failed to create with the following errors: [unable to create listener: Error listen tcp4 127.0.0.1:80: bind: permission denied unable to create listener: Error listen tcp6 [::1]:80: bind: permission denied]
error: unable to listen on any of the requested ports: [{80 80}]
### 분석
- 권한 부족에 따른 바인딩(리스닝) 실패
- 리눅스 및 대부분의 운영체제에서 1024 이하의 포트는 기본적으로 root권한이 있어야만 바인딩(리스닝) 가능
- kubectl port-forward 명령은 “현재 사용자 권한”으로 실행
- 운영체제 커널에서 접근 거부 에러 발생
### 조치
- 간단히 1025이상 (80 대신 8080) 포트 변경
- (비권장,리스크 높음) root로 포트포워딩 실행


