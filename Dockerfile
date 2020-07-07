# Use AlpineLinux as base image
FROM alpine:3.5

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Git
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN apk add --update \
    python3

VOLUME [ "/code" ]
VOLUME [ "/tmp/.ssh" ]

ADD scripts/* /usr/bin/

EXPOSE 80

ENTRYPOINT [ "start.sh" ]
