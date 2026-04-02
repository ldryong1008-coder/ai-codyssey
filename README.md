아래는 과제 요구사항을 모두 반영한 제출용 README 템플릿입니다. 그대로 복사해 시작하시고, TODO/TBD/<> 항목을 채워 주세요. 필요 시 섹션을 추가/삭제해도 됩니다.

------------------------------------------------------------
# 개발 워크스테이션 구축 (Submission README)

본 저장소는 터미널 기반으로 개발 워크스테이션을 구축하고, Docker·Git·포트 매핑·마운트/볼륨 등을 실습한 전 과정을 재현 가능하게 기록합니다. 이 문서 하나(README)만으로 모든 증거(명령+출력+스크린샷)를 확인할 수 있습니다.

- 저장소 링크: <GitHub Repository URL 입력>
- 평가자는 이 README 순서대로 따라 하면 동일한 결과를 재현할 수 있습니다.

목차
- 1. 프로젝트 개요
- 2. 실행 환경
- 3. 수행 항목 체크리스트
- 4. 빠른 검증 가이드(평가자용)
- 5. 검증 방법 및 증거 링크
- 6. 터미널 조작 로그
- 7. 권한 실습(파일/디렉토리)
- 8. Docker 설치 및 기본 점검 로그
- 9. Docker 기본 운영 명령 로그
- 10. 컨테이너 실행 실습
- 11. 커스텀 이미지 제작(Dockerfile)
- 12. 포트 매핑 및 접속 증거
- 13. 바인드 마운트 및 볼륨 영속성 검증
- 14. Git 설정 및 GitHub/VSCode 연동 증거
- 15. 트러블슈팅(2건 이상)
- 16. 학습 목표 설명(개념 정리)
- 17. 보안·개인정보 보호
- 18. 재현성 및 주의사항
- 19. 부록(명령 모음)

1. 프로젝트 개요
- 미션 목표: 터미널 기반으로 Docker 환경을 구성·운영하고, Dockerfile로 커스텀 이미지를 만들며, 포트 매핑·바인드 마운트·볼륨을 통해 동작과 영속성을 검증한다. Git/GitHub로 이력을 관리하고, 기술 문서만으로 재현 가능한 증거를 남긴다.
- 선택 베이스:
  - 옵션 A: 웹 서버 베이스(NGINX/Apache 등) + 정적 콘텐츠/설정 교체
  - 옵션 B: Linux 베이스(Ubuntu/Alpine 등) + 패키지/유저/ENV/헬스체크 추가
- 내가 선택한 옵션: <A 또는 B> / 베이스 이미지: <예: nginx:alpine>

2. 실행 환경
- OS: <예: macOS 14.x / Windows 11 / Ubuntu 22.04>
- Shell/Terminal: <예: zsh(iTerm2), PowerShell, bash>
- Docker Engine/CLI: <docker --version 결과>
- Docker Backend: <예: OrbStack / Docker Desktop>
- Git: <git --version 결과>
- 기타: <VSCode 버전, Browser 등>
- 제약/전제: sudo 제한 환경 -> OrbStack으로 Docker 엔진 구동(필요 시 대체 안내 포함)

3. 수행 항목 체크리스트
- [ ] 터미널 조작(위치/목록/이동/생성/복사/이름변경/삭제/파일보기/빈파일)
- [ ] 권한 실습(파일 1개, 디렉토리 1개) 전/후 비교 기록
- [ ] Docker 설치 및 점검(docker --version, docker info)
- [ ] Docker 기본 운영(images, ps, logs, stats)
- [ ] 컨테이너 실행(hello-world, ubuntu 내부 명령)
- [ ] Dockerfile 기반 커스텀 이미지 빌드/실행
- [ ] 포트 매핑 접속 증거(브라우저 주소창 포함 또는 curl)
- [ ] 바인드 마운트 반영 증거
- [ ] Docker 볼륨 영속성 증거
- [ ] Git 사용자 정보/기본 브랜치 설정
- [ ] GitHub/VSCode 연동 증거(민감정보 마스킹)

4. 빠른 검증 가이드(평가자용)
- 사전 조건: Docker 엔진 실행(OrbStack/Docker Desktop). 리포지토리 클론:
  ```
  git clone <repo_url>
  cd <repo_name>
  ```
- 커스텀 이미지 빌드/실행(예: nginx):
  ```
  docker build -t <your_image_name>:v1 ./app
  docker run -d --name <your_container_name> -p 8080:80 \
    -v $(pwd)/app/html:/usr/share/nginx/html:ro \
    <your_image_name>:v1
  ```
- 확인:
  - 브라우저 http://localhost:8080 또는
  - 터미널:
    ```
    curl -i http://localhost:8080
    docker logs <your_container_name>
    ```
- 볼륨 테스트(예시):
  ```
  docker volume create demo_data
  docker run --name voltest -d -v demo_data:/data busybox sleep 3600
  docker exec voltest sh -c 'echo hello > /data/keep.txt && ls -l /data'
  docker rm -f voltest
  docker run --name voltest2 -d -v demo_data:/data busybox sleep 3600
  docker exec voltest2 cat /data/keep.txt
  ```

5. 검증 방법 및 증거 링크
- Docker 버전/데몬: 섹션 8 코드블록/출력
- 운영 명령(images/ps/logs/stats): 섹션 9
- hello-world/ubuntu 실행: 섹션 10
- 커스텀 이미지 빌드/실행: 섹션 11
- 포트 매핑 접속: 섹션 12 (스크린샷 포함)
- 바인드 마운트/볼륨: 섹션 13
- Git/GitHub/VSCode 연동: 섹션 14 (스크린샷 포함)
- 스크린샷 폴더: [docs/screenshots](./docs/screenshots)

6. 터미널 조작 로그
아래는 실제 입력 명령과 출력 결과입니다. 민감정보는 마스킹했습니다.
- 현재 위치/목록/이동
  ```
  pwd
  ls -la
  cd <대상_경로>
  ```
  출력:
  ```
  <여기에 실제 출력 붙여넣기>
  ```
- 생성/복사/이름변경/삭제
  ```
  mkdir -p demo/dir
  touch demo/file.txt
  cp demo/file.txt demo/file_copy.txt
  mv demo/file_copy.txt demo/file_renamed.txt
  rm -f demo/file_renamed.txt
  ```
  출력:
  ```
  <출력>
  ```
- 파일 내용 확인/빈 파일 생성
  ```
  echo "sample" > demo/file.txt
  cat demo/file.txt
  touch demo/empty.txt
  ```

7. 권한 실습(파일/디렉토리)
- 대상: 파일 demo/file.txt, 디렉토리 demo/dir
- 변경 전 권한
  ```
  ls -l demo/file.txt
  ls -ld demo/dir
  ```
  출력:
  ```
  <전 상태>
  ```
- 권한 변경
  ```
  chmod 644 demo/file.txt
  chmod 755 demo/dir
  ```
- 변경 후 권한
  ```
  ls -l demo/file.txt
  ls -ld demo/dir
  ```
  출력:
  ```
  <후 상태>
  ```
- 메모: 644=rw-r--r--, 755=rwxr-xr-x (의미는 섹션 16 참조)

8. Docker 설치 및 기본 점검 로그
- 버전 확인
  ```
  docker --version
  ```
  출력:
  ```
  <출력>
  ```
- 데몬 동작 여부
  ```
  docker info
  ```
  출력:
  ```
  <출력(민감정보 마스킹)>
  ```
- 참고: sudo 제한 환경에서는 OrbStack/Docker Desktop으로 엔진 실행(대안: 리모트 Docker context)

9. Docker 기본 운영 명령 로그
- 이미지/컨테이너 목록
  ```
  docker images
  docker ps
  docker ps -a
  ```
  출력:
  ```
  <출력>
  ```
- 로그/리소스
  ```
  docker logs <컨테이너명 또는 ID>
  docker stats --no-stream
  ```
  출력:
  ```
  <출력>
  ```

10. 컨테이너 실행 실습
- hello-world
  ```
  docker run --rm hello-world
  ```
  출력:
  ```
  <성공 메시지 전체>
  ```
- ubuntu 진입/명령
  ```
  docker run -it --name utest ubuntu bash
  # 컨테이너 내부
  ls /
  echo "hi from container" > /tmp/hi.txt
  cat /tmp/hi.txt
  exit
  ```
- attach/exec 차이 관찰 메모
  - attach: 메인 프로세스 표준입출력에 붙음(종료 시 컨테이너 종료될 수 있음)
  - exec: 실행 중 컨테이너에 별도 프로세스를 추가로 실행(컨테이너 수명과 분리)

11. 커스텀 이미지 제작(Dockerfile)
- 베이스 선택: <예: nginx:alpine>
- 커스텀 포인트와 목적
  - 예) 정적 페이지 교체: 조직/과제 소개 페이지 노출
  - 예) 보안 헤더 추가: NGINX conf 수정
- 디렉토리 구조
  ```
  app/
    Dockerfile
    html/
      index.html
    conf/
      default.conf  # 선택
  ```
- Dockerfile(예시 템플릿: 필요에 맞게 수정)
  ```
  FROM nginx:alpine
  COPY html/ /usr/share/nginx/html/
  # COPY conf/default.conf /etc/nginx/conf.d/default.conf
  EXPOSE 80
  HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:80 || exit 1
  ```
- 빌드/실행 로그
  ```
  docker build -t <your_image_name>:v1 ./app
  docker run -d --name <your_container_name> -p 8080:80 <your_image_name>:v1
  docker logs <your_container_name>
  ```
  출력:
  ```
  <출력>
  ```

12. 포트 매핑 및 접속 증거
- 명령:
  ```
  docker run -d --name <your_container_name> -p 8080:80 <your_image_name>:v1
  ```
- 접속 확인:
  - 브라우저 주소: http://localhost:8080
  - 또는 curl:
    ```
    curl -i http://localhost:8080
    ```
- 스크린샷: 주소창(포트 포함)과 화면이 함께 보이게 캡처
  - [이미지 링크 1](./docs/screenshots/port_mapping_browser.png)
  - [이미지 링크 2](./docs/screenshots/curl_output.png)

13. 바인드 마운트 및 볼륨 영속성 검증
- 바인드 마운트(호스트 변경 반영)
  - 실행:
    ```
    docker run -d --name bindtest -p 8081:80 \
      -v $(pwd)/app/html:/usr/share/nginx/html:ro \
      <your_image_name>:v1
    ```
  - 호스트 변경 전/후:
    ```
    sed -i.bak 's/Original/Updated/g' app/html/index.html
    curl -s http://localhost:8081 | grep Updated
    git checkout -- app/html/index.html  # 예: 원복
    ```
  - 증거 스크린샷/로그:
    - [이미지 링크](./docs/screenshots/bind_mount_diff.png)
- Docker 볼륨(영속 데이터)
  - 생성/연결/검증:
    ```
    docker volume create appdata
    docker run -d --name volweb -p 8082:80 \
      -v appdata:/data \
      <your_image_name>:v1
    docker exec volweb sh -c 'echo persist > /data/keep.txt && ls -l /data && cat /data/keep.txt'
    docker rm -f volweb
    docker run -d --name volweb2 -p 8083:80 -v appdata:/data <your_image_name>:v1
    docker exec volweb2 cat /data/keep.txt
    ```
  - 전/후 비교 로그 첨부:
    ```
    docker volume ls
    docker inspect appdata
    ```

14. Git 설정 및 GitHub/VSCode 연동 증거
- Git 사용자/기본 브랜치 설정
  ```
  git config --global user.name "<masked_name>"
  git config --global user.email "<masked_email>"
  git config --global init.defaultBranch main
  git config --list --show-origin
  ```
  출력:
  ```
  <토큰/경로 등 민감정보는 마스킹>
  ```
- GitHub 로그인/리모트 연결
  ```
  git remote -v
  git branch -vv
  git log --oneline -n 5
  ```
- VSCode 연동 스크린샷
  - [이미지 링크](./docs/screenshots/vscode_github_auth.png)
  - 유의: 토큰/계정 ID 일부 마스킹

15. 트러블슈팅(2건 이상)
- 사례 1
  - 문제: <예: docker info가 permission denied>
  - 가설: <예: Docker 데몬 미기동 또는 context 오설정>
  - 확인: <예: docker context ls / OrbStack 상태 확인>
  - 해결/대안: <예: OrbStack 시작, context 전환, 재시도 로그 첨부>
  - 증거 링크: <섹션/스크린샷 링크>
- 사례 2
  - 문제: <예: 포트 충돌(8080 in use)>
  - 가설: <예: 기존 컨테이너/프로세스 점유>
  - 확인: <예: docker ps / lsof -i :8080>
  - 해결/대안: <예: 포트 변경 또는 충돌 컨테이너 제거>
  - 증거 링크: <링크>

16. 학습 목표 설명(개념 정리)
- 절대 경로 vs 상대 경로
  - 절대: 루트(/ 또는 드라이브 문자)부터의 전체 경로. 예: /usr/local/bin
  - 상대: 현재 디렉토리(.) 기준. 예: ./app/html, ../logs
- 권한 r/w/x와 755/644
  - r=4, w=2, x=1; 사용자/그룹/기타 순서로 합산
  - 755 = (7=rwX)(5=r-x)(5=r-x), 644 = (6=rw-)(4=r--)(4=r--)
- 포트 매핑이 필요한 이유
  - 컨테이너 내부 포트(예: 
