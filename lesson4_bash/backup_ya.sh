#!/usr/bin/env bash

timestamp="`date +'%d_%m_%Y'`" #Получить текущую дату
backupdir="/root/backup" #каталог для бэкапов
srcdir="/var/www" #что бэкапируем
mysqlhost="127.0.0.1" #хост мускула
mysqluser="user"
mysqlpass="pass"
dbname="test" # имя базы данных


#отправка почты
mailError(){
echo "Лог ошибки" | mailx -s "Ошибка резервного копирования" -A ~/logs/error.log oleg@pool80.ru
}

#лог ошибок
checkErr(){
echo $timestamp $1 >> ~/logs/error.log
mailError
}


#бэкап mysql
mysqldump -h $mysqlhost -u $mysqluser -p $mysqlpass >$backupdir/backup_$timestamp.sql
if [[ $? -gt 0 ]];then
checkErr "Резервное копирование базы данных завершилось ошибкой"
exit 1
fi
#бэкап сайта
tar -czpf $backupdir/backup_$timestamp.tar.gz $srcdir
if [[ $? -gt 0 ]];then
checkErr "Резервное копирование сайта завершилось ошибкой"
exit 1
fi

#отправка бэкапов на яндекс диск
curl -T $backupdir/backup_$timestamp.sql --user "user:passwd" https://webdav.yandex.ru/backup_$timestamp.sql
if [[ $? -gt 0 ]];then
checkErr "Ошибка отправки бэкапа мускула"
exit 1
fi

curl -T $backupdir/backup_$timestamp.tar.gz --user "user:passwd" https://webdav.yandex.ru/backup_$timestamp.tar.gz
if [[ $? -gt 0 ]];then
checkErr "Ошибка отправки бэкапа сайта"
exit 1
fi

#удаляем бэкапы старше одного месяца с я.диска
var=`find $backupdir -mmin +43200 | awk -F/ '{print$5}'` #сканируем файлы старше одного месяца
for i in ${var[@]}
do
curl -X DELETE --user "user:passwd" https://webdav.yandex.ru/$i #удаление старого архива с я.диска
done

#удаляем бэкапы старше одного месяца с диска
find $backupdir -mmin +43200 -exec rm {} +