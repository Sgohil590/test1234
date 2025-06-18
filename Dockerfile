

FROM nginx:alpine

RUN rm -f /bin/sh /bin/ash /bin/bash || true
EXPOSE 80

ENTRYPOINT []
CMD ["nginx", "-g", "daemon off;"]

