Загрузка системы
-----------------

1. Попасть в систему без пароля несколькими способами

* init=/bin/sh

    Добавить init=/bin/sh в конце строки начинающейся с linux16
![](pic/bin_sh.png)

    Перемонтируем систему в Read-Write
    Проверить mount | grep root
![](pic/bin_sh1.png)

* rd.break

    В конце строки начинающейся с linux16 добавляем rd.break и нажимаем сtrl-x для загрузки в систему
![](pic/rd.break.png)

    Попадаем в emergency mode. Перемонтируем систему в Read-Write, меняем пароль
![](pic/rd.break1.png)

* rw init=/sysroot/bin/sh

    Заменить ro на rw init=/sysroot/bin/sh
![](pic/rw_init.png)

    Сделать chroot /sysroot, сменить passwd, touch /.autorelabel
![](pic/rw_init1.png)

    В способах c rd.break и rw init=/sysroot/bin/sh после перезагрузки из терминала система зависала и требовала 
    перезагрузки из интерфейса  virtual box или VMware, после чего нормально стартовала.

 
2. Установить систему с LVM, после чего переименовать VG

    https://asciinema.org/a/cJaeBiEgPHw2f8v0BP7oS1VDT

3. Добавить модуль в initrd

* Разместить 2 скрипта в /usr/lib/dracut/modules.d/
    <details>
    <summary><code>module-setup.sh</code></summary>
    
    ```
    #!/bin/bash
    
    check() {
        return 0
    }
    
    depends() {
        return 0
    }
    
    install() {
        inst_hook cleanup 00 "${moddir}/test.sh"
    }
    ```
    </details>

    <details>
    <summary><code>test.sh</code></summary>
        
    ```
    #!/bin/bash
    
    exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
    cat <<'msgend'
    
    Hello! You are in dracut module!
    
     ___________________
    < I'm Tux >
     -------------------
       \
        \
            .--.
           |o_o |
           |:_/ |
          //   \ \
         (|     | )
        /'\_   _/`\
        \___)=(___/
    msgend
    sleep 10
    echo " continuing...."
    ```  
    </details>

    Пересобрать образ initrd 
    mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

    Посмотреть модули dracut
    lsinitrd -m /boot/initramfs-$(uname -r).img | grep test

    Убрать опции rghb и quiet в grub.cfg.

![](pic/dracut_hello.jpg)