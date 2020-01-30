FROM omnidapps/nvim:alpine

LABEL maintainer="Josh Santos <josh@omnidapps.com>"

USER root
COPY sshd_config /etc/ssh/sshd_config
COPY tmux.conf $UHOME/.tmux.conf

RUN echo "http://nl.alpinelinux.org/alpine/edge/testing" \
    >> /etc/apk/repositories \
    && echo "http://nl.alpinelinux.org/alpine/edge/community" \
    >> /etc/apk/repositories \
    && apk --no-cache add \
    bash \
    curl \
    git \
    htop \
    libseccomp \
    mosh-server \
    openrc \
    openssh \
    openssh-server-pam \
    tmux \
    py2-pip

RUN rc-update add sshd \
    && rc-status \
    && touch /run/openrc/softlevel \
    && /etc/init.d/sshd start > /dev/null 2>&1 \
    && /etc/init.d/sshd stop > /dev/null 2>&1 \
    && rm /etc/ssh/ssh_host_*key* \
    && ssh-keygen -A

#              ssh   mosh
EXPOSE 80 8080 62222 60001/udp

COPY start.bash /usr/local/bin/start.bash
ENTRYPOINT ["bash", "/usr/local/bin/start.bash"]
