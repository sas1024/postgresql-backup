FROM alpine:latest

RUN apk add --no-cache postgresql17-client coreutils bzip2 bash

COPY ./pg-backup.sh /pg-backup.sh

RUN chmod +x /pg-backup.sh && mkdir sql

ENTRYPOINT ["./pg-backup.sh"]
