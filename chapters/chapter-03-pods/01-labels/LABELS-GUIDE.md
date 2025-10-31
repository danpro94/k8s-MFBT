# Labels 정리

## 왜 Labels인가?
### 1. Pod 100개가 있을 때
- 이름으로는 구분 불가능
- Labels로 그룹화, 부분집합, 교집합 등 검색 가능

### 2. 사용 예시
✓ Deployment: "app=web-backend" 레이블의 모든 Pod 관리
✓ Service: "tier=backend" Pod들에 트래픽 분산
✓ 모니터링: "environment=production" Pod만 모니터링

## Label Selector 패턴

| 패턴 | 예시 | 의미 |
|------|-----|------|
| Equality | `app=web` | app이 정확히 "web" |
| Set-based | `app in (web,api)` | app이 "web" 또는 "api" |
| Negation | `tier != data` | tier가 "data"가 아닌 것 |
| Existence | `version` | version 레이블이 있는 것 |

## 권장 Label 규칙

✓ `app`: 애플리케이션 이름
✓ `tier`: frontend/backend/data
✓ `environment`: production(운용 또는 서비스 환경)/staging(최종 테스트 환경)/dev(개발 환경)
✓ `version`: v1.0, v1.1, etc
✓ `owner`: 담당자
✓ `cost-center`: 비용 추적용
