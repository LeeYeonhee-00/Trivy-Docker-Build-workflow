# FROM nginx:1.21.0
# COPY index.html /usr/share/nginx/html/index.html

# 비교적 최신이지만 여전히 취약점이 있는 nginx 버전 사용
FROM nginx:1.20

# 루트 권한으로 실행 (보안 문제)
USER root

# 취약한 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    netcat \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# 샘플 HTML 파일 복사
COPY index.html /usr/share/nginx/html/index.html
