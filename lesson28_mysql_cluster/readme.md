# mysql cluster

развернуть InnoDB кластер в docker 

в качестве ДЗ принимает репозиторий с docker-compose
который по кнопке разворачивает кластер и выдает порт наружу



## полезное

тестовый стенд - https://github.com/dmitry-lyutenko/innodb-cluster

innodb cluster - https://dev.mysql.com/doc/refman/8.0/en/mysql-innodb-cluster-introduction.html

mysql shell - https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-install-linux-quick.html

mysql router - https://dev.mysql.com/doc/mysql-router/8.0/en/

### ДЗ

ставлю **docker-compose**: 

https://docs.docker.com/compose/install/



**mysql-shell** 

создаю контейнер **mysql-shell-batch** из Dockerfile - делает запуск js скрипта  для инициализации кластера и добавления нод в кластер + добавляет тестовую базу 

```
docker build -t pool80/mysql-shell-batch:0.1 .
docker login
docker push pool80/mysql-shell-batch
```



**mysql-shell-batch** 

папка со скриптом js и тестовой базой примонтирована в контейнер



**mysql-router** 

проброс порта  **6446**



**запуск** кластера

```
docker-compose up -d
```



проверка **статуса** кластера

```
docker exec -ti mysql-shell-batch bash
mysqlsh --uri root@mysql-shell-batch -e "dba.getCluster().status()"
```



**подключение** к кластеру

```
mysql -u root -pmysql -P6446 -h 127.0.0.1
```

