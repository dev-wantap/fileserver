FROM ubuntu:24.04

# 시스템 업데이트 및 필요한 패키지 설치
RUN apt-get update && apt-get install -y \
    nginx \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

# Nginx 설정
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# FTP 설정
COPY vsftpd.conf /etc/vsftpd.conf

# FTP 사용자 생성 및 권한 설정
RUN useradd -m ftpuser && \
    echo "ftpuser:ftppassword" | chpasswd && \
    mkdir -p /var/www/html && \
    chown -R ftpuser:ftpuser /var/www/html && \
    chmod -R 755 /var/www/html

# 포트 설정
EXPOSE 80 20 21 21100-21110

# 시작 스크립트
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
