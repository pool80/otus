## mysql cluster

#### Домашнее задание

развернуть InnoDB кластер в docker 

в качестве ДЗ принимает репозиторий с docker-compose
который по кнопке разворачивает кластер и выдает порт наружу



ставлю docker-compose: 

https://docs.docker.com/compose/install/



mysql-shell: создаю контейнер mysql-shell-batch из Dockerfile: делает запуск js скрипта  для инициализации кластера и добавления нод в кластер + добавляет тестовую базу 

```
docker build -t pool80/mysql-shell-batch:0.1 .
docker login
docker push pool80/mysql-shell-batch
```



mysql-shell-batch: папка со скриптом js и тестовой базой примонтирована в контейнер



mysql-router: проброс порта  6446



запуск кластера:

```
docker-compose up -d
```



проверка статуса кластера:

```
docker exec -ti mysql-shell-batch bash
mysqlsh --uri root@mysql-shell-batch -e "dba.getCluster().status()"
```



подключение к кластеру:

```
mysql -u root -pmysql -P6446 -h 127.0.0.1
```

