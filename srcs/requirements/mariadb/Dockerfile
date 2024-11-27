# 이미지
FROM debian:bullseye

# 패키지, MariaDB 설치
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client

# MariaDB 설정
COPY ./conf/mariadb.cnf /etc/mysql/my.cnf

# 디레토리 생성 + 권한설정
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 755 /var/run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql && \
    chmod 755 /var/lib/mysql && \
    mkdir -p /var/log/mysql && \
    chown -R mysql:mysql /var/log/mysql && \
    chmod 755 /var/log/mysql

# init 스트립트 복사
COPY ./tools/init-mariadb.sh /init-mariadb.sh
RUN chmod +x /init-mariadb.sh

ENTRYPOINT ["/init-mariadb.sh" ]
