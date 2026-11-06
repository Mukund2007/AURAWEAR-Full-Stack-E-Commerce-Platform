#!/bin/bash
set -e

echo "[AuraWear] Initializing local database service..."

# Configure MariaDB for low-memory footprint (<50MB) to stay well within Render limits
mkdir -p /etc/mysql/mariadb.conf.d
cat <<EOF > /etc/mysql/mariadb.conf.d/99-aurawear.cnf
[mysqld]
key_buffer_size = 16M
max_connections = 25
innodb_buffer_pool_size = 32M
innodb_log_buffer_size = 4M
innodb_flush_log_at_trx_commit = 2
skip-name-resolve
EOF

# Ensure proper socket and data directory permissions
mkdir -p /var/run/mysqld /var/lib/mysql
chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

# Initialize data directory if not already created
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[AuraWear] Setting up initial MariaDB system tables..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1 || mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1
fi

# Start MariaDB service
service mariadb start || /etc/init.d/mariadb start || service mysql start

# Wait for local MySQL to be ready
echo "[AuraWear] Waiting for MariaDB socket..."
for i in {1..20}; do
    if mysqladmin ping --silent 2>/dev/null; then
        echo "[AuraWear] MariaDB socket is ready."
        break
    fi
    sleep 1
done

# Initialize database, user and permissions
mysql -u root <<EOF 2>/dev/null || true
CREATE DATABASE IF NOT EXISTS aurawear CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY 'Root1234';
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Root1234';
CREATE USER IF NOT EXISTS 'root'@'127.0.0.1' IDENTIFIED BY 'Root1234';
ALTER USER 'root'@'127.0.0.1' IDENTIFIED BY 'Root1234';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "[AuraWear] Embedded MariaDB is initialized and listening on 3306."
echo "[AuraWear] Starting Apache Tomcat application server..."

exec catalina.sh run
