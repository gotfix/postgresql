FROM postgres:9.6-alpine
MAINTAINER ian@phpb.com

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_BRANCH
ARG VERSION

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="Docker PostgreSQL" \
      org.label-schema.description="Dockerized PostgreSQL for use with Gitlab CE" \
      org.label-schema.usage="https://gotfix.com/docker/postgresql/blob/master/README.md" \
      org.label-schema.url="https://gotfix.com/docker/postgresql" \
      org.label-schema.vcs-url=https://gotfix.com/docker/postgresql.git \
      org.label-schema.vendor="Ian Matyssik <ian@phpb.com>" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.version="${VERSION}" \
      org.label-schema.build-date="${BUILD_DATE}" \
      com.gotfix.maintainer="ian@phpb.com" \
      com.gotfix.license=MIT \
      com.gotfix.docker.dockerfile="/Dockerfile"

ENV PG_APP_HOME="/etc/docker-postgresql"\
    PG_VERSION=9.6 \
    PG_USER=postgres \
    PG_HOME=/var/lib/postgresql \
    PG_RUNDIR=/run/postgresql \
    PG_LOGDIR=/var/log/postgresql \
    PG_CERTDIR=/etc/postgresql/certs

ENV PG_BINDIR=/usr/lib/postgresql/${PG_VERSION}/bin \
    PG_DATADIR=${PG_HOME}/${PG_VERSION}/main

RUN mkdir -p /etc/postgresql/${PG_VERSION}/main/ \
 && ln -sf ${PG_DATADIR}/postgresql.conf /etc/postgresql/${PG_VERSION}/main/postgresql.conf \
 && ln -sf ${PG_DATADIR}/pg_hba.conf /etc/postgresql/${PG_VERSION}/main/pg_hba.conf \
 && ln -sf ${PG_DATADIR}/pg_ident.conf /etc/postgresql/${PG_VERSION}/main/pg_ident.conf \
 && umount ${PG_HOME}/data \
 && rm -rf ${PG_HOME}/data \
 && rm -rf ${PG_HOME}

COPY runtime/ ${PG_APP_HOME}/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 5432/tcp
VOLUME ["${PG_HOME}", "${PG_RUNDIR}", "${PG_LOGDIR}"]
WORKDIR ${PG_HOME}
ENTRYPOINT ["/sbin/entrypoint.sh"]
