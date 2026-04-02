프로젝트 개요

미션 목표: 보안 정책상 sudo 권한이 제한된 서울캠퍼스 환경에서 OrbStack을 활용하여 Docker 가상 환경을 구축하고, 컨테이너 운영 및 데이터 영속성을 검증한다.
핵심 학습: 터미널 명령어, 파일 권한(chmod), Dockerfile 빌드, 포트 매핑, 볼륨 관리, Git/GitHub 연동.


---
## 1) 실행 환경
OS: macOS (Apple Silicon/Intel)

Container Runtime: OrbStack (Docker Desktop Alternative)

Shell: zsh

Docker Version: 28.5.2

Git Version: 2.53.0

---
## 2) 수행 항목 체크리스트

[0] 터미널 기본 조작 및 폴더 구성

[0] 권한 변경 실습 (파일 및 디렉토리)

[0] Docker 설치 및 데몬 점검 (OrbStack 활용)

[0] hello-world 및 ubuntu 컨테이너 실행

[0] Dockerfile 기반 커스텀 이미지 빌드/실행

[0] 포트 매핑 접속 및 브라우저 검증 (8080, 8081)

[0] 바인드 마운트 반영 (실시간 소스 수정)

[0] Docker 볼륨 영속성 검증 (데이터 복구 확인)

[0] Git 설정 + GitHub 강제 연동 완료

---
## 3) 수행로그(발췌)
---
1.터미널 조작 및 권한 변경

% pwd


/Users/ldryong10097422


% mkdir -p ~/orbstack-project && cd ~/orbstack-project


% touch test.txt && echo "hello OrbStack" > test.txt


% ls -l test.txt


-rw-r--r--  1 ldryong10097422  ldryong10097422  15 Apr  2 18:03 test.txt


% chmod 644 test.txt


% ls -l test.txt


-rw-r--r--  1 ldryong10097422  ldryong10097422  15 Apr  2 18:03 test.txt


---
2.Docker 설치 및 컨테이너 운영


% docker --version


Docker version 28.5.2, build ecc6942


% docker run hello-world


Hello from Docker!


% docker images


REPOSITORY    TAG       IMAGE ID       CREATED        SIZE


my-web        1.0       945992038191   2 hours ago    62.2MB


nginx         alpine    d5030d429039   8 days ago     62.2MB


hello-world   latest    e2ac70e7319a   9 days ago     10.1kB


ubuntu        latest    f794f40ddfff   5 weeks ago    78.1MB


alpine        latest    a40c03cbb81c   2 months ago   8.44MB


% docker ps -a
CONTAINER ID   IMAGE          STATUS                     PORTS                    NAMES


20218c16fe90   nginx:alpine   Up 2 minutes               0.0.0.0:8081->80/tcp     mount-test


59c21525d392   my-web:1.0     Exited (255) 7 minutes ago 0.0.0.0:8080->80/tcp     my-web-container


704fc1907169   ubuntu         Exited (0) 18 minutes ago                           my-ubuntu



---
3.Dockerfile 커스텀 및 빌드


% cat <<EOF > Dockerfile


FROM nginx:alpine


COPY ./app/index.html /usr/share/nginx/html/index.html


EOF



FROM nginx:alpine


COPY ./app/index.html /usr/share/nginx/html/index.html




% docker build -t my-web:1.0 .


% docker run -d -p 8080:80 --name my-web-container my-web:1.0


59c21525d39227b12a62698a4470a59a95ce23369d7ae8918817fd960105900d(정상실행)


---
4.볼륨 영속성 검증


% docker run -d -p 8081:80 --name mount-test -v $(pwd)/app:/usr/share/nginx/html nginx:alpine


% docker volume create my-data-vol


% docker run -d --name vol-tester -v my-data-vol:/app/data alpine sleep infinity


% docker exec vol-tester sh -c "echo 'This data survives power off!' > /app/data/hello.txt"


% docker rm -f vol-tester


% docker run -d --name vol-tester-new -v my-data-vol:/app/data alpine sleep infinity


% docker exec vol-tester-new cat /app/data/hello.txt


This data survives power off!


---
## 4)트러블슈팅 (2건)
---


1.작업 중 호스트 재부팅으로 인한 컨테이너 중단


문제: docker ps -a 확인 시 컨테이너가 Exited (255) 상태로 멈춰 있음.


원인 가설: 맥 전원 종료(또는 세션 복구) 과정에서 OrbStack 데몬이 비정상 종료됨.


확인: STATUS가 Exited (255) 7 minutes ago인 것을 확인.


해결: OrbStack 재실행 후 기존 컨테이너를 삭제하고, 바인드 마운트 등 필요한 컨테이너를 재구동하여 복구함.


---
2.Git Push 시 버전 충돌(non-fast-forward) 발생


문제: GitHub 원격 저장소에 푸시 시 ! [rejected] main -> main 에러 발생.


원인 가설: GitHub 생성 시 자동 생성된 파일과 로컬 파일 간의 충돌(add/add) 및 히스토리 불일치.


확인: git pull --rebase 시 Dockerfile에서 컨플릭트 발생 확인.


해결: 과제 초기 환경이므로 로컬 작업물을 최종본으로 강제 반영하기 위해 git push origin main --force를 사용하여 해결함.


---
## 5)검증 증거
---
GitHub Repository: https://github.com/ldryong1008-coder/ai-codyssey.git


% git config --global user.name "ldryong1008-coder 


dquote> git config --global user.email "ldryong1009@gmail.com"


dquote> git config --global init.defaultBranch main


dquote> 


ldryong10097422@c4r7s8 orbstack-project % git config --global user.name "ldryong1008-coder"


ldryong10097422@c4r7s8 orbstack-project % git config --global user.email "ldryong1009@gmail.com"


ldryong10097422@c4r7s8 orbstack-project % git config --global init.defaultBranch main


ldryong10097422@c4r7s8 orbstack-project % git config --list


credential.helper=osxkeychain


user.name=ldryong1008-coder


user.email=ldryong1009@gmail.com


init.defaultbranch=main


ldryong10097422@c4r7s8 orbstack-project % git init


Initialized empty Git repository in /Users/ldryong10097422/orbstack-project/.git/


ldryong10097422@c4r7s8 orbstack-project % git add .


ldryong10097422@c4r7s8 orbstack-project % git commit -m "Complete Docker & OrbStack Assignment"


[main (root-commit) 78e1bc5] Complete Docker & OrbStack Assignment



% git push -u origin main


Username for 'https://github.com': ldryong1008-coder


Password for 'https://ldryong1008-coder@github.com': 


3 files changed, 4 insertions(+)

 
 create mode 100644 Dockerfile
 
 
 create mode 100644 app/index.html
 
 
 create mode 100644 test.txt



기술 문서: README.md (본 문서)


포트 매핑 확인: http://localhost:8080 <img width="2624" height="2192" alt="image" src="https://github.com/user-attachments/assets/a584f651-a0f4-4736-b8fb-694f93ddbf26" />


동작 구조 설계 및 경로 선택


디렉토리 구성 기준: 프로젝트의 독립성과 재현성을 위해 ~/orbstack-project라는 루트 폴더를 생성했습니다. 하위에 app/ 폴더를 두어 소스 코드(HTML)와 인프라 설정 파일(Dockerfile)을 분리함으로써 관리 효율성을 높였습니다.


포트/볼륨 재현 설정: Dockerfile에 COPY 명령을 명시하고, 실행 시 -p(포트)와 -v(볼륨) 옵션을 표준화하여 기록했습니다. 이를 통해 어떤 환경에서도 동일한 명령어로 서비스 복구가 가능하도록 설계했습니다.


절대 경로 vs 상대 경로: 


상대 경로: Dockerfile 빌드 시(COPY ./app ...)처럼 프로젝트 폴더 내부 자원을 참조할 때 사용합니다.


절대 경로: Docker 바인드 마운트(-v $(pwd)/app:...) 시에는 호스트 시스템의 정확한 위치를 컨테이너에 매핑해야 하므로 절대 경로를 사용합니다.




이미지와 컨테이너의 차이 (빌드/실행/변경)


이미지(Image): 서비스 운영에 필요한 모든 파일과 설정을 담은 '읽기 전용(Read-only)' 템플릿입니다. (빌드 단계)


컨테이너(Container): 이미지를 실행한 **'상태'**입니다. 이미지라는 설계도 위에 쓰기 가능한 계층(Layer)이 추가된 형태입니다. (실행 단계)


차이점: 이미지는 한 번 빌드되면 변경할 수 없지만(Immutable), 컨테이너는 실행 중에 데이터를 생성하거나 변경할 수 있습니다. 다만 컨테이너 삭제 시 변경분은 사라집니다. (변경 관점)



포트 매핑의 원리와 진단


포트 매핑이 필요한 이유: 컨테이너는 격리된 네트워크 환경을 가집니다. 외부(호스트/브라우저)에서 컨테이너 내부 서비스에 접근하려면 호스트의 특정 문(Port)과 컨테이너의 문을 연결해주는 통로가 반드시 필요합니다.


포트 충돌 진단 순서:


1.  docker ps로 이미 해당 포트를 쓰는 컨테이너가 있는지 확인.


2.  lsof -i :[포트번호] 명령어로 호스트의 다른 프로세스가 포트를 점유 중인지 진단.


3.  점유 중인 프로세스 종료 또는 docker run -p [새포트]:80과 같이 호스트 포트를 변경하여 실행.




파일 권한 숫자 표기 규칙 (chmod)


권한 규칙: 읽기(4), 쓰기(2), 실행(1)의 합으로 결정됩니다.


755 (rwxr-xr-x): 소유자(4+2+1=7), 그룹(4+1=5), 기타(4+1=5). 실행 파일이나 디렉토리에 주로 사용.


644 (rw-r--r--): 소유자(4+2=6), 그룹(4), 기타(4). 일반적인 설정 파일이나 텍스트 파일에 사용.



데이터 영속성 대안 (Data Persistence)


문제 상황: 컨테이너 삭제 시 내부에 저장된 DB 데이터나 로그가 함께 소멸하는 위험이 있습니다.


대안 (Volume): 이를 방지하기 위해 호스트의 파일 시스템과 독립된 Docker Volume을 생성하여 연결합니다. 컨테이너를 수천 번 삭제해도 데이터는 호스트의 안전한 영역에 보관되어 새 컨테이너 연결 시 즉시 복구됩니다.
