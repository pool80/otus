## Systemd

1. Написать сервис, который будет раз в 30 секунд мониторить лог на 
    предмет наличия ключевого слова. Файл и слово должны задаваться в 
    /etc/sysconfig
2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.
3. Дополнить юнит-файл apache httpd возможность запустить несколько инстансов сервера с разными конфигами

Реализовано через Vagrantfile, который делает rsync  необходимых файлов и скриптов в папку /Vagrant. Далее через inline shell скрипты запускают копирование файлов в нужные директории и стартует необходимые сервисы.

ps

Пытался рсинкнуть файлы сразу в / гостевой машины, но Vagrant постоянно отказывался это делать. Спотыкается на папке /etc. Внятной документации не нашел.