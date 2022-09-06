FROM openjdk:19-alpine

ARG VERSION=7.1.2
ARG POSTGRES_DRIVER_VERSION=42.2.19
ARG MYSQL_DRIVER_VERSION=8.0.23

RUN apk update                                                                                       && \
    apk add --no-cache --virtual .build-deps curl tar git                                            && \
    apk add --no-cache ruby ruby-rdoc npm                                                            && \
    gem install bundle-audit                                                                         && \
    bundle audit update                                                                              && \
    mkdir /opt/yarn                                                                                  && \
    curl -Ls https://yarnpkg.com/latest.tar.gz | tar -xz --strip-components=1 --directory /opt/yarn  && \
    ln -s /opt/yarn/bin/yarn /usr/bin/yarn                                                           && \
    npm install -g pnpm                                                                              && \
    wget https://github.com/jeremylong/DependencyCheck/releases/download/v${VERSION}/dependency-check-${VERSION}-release.zip -O dependency-check.zip && \
    unzip dependency-check.zip -d /usr/share/                                                        && \
    cd /usr/share/dependency-check/plugins                                                           && \
    curl -Os "https://jdbc.postgresql.org/download/postgresql-${POSTGRES_DRIVER_VERSION}.jar"        && \
    curl -Ls "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz" \
        | tar -xz --directory "/usr/share/dependency-check/plugins" --strip-components=1 --no-same-owner \
            "mysql-connector-java-${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar" && \
    ln -s /usr/share/dependency-check/bin/dependency-check.sh /usr/bin/dependency-check && \
    apk del .build-deps

WORKDIR /workdir
