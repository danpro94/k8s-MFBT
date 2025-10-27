- **4-1 kubectl 별칭(Alias) 설정**
    1. 별칭을 사용하고자 하는 사용자 접속
    2. cd ~ 홈디렉터리 이동
    3. vim .bashrc 설정 파일 편집기로 열어서 마지막 라인에 다음 내용 삽입 → 저장 → 빠져나오기
        
        ```bash
        # kubectl auto completion
        source <(kubectl completion bash)
        
        # kubectl -> k alias
        alias k=kubectl
        
        # Alias k auto completion
        complete -F __start_kubectl k
        ```
        
    4. source ~/.bashrc 명령으로 적용
