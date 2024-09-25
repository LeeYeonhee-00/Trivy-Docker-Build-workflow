# FROM nginx:1.21.0
# COPY index.html /usr/share/nginx/html/index.html

# 취약점이 있는 오래된 nginx 버전 사용
FROM nginx:1.16.0

# 루트 권한으로 실행 (보안 문제)
USER root

# 취약한 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    netcat \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# 시스템 라이브러리 다운그레이드 (의도적인 취약점 생성)
RUN apt-get update && apt-get install -y \
    libssl1.0.0 \
    && rm -rf /var/lib/apt/lists/*

# 불필요한 포트 노출
EXPOSE 22 80 443

# 취약한 환경 변수 설정
ENV DB_PASSWORD="insecure_password"

# 안전하지 않은 명령어 실행
RUN chmod 777 /etc/nginx/nginx.conf

# 샘플 HTML 파일 복사
COPY index.html /usr/share/nginx/html/index.html

CMD ["nginx", "-g", "daemon off;"]