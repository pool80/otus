Управление пакетами. Дистрибьюция софта.
----------------------------------------
    Для создания своего репозитория использую 
    2 виртуальные машины Centos7 Vagrant boxes
    
сервер https://yadi.sk/d/qdnerL4NDKCJjw
    
клиент https://yadi.sk/d/DFsCTt0YFVrGiQ
    
    Для обьединения машин в Vagrantfile добавил параметры:
    
    сервер    
    config.vm.network "public_network", ip: "192.168.88.50"
    
    клиент
    config.vm.network "public_network", ip: "192.168.88.51"

    Создаю RPM и собираю репозиторий на веб-сервере Caddy

yum -y install epel-release golang lynx

yum install -y \redhat-lsb-core \wget \rpmdevtools \rpm-build \createrepo \yum-utils

wget https://download-ib01.fedoraproject.org/pub/epel/7/SRPMS/Packages/c/caddy-0.11.1-2.el7.src.rpm

rpm -i caddy-0.11.1-2.el7.src.rpm

yum-builddep rpmbuild/SPECS/caddy.spec

rpmbuild -bb rpmbuild/SPECS/caddy.spec

yum localinstall -y rpmbuild/RPMS/x86_64/caddy-0.11.1-2.el7.x86_64.rpm

systemctl enable --now caddy.service

systemctl status caddy

mkdir usr/share/caddy/repo

cp rpmbuild/RPMS/x86_64/caddy-0.11.1-2.el7.x86_64.rpm /usr/share/caddy/repo/caddy-0.11.1-2.el7.x86_64.rpm

createrepo /usr/share/caddy/repo

yum -y update

    browse - добавляем доступ к листингу каталога в caddy.conf

vi /etc/caddy/caddy.conf

<details>
<summary><code>caddy.conf</code></summary>

    :80 {
        gzip
        root /usr/share/caddy
        browse
    }

    import conf.d/*.conf

</details>

systemctl restart caddy

    добавляем репозиторий

vi  /etc/yum.repos.d/otus.repo
    
<details>
<summary><code>otus.repo</code></summary>
    
    [otus]
    name=otus-linux
    baseurl=http://localhost/repo
    gpgcheck=0
    enabled=1
    
</details>

    открываю 80 порт

iptables -I INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT

    теперь запускаю клиентскую машину, проверяю пинг, подключаю репозиторий

<details>
<summary><code>otus.repo</code></summary>
    
    [otus]
    name=otus-linux
    baseurl=http://192.168.88.50/repo
    gpgcheck=0
    enabled=1
    
</details>

    устанавливаю caddy из репозитория Otus