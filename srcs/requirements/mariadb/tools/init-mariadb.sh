#!/bin/sh
# set -x

echo "Starting init-mariadb.sh"

# 네트워크 연결 없이 서버 시작
mysqld_safe --skip-networking --nowatch

# 서버 시작할 때까지 대기
while ! mysqladmin ping --silent; do
    sleep 1
done

# 환경변수 적용 체크
if [ -z "${MYSQL_ROOT_PASSWORD}" ] || [ -z "${MYSQL_DATABASE}" ] || [ -z "${MYSQL_USER}" ] || [ -z "${MYSQL_PASSWORD}" ]; then
    echo >&2 'error: MYSQL_ROOT_PASSWORD not set'
    echo >&2 '  Did you forget to add -e MYSQL_ROOT_PASSWORD=... ?'
    exit 1
fi

# 데이터베이스 확인
DB_EXISTS=$(mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SHOW DATABASES LIKE '${MYSQL_DATABASE}';" | grep "${MYSQL_DATABASE}" > /dev/null; echo "$?")

# 없으면
if [ $DB_EXISTS -ne 0 ]; then
    cat << EOF > /tmp/init.sql
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    chown mysql:mysql /tmp/init.sql
    chmod 600 /tmp/init.sql
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" < /tmp/init.sql
    rm /tmp/init.sql
fi

mysqladmin shutdown

exec mysqld_safe
