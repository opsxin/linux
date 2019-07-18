```bash
.
├── README.md
├── ansible
│   ├── roles
│   │   └── compile-nginx
│   │       ├── defaults
│   │       │   └── main.yml
│   │       ├── files
│   │       │   ├── OpenSSL_1_1_1c.tgz
│   │       │   ├── nginx-1.16.0.tgz
│   │       │   ├── pcre-8.43.tgz
│   │       │   └── zlib-1.2.11.tgz
│   │       ├── handlers
│   │       │   └── main.yml
│   │       ├── tasks
│   │       │   ├── Debian-dependent-software.yml
│   │       │   ├── RedHat-dependent-software.yml
│   │       │   ├── compiler-nginx.yml
│   │       │   ├── config-nginx.yml
│   │       │   ├── main.yml
│   │       │   ├── systemd.yml
│   │       │   └── unarchive-file.yml
│   │       ├── templates
│   │       │   ├── default_server.conf.j2
│   │       │   ├── nginx.conf.j2
│   │       │   └── nginx.service.j2
│   │       └── vars
│   │           ├── Debian.yml
│   │           └── RedHat.yml
│   └── ssh-keygen-copy
│       ├── passwd.txt
│       ├── ssh-login-2.sh
│       └── ssh-login.sh
├── docker
│   ├── aria2
│   │   ├── docker-compose
│   │   │   ├── README.md
│   │   │   ├── aria2.conf
│   │   │   ├── docker-compose.yml
│   │   │   ├── dockerfile-aria2
│   │   │   ├── dockerfile-h5ai
│   │   │   └── nginx-default.conf
│   │   └── dockerfile
│   │       ├── Dockerfile
│   │       ├── README.md
│   │       ├── aria2.conf
│   │       ├── nginx-default.conf
│   │       └── service.sh
│   └── debian-ssh
│       └── debian-ssh.dockerfile
├── nginx
│   ├── conf
│   │   ├── google.conf
│   │   ├── wiki-m.conf
│   │   └── wiki.conf
│   └── deny
│       └── deny-agent.conf
├── script
│   ├── bash
│   │   ├── domain-cert-dingding.sh
│   │   ├── jenkins-deploy.sh
│   │   ├── send-msg-to-wechat.sh
│   │   ├── service.sh
│   │   ├── split-nginx-logs.sh
│   │   ├── watch-sys.sh
│   │   └── whois-dingding.sh
│   ├── install-software
│   │   ├── README.md
│   │   ├── script
│   │   │   ├── install-docker.sh
│   │   │   ├── install-java7.sh
│   │   │   ├── install-mysql57.sh
│   │   │   ├── install-nginx.sh
│   │   │   └── install-php56.sh
│   │   └── start.sh
│   └── python
│       └── xiaoshuo
│           ├── fiction-latest-chapter.py
│           ├── latest-essay.cfg
│           └── requirements.txt
├── service
│   ├── nginx.service
│   ├── php.service
│   └── tomcat.service
└── update-readme.sh

25 directories, 59 files
```
