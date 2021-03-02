# About
Simple demo on how to SSH into your alpine container. 
The original motivation was configuring the remote interpeter within the container for xDebug / IntelliJ connectivity.

# Quick Start (docker)
## Build
```
# for bash
SSH_PUBLIC_KEY_PATH='./id_rsa.pub'; # <--- update path
SSH_PUBLIC_KEY=$(cat "${SSH_PUBLIC_KEY_PATH}");
docker build -f Dockerfile -t docker-ssh --build-arg SSH_PUBLIC_KEY="${SSH_PUBLIC_KEY}" .;

# for powershell
Set-Variable -Name 'SSH_PUBLIC_KEY_PATH' -Value './id_rsa.pub'; # <--- update path
Set-Variable -Name 'SSH_PUBLIC_KEY' -Value (Get-Content $SSH_PUBLIC_KEY_PATH);
docker build -f Dockerfile -t docker-ssh --build-arg SSH_PUBLIC_KEY=$SSH_PUBLIC_KEY .;


```

## Run
```
docker run --rm -i -p 2222:22 docker-ssh
```

## Connect
Connect through SSH
```
  host: localhost
  port: 2222
  username: root
  ssh secret key: use the associated secret
```

---

# Quick Start (docker-compose)
## Build & Run
```
# for powershell
Set-Variable -Name 'SSH_PUBLIC_KEY_PATH' -Value './id_rsa.pub'; # <--- update path
docker-compose build --build-arg SSH_PUBLIC_KEY="(Get-Content "$($SSH_PUBLIC_KEY_PATH)")";

# for bash
SSH_PUBLIC_KEY_PATH='./id_rsa.pub'; # <--- update path
docker-compose build --build-arg SSH_PUBLIC_KEY=$(cat "${SSH_PUBLIC_KEY_PATH}");
```

## Connect
Connect through SSH
```
  host: localhost
  port: 2222
  username: root
  ssh secret key: use the associated secret
```

## Improved workflow
Using docker-compose you can hardcode your public key within the docker-compose.yml file.
```
services:
  docker-ssh:
    container_name: docker-ssh
    build:
      context: ./
      dockerfile: ./Dockerfile
      args:                                              # <------ add this
        SSH_PUBLIC_KEY: "ssh-rsa ... xx@DESKTOP-BJO1NC2" # <------ add this
```

---

# Integrate ssh access to your project containers
**1. Copy files**
  - Copy the ./ssh folder into your project.

**2. Dockerfile**
  - Include the content of Dockerfile into your Dockerfile.
  - If ./ssh is not at the root. Update the corresponding paths in the Dockerfile.

**3. Open ports**
  - Create a port mapping to access port 22 on your container.
  - Here we open port 2222 to map to internal port "2222:22".

---

# Dependencies
  * docker
  * docker-compose
