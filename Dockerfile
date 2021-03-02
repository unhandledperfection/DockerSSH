# UnhandledPerfection - www.unhandledperfection.com
# docker-ssh https://github.com/unhandledperfection/docker-ssh
# ---
# Example initializing alpine container for ssh key based connections to root.

FROM alpine

# --- DockerSSH
ARG SSH_PUBLIC_KEY
WORKDIR /docker-ssh
COPY ./ssh/init.sh .
COPY ./ssh/sshd_config .
RUN echo $SSH_PUBLIC_KEY > ./id_rsa.pub

RUN apk update && apk add bash openssh shadow && rm -rf /var/cache/apk/*

EXPOSE 22
ENTRYPOINT ["./init.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
# ---
