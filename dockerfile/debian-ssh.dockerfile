FROM debian:latest

RUN apt-get update && apt-get install -y \
    openssh-server \
    python \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'root:passwd' | chpasswd
RUN sed -i 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN mkdir /var/run/sshd 

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

