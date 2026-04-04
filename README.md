# 개발 워크스테이션 미션 결과 보고서

## 1. 프로젝트 개요
이 프로젝트는 코드가 내 컴퓨터뿐만 아니라 모든 환경에서 동일하게 실행될 수 있도록 돕는 실무적인 개발 환경 세팅을 경험하는 것을 목표로 합니다.
터미널 및 파일 구조 이해부터 시작하여 Docker를 활용한 컨테이너 기반 격리 환경(이미지, 실행, 포트 매핑, 볼륨 마운트)을 구축하고, 협업과 버전 관리를 위한 Git/GitHub 연동을 실습했습니다.

## 2. 실행 환경

- **OS**: macOS
- **데몬 환경**: OrbStack (초기 설정 문제로 적용)
- **Shell**: bash/zsh
- **Docker**: 28.5.2 (Engine: 28.5.2)
- **Git**: 2.53.0

## 3. 수행 체크리스트

- [x] 터미널 기본 조작 및 폴더 구성
- [x] 권한 변경 실습
- [x] Docker 설치/점검
- [x] hello-world 및 ubuntu 기본 컨테이너 실행 테스트
- [x] Dockerfile 기반 커스텀 웹 서버 컨테이너 빌드 및 실행
- [x] 포트 매핑 (외부 접속 확인)
- [x] 마운트 및 볼륨 영속성 검증
- [x] Git 로컬 환경 설정 및 커밋
- [x] GitHub 연동, 스크린샷 증거자료 추가

## 4. 수행 기록 및 검증 방식

### 4-1. 터미널 조작
명령어 및 파일 이동 등을 터미널 만으로 수행하고 그 결과를 확인하였습니다.

```bash
$ pwd
/Users/ldryong10097422/dev-workstation/practice
$ touch file1.txt
$ echo 'Hello' > file1.txt
$ cp file1.txt file2.txt
$ mkdir dir1
$ mv file2.txt dir1/renamed.txt
$ rm file1.txt
$ ls -la
total 0
drwxr-xr-x  3 ldryong10097422  ldryong10097422   96 Apr  4 19:16 .
drwxr-xr-x  5 ldryong10097422  ldryong10097422  160 Apr  4 19:16 ..
drwxr-xr-x  3 ldryong10097422  ldryong10097422   96 Apr  4 19:16 dir1
```

### 4-2. 권한 변경 (chmod) 실습
파일과 디렉토리에 대한 읽기/쓰기/실행 권한을 변경하고 `ls -l`을 통해 변경사항을 확인하였습니다.

```bash
$ ls -la dir1/renamed.txt
-rw-r--r--  1 ldryong10097422  ldryong10097422  6 Apr  4 19:16 dir1/renamed.txt
$ chmod 777 dir1/renamed.txt
$ ls -la dir1/renamed.txt
-rwxrwxrwx  1 ldryong10097422  ldryong10097422  6 Apr  4 19:16 dir1/renamed.txt

$ ls -ld dir1
drwxr-xr-x  3 ldryong10097422  ldryong10097422  96 Apr  4 19:16 dir1
$ chmod 755 dir1
$ ls -ld dir1
drwxr-xr-x  3 ldryong10097422  ldryong10097422  96 Apr  4 19:16 dir1
```

---

### 4-3. Docker 환경 점검
시스템 보안 정책을 우회하기 위해 **OrbStack**을 활용하여 데몬을 구동하고 버전을 점검하였습니다.

```bash
$ docker --version
Docker version 28.5.2, build ecc6942

$ docker info | grep -E 'Server Version|Operating System|OSType|Architecture|Name'
 Server Version: 28.5.2
 Operating System: OrbStack
 OSType: linux
 Architecture: x86_64
 Name: orbstack
```

---

### 4-4. Docker 컨테이너 기본 동작 (hello-world / ubuntu)
`docker run`을 통해 기본 이미지를 실행하여 정상적인 동작을 관찰했습니다.

```bash
$ docker run --rm hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.
...

$ docker run --rm ubuntu /bin/bash -c "cat /etc/os-release | grep PRETTY_NAME"
PRETTY_NAME="Ubuntu 24.04.4 LTS"
```

---

### 4-5. 빌드 및 포트 매핑 (Dockerfile & Nginx)
Nginx의 경량 이미지(alpine) 위에 작성한 커스텀 html 파일을 덮어쓰는 구조로 Dockerfile을 구성했습니다.

**Dockerfile**
```dockerfile
FROM nginx:alpine
LABEL org.opencontainers.image.title="my-custom-nginx"
ENV APP_ENV=dev
EXPOSE 80

# 사용자 지정 html을 Nginx 기본 경로로 복사
COPY src/ /usr/share/nginx/html/
```

**빌드 및 실행 결과**
```bash
$ docker build -t my-web:1.0 .
# ... 정상적으로 빌드 완료 ...

$ docker run -d -p 8080:80 -v mysite_data:/usr/share/nginx/html --name my-web-8080 my-web:1.0
6126324e5023a6f459ef9ffdffc5d3993913096f7edb7f4421c34fe82aebba53

$ curl http://localhost:8080
<!DOCTYPE html>
<html>...<h1>Hello from NGINX on Docker!</h1>...</html>
```
### 웹 브라우저 접속 인증
<img width="663" height="198" alt="Screenshot " src="https://github.com/user-attachments/assets/98bd6596-1754-4b45-aa64-dd476d9271a9" />


---

### 4-6. Docker Volume 및 볼륨 영속성 검증
`mysite_data` 라는 이름의 볼륨을 생성하여 `my-web-8080`에 연결한 다음, 호스트에서 직접 `docker cp` 또는 바인드 마운트로 파일을 변경하고, 해당 **컨테이너를 삭제 후 새로 생성(my-web-8081)** 하였을 때에도 변경된 데이터가 볼륨에 의해 유지됨을 증명했습니다.

1. 볼륨 데이터 수정 (8080 컨테이너 도중 변경)
```bash
$ docker cp practice/new_index.html my-web-8080:/usr/share/nginx/html/index.html
$ curl http://localhost:8080
Updated by Volume Mount
```

2. 8080 컨테이너 완전 삭제 후 **새로운 8081 포트 컨테이너**에 동일 볼륨 마운트 증명
```bash
$ docker rm -f my-web-8080
my-web-8080

$ docker run -d -p 8081:80 -v mysite_data:/usr/share/nginx/html --name my-web-8081 my-web:1.0
ad6cdd93c1c84749e937ede2c3bd76892112c5f4e8808b1d947ab21a64d9e2d7

$ curl http://localhost:8081
Updated by Volume Mount
```

---

### 4-7. Git 초기화 기록
이러한 설정 파일들을 Git을 이용해 버전 관리할 수 있도록 초기화하였습니다.

```bash
$ git init
Initialized empty Git repository in /Users/ldryong10097422/dev-workstation/.git/
$ git add .
$ git config user.name 'ldryong1008-coder' && git config user.email 'ldryong1009@gmail.com'
$ git commit -m 'Initial commit'
$ git log -1
commit a40cc13eb326fb141e2152f1fa5d47097985efab
Author: ldryong1008-coder <ldryong1009@gmail.com>
Date:   Sat Apr 4 19:23:33 2026 +0900

    Initial commit
```


## 5. 트러블슈팅
1. **OrbStack 미실행에 따른 데몬 연결 실패**
   - 문제: Terminal 등에서 Docker info 혹은 Docker run 명령을 수행 시 응답 없이 무한 대기
   - 원인: 데몬 서비스(Docker Engine)가 현재 구동되지 않아 연결 타임아웃 증상 발생
   - 해결: 백그라운드 환경을 지시하는 OrbStack 응용 프로그램 본체를 직접 실행시킴으로써 문제 해결.

2. **접근 권한 제한에 따른 Sudo 미사용**
   - 문제: 시스템 보안 정책상 `sudo`를 막아둔 상태. 관리자 권한 없이 데몬을 관리하기 곤란.
   - 원인: 서울캠퍼스(또는 특정 사내 환경) 등 보안 정책
   - 대안: Root-less하게 작동할 수 있는 형태의 가상화 데몬 툴(OrbStack)을 이용해 사용자의 시스템 훼손 없이 독립된 환경 구축.
