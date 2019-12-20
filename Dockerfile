FROM openjdk:14-alpine3.10

ARG VERSION=5.2.4-release
ARG POSTGRES_DRIVER_VERSION=42.2.6
ARG MYSQL_DRIVER_VERSION=8.0.17

RUN apk update                                                                                       && \
    apk add --no-cache --virtual .build-deps curl tar                                                && \
    apk add --no-cache ruby ruby-rdoc                                                                && \
    gem install bundle-audit                                                                         && \
    bundle audit update                                                                              && \
    wget https://bintray.com/jeremy-long/owasp/download_file?file_path=dependency-check-${VERSION}.zip -O dependency-check.zip && \
    unzip dependency-check.zip -d /usr/share/                                                        && \
    cd /usr/share/dependency-check/plugins                                                           && \
    curl -Os "https://jdbc.postgresql.org/download/postgresql-${POSTGRES_DRIVER_VERSION}.jar"        && \
    curl -Ls "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz" \
        | tar -xz --directory "/usr/share/dependency-check/plugins" --strip-components=1 --no-same-owner \
            "mysql-connector-java-${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar" && \
    ln -s /usr/share/dependency-check/bin/dependency-check.sh /usr/bin/dependency-check && \
    apk del .build-deps

WORKDIR /workdir
