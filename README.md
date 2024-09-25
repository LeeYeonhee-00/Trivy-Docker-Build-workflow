# <p align="center"> Trivy Docker Build 
### Trivy를 사용한 도커 컨테이너 이미지 분석 실습
---

<h2 style="font-size: 25px;"> 개발팀원👨‍👨‍👧‍👦<br>
<br>

|<img src="https://avatars.githubusercontent.com/u/127727927?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/90971532?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/98442485?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/66353700?v=4" width="150" height="150"/>|
|:-:|:-:|:-:|:-:|
|[@부준혁](https://github.com/BooJunhyuk)|[@이승언](https://github.com/seungunleeee)|[@신혜원](https://github.com/haewoni)|[@이연희](https://github.com/LeeYeonhee-00)|

---

<br>

## 프로젝트 목적 🌷
컨테이너 보안과 CI/CD 파이프라인 통합을 통해 소프트웨어 배포 과정에서 보안 취약점을 미리 식별하고 해결하는 과정 실습하기 위함.

<br>

## Trivy란 ? :mag_right:
: 취약점을 간단히 스캔할 수 있는 도구 중 하나, 가장 가볍고 기능이 많은 툴

- **Misconfiguration** (잘못된 구성인지)
- **Vulnerabilities** (보안에 취약한지)
<br>

### Trivy의 스캔 가능 대상
- Container Image
- Filesystem and rootfs
- git repository
- kubernetes

<br>

## Trivy 설치 및 기본 사용법
```
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
```

## Trivy 활용 모드
- 이미지 모드: 도커 컨테이너 이미지에 대한 취약점 스캔
- 파일 시스템 모드: 파일 시스템의 취약점을 검사
- 리포지토리 모드: Git 저장소의 소스 코드 취약점 스캔

## 실습 과정💻
: 관련 정보 결과를 한 번에 확인할 수 있는 스크립트 작성 <br>


#### case 1




