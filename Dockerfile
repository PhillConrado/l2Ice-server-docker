FROM openjdk:15-alpine

LABEL maintainer="l2IceNation" \
      version="1.0.0.0" \
      website="l2IceNation.com"

COPY entrypoint.sh /entrypoint.sh

ARG branch_gs=develop
ARG branch_dp=develop

RUN apk update \ 
    && apk --no-cache add maven mariadb-client unzip git \
    && mkdir -p /opt/l2j/server && mkdir -p /opt/l2j/target && cd /opt/l2j/target/ \
    && git clone --branch master --single-branch https://github.com/PhillConrado/l2Ice-server-cli.git cli \
    && git clone --branch master --single-branch https://github.com/PhillConrado/l2Ice-server-login.git login \
    && git clone --branch master --single-branch https://github.com/PhillConrado/l2Ice-server-game.git game \
    && git clone --branch master --single-branch https://github.com/PhillConrado/l2Ice-server-datapack.git datapack \
    && cd /opt/l2j/target/cli && chmod 755 mvnw && ./mvnw install \
    && cd /opt/l2j/target/login && chmod 755 mvnw && ./mvnw install \
    && cd /opt/l2j/target/game && chmod 755 mvnw && ./mvnw install \
    && cd /opt/l2j/target/datapack && chmod 755 mvnw && ./mvnw install \
    && unzip /opt/l2j/target/cli/target/*.zip -d /opt/l2j/server/cli \
    && unzip /opt/l2j/target/login/target/*.zip -d /opt/l2j/server/login \
    && unzip /opt/l2j/target/game/target/*.zip -d /opt/l2j/server/game \
    && unzip /opt/l2j/target/datapack/target/*.zip -d /opt/l2j/server/game \
    && rm -rf /opt/l2j/target/ && apk del maven git \
    && chmod +x /opt/l2j/server/cli/*.sh /opt/l2j/server/game/*.sh /opt/l2j/server/login/*.sh /entrypoint.sh


WORKDIR /opt/l2j/server

EXPOSE 7777 2106

ENTRYPOINT [ "/entrypoint.sh" ]