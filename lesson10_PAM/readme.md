## Пользователи и группы. Авторизация и аутентификация

PAM
1. Запретить всем пользователям, кроме группы admin логин в выходные и праздничные дни

Добавляю группу admin 

```
groupadd admin
```
Создаю и добавляю пользователя dima в группу admin

```
useradd -G admin dima
```

Поскольку модуль pam_time.so не работает с группами пользователей, пришлось использовать обходное решение:

Всем запретить выход в выходные  в файле /etc/security/time.conf 

```
login;*;*;Wk0000-2400
```

В файле /etc/pam.d/login использовать опцию модуля pam_succeed_if.so - user ingroup + добавить модуль pam_time.so

```
account    [success=1 default=ignore] pam_succeed_if.so user ingroup admin
account    required     pam_time.so
```

К сожалению нельзя задать праздичные дни с помощью pam_time.so , поэтому устанавливаю:

```
yum install pam_script -y
```

Добавляю в  /etc/pam.d/login

```
account    required     pam_script.so
```

Создаю файл /etc/pam-script.d/prazdniki_acct

```
#!/usr/bin/env bash

holidays=(3012 3112 0101 0201 0301 0401 0501 0601 0701 0801 2302 2402 0803
0903 1003 0105 0205 0305 0405 0505 0905 1005 1105 1205 1206 0211 0311 0411)

if [[ ! $(groups "$PAM_USER" | grep admin) ]]
    then 
        if [[ ${holidays[*]}  =~  $(date +%d%m) ]]
            then
                exit 1
        fi
else
    exit 0
fi


```

В результате пользователь dima может логиниться в любые дни, а пользователи вне группы admin не могут логиниться в выходные и праздники.


2. Дать конкретному пользователю права рута 

В папке создаем файл /etc/sudoers.d/dima

```
dima ALL=(ALL) NOPASSWD: ALL
```

Пользователь dima после логина набирает sudo -s и получает права root.