mysql -u root -e "CREATE DATABASE [IF NOT EXISTS] is311;"
mysql -u root is311 < movies.sql
mysql -u root is311 -e "SELECT * from movies limit 1"
