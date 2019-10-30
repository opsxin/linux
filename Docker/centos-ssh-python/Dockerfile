FROM centos:latest
LABEL Maintainer="hsin" Version="1.0" Password="123456" \
    Description="latest centos, install ssh and python" 

RUN yum makecache && yum install -y \
    openssh-server python2 \
    && yum clean all

# 生成 HostKey
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '' \
    && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
    && ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
 
RUN sed -i -e "s/UsePAM yes/UsePAM no/" \
    -e 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config  

RUN echo "root:123456" | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

