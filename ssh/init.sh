#!/usr/bin/env bash
# ---
# UnhandledPerfection - www.unhandledperfection.com
# docker-ssh https://github.com/unhandledperfection/docker-ssh
# ---
# Example initializing alpine container for ssh key based connections to root.

set -e

# --- Vars
ROOT_DIR=/docker-ssh
FILE_ID_RSA_PUB="${ROOT_DIR}/id_rsa.pub"
FILE_SSHD_CONFIG="${ROOT_DIR}/sshd_config"
# ---

# --- Methods
file_exists_validation()
{
  FILEPATH=$1
  if [ ! -f "$FILEPATH" ]; then
    echo "$FILEPATH does not exist."
  fi
}

pretty_print()
{
  MSG=$1
  echo "--- DockerSSH - $MSG"
}
# ---

# Validate required files
file_exists_validation $FILE_SSHD_CONFIG
file_exists_validation $FILE_ID_RSA_PUB

pretty_print "Unlocking root account"
usermod -p '' root

# Generate Host keys, if required
if ! ls /etc/ssh/keys/ssh_host_* 1> /dev/null 2>&1; then
  pretty_print "Creating host keys"
  mkdir -p /etc/ssh/keys
  ssh-keygen -A
  mv /etc/ssh/ssh_host_* /etc/ssh/keys/
fi

pretty_print "Setting key permissions"
mkdir -p ~root/.ssh /etc/authorized_keys
chmod 700 ~root/.ssh/

pretty_print "Setting authorized keys"
cat ${FILE_ID_RSA_PUB} > /root/.ssh/authorized_keys
chown root:root ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

pretty_print "Setting sshd config"
cp ${FILE_SSHD_CONFIG} /etc/ssh/sshd_config

exec "$@"
