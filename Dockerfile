# Dockerfile for alpine awscli
FROM python:3.6.3-alpine3.6

MAINTAINER Edward Raigosa <wenlock@github.com>

ARG user=aws
ARG group=aws
ARG uid=1000
ARG gid=1000

ENV S3_TMP /tmp/s3cmd.zip
ENV S3_ZIP /tmp/s3cmd-master
ENV RDS_TMP /tmp/RDSCLi.zip
ENV RDS_VERSION 1.19.004
ENV AWSCLI_VERSION=1.11.189

USER root
RUN set -x -v && apk --no-cache add \
        bash  \
        bash-completion \
        less  \
        curl  \
        jq    \
        openssh \
    && python3 -m pip install \
                      python-dateutil \
                      awscli===${AWSCLI_VERSION} \
    && addgroup -g ${gid} ${group} \
    && adduser -h "/home/${user}" -u ${uid} -G ${group} -s /bin/bash -D ${user} \
    && mkdir -p "/home/${user}/.aws" \
    && chown -R ${user}:${group} "/home/${user}" \
    && chmod 755 "/home/${user}" \
    && chmod 700 "/home/${user}/.aws"

USER aws

WORKDIR "/home/${user}"
# Expose volume for adding credentials
RUN aws --version
CMD ["/bin/bash", "--login"]
