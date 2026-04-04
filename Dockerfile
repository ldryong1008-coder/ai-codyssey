FROM nginx:alpine
LABEL org.opencontainers.image.title="my-custom-nginx"
ENV APP_ENV=dev
EXPOSE 80

# 사용자 지정 html을 Nginx 기본 경로로 복사
COPY src/ /usr/share/nginx/html/
