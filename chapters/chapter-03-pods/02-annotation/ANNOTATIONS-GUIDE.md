# Annotation 정리

## Annotation
레이블처럼 파드 혹은 다른 쿠버네티스 오브젝트가 가질 수 있는 정보.

### Label 과 Annotation 공통점
키- 값 쌍 구성 

### Label 과 Annotation 기술적 차이
Annotation 은
- 식별 정보를 갖지 않음
- 오브젝트를 묶는 데 사용할 수 없음
- 레이블 셀렉터 같은 셀렉터 없음
- 레이블 보다 많은 정보 보유 가능 (최대 256KB)

