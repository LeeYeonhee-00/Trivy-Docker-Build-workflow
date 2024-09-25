# <p align="center"> Trivy Docker Build 
### Trivy를 사용한 도커 컨테이너 이미지 취약점 감지
---

<h2 style="font-size: 25px;"> 개발팀원👨‍👨‍👧‍👦<br>
<br>

|<img src="https://avatars.githubusercontent.com/u/127727927?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/90971532?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/98442485?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/66353700?v=4" width="150" height="150"/>|
|:-:|:-:|:-:|:-:|
|[@부준혁](https://github.com/BooJunhyuk)|[@이승언](https://github.com/seungunleeee)|[@신혜원](https://github.com/haewoni)|[@이연희](https://github.com/LeeYeonhee-00)|

---

<br>

## 프로젝트 목적 🌷
CI 과정 중 trivy 검사를 진행하여 컨테이너 보안 취약점을 미리 식별하여 위험성을 낮춤

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

## Github Actions Workflow with Trivy💻
1. Docker Build를 진행
2. Image가 만들어지면 Scan 실행
3. 결과를 github로 전송
4. 내용 전송
4-a. 결과를 확인해 취약점이 있다면 slack로 그 사실을 전송 <br>
4-b. 결과를 확인해 취약점이 없으면 아무것도 안하고 종료


### 1. slack webhook url을 해당 github repository에 등록
![image](https://github.com/user-attachments/assets/5615cc42-f67a-490d-a65b-6c476ae70dc4)

### 2. 프로젝트의 .github/workflows/ 디렉토리에 위치에 GitHub Actions workflow 파일 생성
```
name: Docker Build, Trivy Scan, and Slack Notification

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

env:
  DOCKER_IMAGE: myusername/my-docker-image
  SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}

jobs:
  check_files:
    runs-on: ubuntu-latest
    outputs:
      run_workflow: ${{ steps.check.outputs.run_workflow }}
    steps:
      - uses: actions/checkout@v2
      - name: Check for README changes
        id: check
        run: |
          if git diff --name-only ${{ github.event.before }} ${{ github.sha }} | grep -q "README.md"; then
            echo "run_workflow=readme" >> $GITHUB_OUTPUT
          else
            echo "run_workflow=full" >> $GITHUB_OUTPUT
          fi

  readme_update:
    needs: check_files
    if: needs.check_files.outputs.run_workflow == 'readme'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Push README update
        run: |
          echo "README.md has been updated. Skipping Docker build and Trivy scan."
          git config user.name github-actions
          git config user.email github-actions@github.com
          git add README.md
          git commit -m "Update README.md [skip ci]"
          git push

  build-scan-notify:
    needs: check_files
    if: needs.check_files.outputs.run_workflow == 'full'
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v1

    - name: Build Docker image
      run: docker build -t ${{ env.DOCKER_IMAGE }}:${{ github.sha }} .

    - name: Run Trivy vulnerability scanner
      uses: aquasecurity/trivy-action@master
      id: trivy
      with:
        image-ref: '${{ env.DOCKER_IMAGE }}:${{ github.sha }}'
        format: 'table'
        exit-code: '1'
        ignore-unfixed: true
        severity: 'CRITICAL,HIGH'

    - name: Send Slack notification
      if: failure()
      uses: 8398a7/action-slack@v3
      with:
        status: ${{ job.status }}
        text: |
          Vulnerabilities found in Docker image. 
          Image: ${{ env.DOCKER_IMAGE }}:${{ github.sha }}
          Trivy Scan Result:
          ${{ steps.trivy.outputs.sarif }}
        webhook_url: ${{ secrets.SLACK_WEBHOOK }}
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}

    - name: Fail if vulnerabilities found
      if: failure()
      run: exit 1
```

-> Docker image build 후 생성된 이미지 파일을 trivy를 이용하여 보안 검사 진행 <br>
-> Security 단계가 CRITICAL,HIGH 에 해당하는 report가 나올 경우 결과물에 대해 push를 진행하지 않음<br>
-> report결과를 slack을 통해 개발자에게 전달  
<br>

### 3. main 브랜치에 push하거나 pull request를 열 때 실행
 
#### trivy에 의해 보안취약점이 발견된 경우 

![image](https://github.com/user-attachments/assets/e557c853-4e15-4922-be2c-fa30fb8936c7)
<br>
![image](https://github.com/user-attachments/assets/6245ab7a-7436-418c-8204-61a8aa24b211)
<br>
![image](https://github.com/user-attachments/assets/18292f20-b97f-4a1e-80e9-0a9ccf54f8f9)

보안 취약점이 발생한 경우 github actions를 통해 slack으로 메세지를 전송

#### trivy에 의해 보안 검사를 통과한 경우 
![image](https://github.com/user-attachments/assets/34189785-032e-4de5-9c68-80e6b3edf9b3)
<br>
![image](https://github.com/user-attachments/assets/0a6db3f2-a700-4895-8f8a-c52fd286b26d)
<br>
![image](https://github.com/user-attachments/assets/d0bdaf67-e5b9-496c-b61e-1c4a548f6dd7)

빌드 성공 후 보안 취약점 검사 통과시 위와 같은 메세지를 전송

## 결론 

**자동화된 보안 검증 및 실시간 대응**:<br> GitHub Actions와 Trivy, Slack을 통합함으로써 CI 과정에서 자동으로 보안 취약점을 스캔하고, 실시간으로 Slack 알림을 통해 문제를 빠르게 인지하고 대응할 수 있습니다.  이를 통해 배포 전 보안 문제를 신속히 해결할 수 있습니다.




