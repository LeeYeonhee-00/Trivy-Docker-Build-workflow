# FROM nginx:1.21.0
# COPY index.html /usr/share/nginx/html/index.html

FROM nginx:1.16.0

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]