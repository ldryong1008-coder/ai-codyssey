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

### 4-4. Docker 컨테이너 기본 동작 및 목록 관리 (hello-world / ubuntu)
`docker run`을 통해 기본 이미지를 실행하여 정상적인 동작을 관찰했으며, 설치된 이미지 및 구동 중인 컨테이너 목록을 정기적으로 확인하고 불필요한 컨테이너를 정리(`docker rm`)하는 실습을 진행했습니다.

```bash
$ docker run --rm hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.
...

$ docker run --rm ubuntu /bin/bash -c "cat /etc/os-release | grep PRETTY_NAME"
PRETTY_NAME="Ubuntu 24.04.4 LTS"

$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
ubuntu        latest    817807f3c64e   1 days ago     77.9MB
hello-world   latest    4f55086f7dd0   3 months ago   9.14kB

$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
# (모든 과정에서 `--rm` 자동 정리 옵션을 사용하거나 `docker rm -f`로 명시적 정리하여 깨끗한 상태 유지)
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

### 4-6. Docker 스토리지(Bind Mount & Volume) 검증

#### 4-6-1. 바인드 마운트(Bind Mount) 호스트 변경 실시간 반영 증거
호스트의 특정 디렉토리(`~/dev-workstation/practice`)를 컨테이너 내부(`/usr/share/nginx/html`)로 덮어씌워 마운트했습니다. 명령어 실행 후, 호스트에서 파일을 변경하자마자 컨테이너(웹 응답)에도 즉시 반영됨을 확인했습니다.

```bash
$ echo 'Bind Mount Before' > ~/dev-workstation/practice/bind_test.html
$ docker run -d -p 8082:80 -v ~/dev-workstation/practice:/usr/share/nginx/html --name bind-test my-web:1.0

# (호스트 파일 변경 전 확인)
$ curl http://localhost:8082/bind_test.html
Bind Mount Before

# (호스트 파일 내용 변경)
$ echo 'Bind Mount After' > ~/dev-workstation/practice/bind_test.html

# (호스트 파일 변경 후 웹서버 실시간 반영 확인)
$ curl http://localhost:8082/bind_test.html
Bind Mount After
```

#### 4-6-2. 볼륨(Volume) 영속성(Persistence) 증거
`mysite_data` 라는 이름의 볼륨을 생성하여 `my-web-8080`에 연결한 다음 컨테이너 데이터를 수정한 뒤, 해당 **컨테이너를 완전히 지우고 새로 생성(`my-web-8081`)** 하였을 때에도 변경된 데이터가 동일 볼륨에 의해 무사히 유지됨을 증명했습니다.

1. 볼륨 데이터 접속 및 수정 (8080 컨테이너 도중 데이터 덮어쓰기)
```bash
$ docker cp practice/new_index.html my-web-8080:/usr/share/nginx/html/index.html
$ curl http://localhost:8080
Updated by Volume Mount
```

2. 8080 컨테이너 삭제 후 **새로운 8081 포트 컨테이너**에 동일 볼륨 마운트 및 영속성 증명
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

$ git remote add origin https://github.com/ldryong1008-coder/ai-codyssey.git
$ git branch -M main
$ git push -u origin main
# (원격 저장소에 성공적으로 반영됨을 확인)
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

## 7. 과제 목표 달성 및 개념 정리

**1. 이미지/컨테이너 목록 확인 및 정리 흔적이 있는가?**
- `docker images` 명령어를 통해 로컬에 다운로드된 `hello-world`, `ubuntu`, `nginx` 커스텀 웹 서버 이미지를 확인했습니다. 수행 기록 4-4 및 4-6에서 컨테이너 조회(`docker ps -a`) 및 자동 컨테이너 삭제 옵션(`--rm`) 또는 수동 명시적 정리명령어(`docker rm -f`)를 결합해 컨테이너 쓰레기 데이터가 누적되지 않고 깔끔하게 정리되는 구조를 실습에 반영하였습니다.

**2. 프로젝트 디렉토리 구조를 어떤 기준으로 구성했는지 설명할 수 있는가?**
- 프로젝트 루트(`~/dev-workstation`)에는 전체 구조를 담당하는 설정 파일(`Dockerfile`, `README.md`, `run.sh` 등)을 위치시켰습니다. 
- 반면 컨테이너 내부 공간에서 서비스될 핵심 소스코드 파일들은 `src/` 라는 하위 디렉토리에 분리하여 배치함으로써 **서버 인프라의 구성 코드 영역(Dockerfile)**과 **애플리케이션의 컨텐츠 및 비즈니스 로직(src)의 영역**을 철저히 명확하게 분리하는 관리 체계 기준을 적용했습니다.

**3. 포트/볼륨 설정을 어떤 방식으로 재현 가능하게 정리했는지 설명할 수 있는가?**
- `docker run -p 8080:80 -v mysite_data:/usr/share/nginx/html` 과 같이, 단순히 포트 매핑 규칙과 볼륨 이름을 터미널에 텍스트로 타이핑하는 데 그치지 않고, 워크스테이션 환경과 무관하게 언제나 동일하게 동작하도록 **`docker_run.sh` 셸 스크립트 파일에 해당 명령어들을 모아 코드로 정의(Infrastructure as Code 방식의 기초)** 해 두었습니다.
- 이를 통해 누가 어느 환경에서 해당 스크립트(`bash docker_run.sh`)를 실행하더라도 동일한 볼륨 마운트와 8080 포트가 매핑된 웹 서버가 똑같이 재현되도록 실행 자동화와 환경 재현성을 보장했습니다.

**4. 이미지와 컨테이너의 차이를 "빌드/실행/변경" 관점에서 구분해 설명할 수 있는가?**
- **이미지(Image)**: 클래스(Class)와 같은 설계 템플릿 단계입니다. `Dockerfile`을 통해 **"빌드"**되며, 누군가 손댈 수 없는 읽기 전용 상태(`Read-Only`)로 소스코드와 OS 환경이 단단하게 패키징 된 단위입니다.
- **컨테이너(Container)**: 이러한 이미지를 디스크에서 메모리로 올려 **"실행"**시킨 살아숨쉬는 서버 인스턴스(Instance) 프로세스 상태입니다. 구동 중인 내부 파일을 임의로 **"변경"**하거나 통째로 삭제하더라도 템플릿인 원본 이미지는 절대 훼손되지 않으며, 변경 상태를 저장하기 위해 Volume을 꽂아 사용하는 구조입니다.

**5. 컨테이너 내부 포트로 직접 접속할 수 없는 이유와 필요한 이유를 설명할 수 있는가?**
- 컨테이너는 내 컴퓨터 네트워크 자원과 격리된 완전한 **가상 고유 네트워크 IP 대역망(Docker0 Interface)** 위에서 띄워지기 때문에, 내 PC 환경의 브라우저에서 `localhost:80` 같은 방식으로 컨테이너에 직접적인 인입 및 접속이 물리적으로 불가능합니다. 
- 이를 연결하기 위해 **포트 매핑(-p 8080:80)** 방식을 거쳐야 비로소 내 컴퓨터의 포트번호(8080)와 격리된 컨테이너 내부의 포트번호(80) 사이의 방화벽 터널이 열려, 유저가 외부 브라우저를 통해 서비스를 제공받는 목적성이 충족되기 때문에 필수적입니다.

**6. 절대 경로/상대 경로를 어떤 상황에서 선택하는지 설명할 수 있는가?**
- **절대 경로**(`/Users/ldryong/dev...`): 최상위 루트 디렉토리(`/`)부터 타겟 도달 시까지의 전체 경로입니다. 시스템 배치 프로그램이나 Cron Job 등 어느 위치에서 명령이 트리거되더라도 정확하게 같은 파일 주소를 가리킬 수 있도록 견고함이 필요할 때 선택합니다.
- **상대 경로**(`./practice` 또는 `../`): 현재 명령어를 치는 위치 (`pwd`)를 기준으로 타겟에 도달하는 경로입니다. Git 프로젝트 디렉토리 내부에서 파일 조작(cp, mv)을 할 때 가독성과 간결성을 유지하고 타 환경 이식성을 높이기 위해 선택합니다.

**7. 파일 권한 숫자 표기(예: 755, 644)가 어떤 규칙으로 결정되는지 설명할 수 있는가?**
- 리눅스 파일 권한은 `Owner(소유자)`, `Group(그룹 소속)`, `Other(기타 남들)` 3자리 세트로 표시됩니다.
- 한 세트는 다시 `읽기(r=4)`, `쓰기(w=2)`, `실행(x=1)`의 이진 특성 권한 값을 합산한 숫자로 정해집니다.
  - **755**: 소유자는 읽기+쓰기+실행(4+2+1=7), 그룹과 기타 사용자는 쓰기가 불가능한 읽기+실행(4+1=5)만을 부여받아 함부로 지우지 못하게 보호. (폴더나 시스템 실행파일의 룰)
  - **644**: 소유자는 읽기+쓰기(4+2=6), 타 사용자는 오직 읽기(4)만 가능하게 제한. (일반 텍스트 문서/HTML 파일의 룰)

**8. "호스트 포트가 이미 사용 중"일 때 원인을 진단하는 순서?**
- 1) **포트 점유 상태 확인**: 터미널에서 `lsof -i :8080` 이나 `netstat -tuln | grep 8080` 명령어를 입력하여 현재 내 호스트의 8080번 포트를 어떤 프로세스(PID)가 점유하고 있는지 확인합니다.
- 2) **원인 파악 및 조치**: 이전에 백그라운드로 띄워 둔 다른 Docker 컨테이너가 여전히 점유 중인지, 아니면 별개의 로컬 데몬이 켜져 있는지 파악합니다. 더 이상 필요 없다면 해당 프로세스를 강제 종료(`kill -9 PID` 또는 `docker rm -f 컨테이너명`)하여 포트를 확보합니다.
- 3) **대안 적용**: 만약 기존 프로세스(다른 서비스)를 계속 유지해야만 하는 상황이라면, 실행 명령어의 호스트 포트 매핑 구간을 `-p 8081:80`처럼 아직 비어있는 다른 번호로 우회 변경하여 충돌을 피합니다.

**9. 컨테이너 삭제 후 데이터 손실 방지에 대한 대안?**
- Docker 컨테이너는 본질적으로 'Stateless(무상태성)' 철학을 따르며 소모품처럼 삭제되고 다시 띄워지기 쉽게 설계되었습니다. 내부에 중요한 파일(DB 데이터 등)을 직접 쓰고 컨테이너를 지우면 데이터는 영구히 소멸하여 손실됩니다.
- **해결 대안(바인드 마운트와 넷볼륨)**: 데이터 손실을 원천적으로 막기 위해, 컨테이너 내부의 중요 데이터 저장 경로를 호스트의 영구적인 스토리지 영역으로 연결시켜 격리 이탈을 시도해야 합니다. 이를 위해 도커가 관리해주는 `Docker Volume`(`-v volume_name:/path`)을 사용해 영속성을 챙기거나, 특정 물리 폴더를 직접 찌르는 `Bind Mount`(`-v /host/path:/container/path`) 기법을 필수적으로 적용해야 컨테이너 생명주기와 데이터 생명주기를 분리할 수 있습니다.

**10. 가장 어려웠던 지점과 해결 과정 (가설 → 확인 → 조치)**
- **어려웠던 지점**: Docker 데몬이 구동되지 않아 `docker ps` 등 CLI 툴킷 전체가 무응답(Hang)되는 문제와, 터미널 환경상 관리자 권한(`sudo`) 사용이 인가되지 않은 악조건이 겹쳤던 점이 가장 까다로웠습니다.
- **가설 수립**: 명령이 에러조차 뱉지 않고 무한 대기하는 것은 '서버 데몬 소켓' 자체가 열려 있지 않아 소켓 연결 요청을 계속 재시도 중이기 때문이라 여겼고, 보안상 sudo 커맨드를 막아두어 기존의 `sudo systemctl start docker` 같은 정석적인 해결법은 통하지 않을 것이라 가정했습니다.
- **확인**: 터미널에서 시간 제한 없이 기다리거나 `docker info`를 쳐서 한참 뒤 타임아웃 에러가 발생하는 것을 관찰해 데몬이 다운되어 있음을 입증했습니다.
- **조치 해결**: 시스템 루트 권한(Root) 환경을 침범하지 않고도 가상화 데몬을 제공해주는 툴인 **OrbStack**을 활용하는 대안을 채택했습니다. OrbStack 앱 본체를 윈도우/맥 GUI 환경에서 켜서 사용자 권한으로 백그라운드 구동을 인가시킨 뒤 터미널 창을 재가동하니, `docker info` 가 즉각 떨어지며 데몬 통신이 복구됨을 증명해냈습니다.

**11. 컨테이너 종료 / 유지(attach vs exec 등)의 차이를 관찰하고 간단히 정리?**
- 컨테이너는 내부에 구동 중인 핵심 프로세스(PID가 1인 동작)가 종료되면 컨테이너 자체도 멈춥니다(Exited). 이 원리에 따라 진입 명령어 사용 시 차이가 갈립니다.
- **`attach`**: 컨테이너가 처음 켜질 때 실행 중인 "바로 그 1번 프로세스"의 입출력/로그 터미널(Standard I/O) 화면에 내 현재 터미널을 직결(Attach)로 붙이는 명령입니다. 따라서 여기서 `Ctrl+C`나 `exit`를 누르면 그 1번 메인 프로세스가 종료 신호를 받아 죽어버리므로, **컨테이너 전체가 중지(Stop)** 되는 현상으로 이어집니다.
- **`exec` (-it)**: 이미 띄워져서 잘 돌아가고 있는 메인 프로세스 뒷단에, 별도 문을 열고 들어가 "새로운 서브 쉘 프로세스(예: `/bin/bash` 나 `sh` 등)"를 추가로 가동해 진입하는 명령입니다. 이 상태에서 아무리 이것저것 하다가 `exit`를 쳐서 나가더라도, '내가 불러들인 서브 쉘 프로세스'가 종료될 뿐, 1번 프로세스(서버 구동 등)에는 절대 영향을 주지 않아 **컨테이너는 백그라운드에서 끄떡없이 유지**됩니다.
