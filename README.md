# Docker container for keepalived

[![Docker Automated build](https://img.shields.io/badge/docker%20build-automated-brightgreen)](https://github.com/shawly/docker-keepalived/actions) [![GitHub Workflow Status](https://img.shields.io/github/workflow/status/shawly/docker-keepalived/Docker)](https://github.com/shawly/docker-keepalived/actions) [![Docker Pulls](https://img.shields.io/docker/pulls/shawly/keepalived)](https://hub.docker.com/r/shawly/keepalived) [![Docker Image Size (tag)](https://img.shields.io/docker/image-size/shawly/keepalived/latest)](https://hub.docker.com/r/shawly/keepalived)

This is a Docker container for [keepalived](https://github.com/acassen/keepalived).

---

[![keepalived](/docs/img/keepalived-logo.png)](https://www.keepalived.org/)

---

## Table of Content

- [Docker container for keepalived](#docker-container-for-keepalived)
  - [Table of Content](#table-of-content)
  - [Supported tags](#supported-tags)
  - [Image Variants](#image-variants)
  - [Supported Architectures](#supported-architectures)
  - [Quick Start](#quick-start)
  - [Usage](#usage)
    - [Environment Variables](#environment-variables)
    - [Changing Parameters of a Running Container](#changing-parameters-of-a-running-container)
  - [Docker Compose File](#docker-compose-file)
  - [Docker Image Update](#docker-image-update)
  - [Using a custom keepalived.conf](#using-a-custom-keepalivedconf)
  - [Sending email notifications](#sending-email-notifications)
  - [Controlling the docker daemon](#controlling-the-docker-daemon)
  - [Support](#support)
  - [Credits](#credits)

## Supported tags

<!-- supported tags will be auto updated through workflows! -->

- `edge`, `edge-be7adde`, `edge-be7adde0353bc47af3f4fef851a4c31ad04802ac` <!-- edge tag -->
- `latest`, `2`, `2.2`, `2.2.8` <!-- latest tag -->

## Image Variants

This image comes in two different variants.

### `shawly/keepalived:<version>`

This image represents a stable or considered "working" build of keepalived and should be preferred.

### `shawly/keepalived:edge-<commitsha>`

This image represents a development state of this repo. It contains the latest features but is not considered stable, it can contain bugs and breaking changes.
If you are not sure what to choose, use the `latest` image or a version like `2` or `2.2`.

## Supported Architectures

The architectures supported by this image are:

| Architecture | Status   |
| :----------: | -------- |
|    x86-64    | working  |
|    arm64     | untested |
|    armv7     | untested |
|    armhf     | untested |

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

Launch the keepalived docker container with the following command:

```bash
docker run -d \
    --name=keepalived \
    --cap-add=NET_ADMIN \
    --cap-add=NET_BROADCAST \
    --net host \
    -e KEEPALIVED_VIRTUAL_IP=10.11.12.99 \
    -e KEEPALIVED_CHECK_PORT=443 \
    -e KEEPALIVED_VIRTUAL_MASK=24 \
    -e KEEPALIVED_VRID=99 \
    shawly/keepalived
```

## Usage

```
docker run [-d] \
    --name=keepalived \
    [-e <VARIABLE_NAME>=<VALUE>]... \
    [-v <HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS]]... \
    [-p <HOST_PORT>:<CONTAINER_PORT>]... \
    shawly/keepalived
```

| Parameter | Description                                                                                                                                              |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| -d        | Run the container in background. If not set, the container runs in foreground.                                                                           |
| -e        | Pass an environment variable to the container. See the [Environment Variables](#environment-variables) section for more details.                         |
| -v        | Set a volume mapping (allows to share a folder/file between the host and the container). See the [Data Volumes](#data-volumes) section for more details. |
| -p        | Set a network port mapping (exposes an internal container port to the host). See the [Ports](#ports) section for more details.                           |

### Environment Variables

To customize some properties of the container, the following environment
variables can be passed via the `-e` parameter (one for each variable). Value
of this parameter has the format `<VARIABLE_NAME>=<VALUE>`.

| Variable                   | Description                                                                                                                                                                                                                                            | Default   |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------- |
| `TZ`                       | Timezone of the container. Timezone can also be set by mapping `/etc/localtime` between the host and the container.                                                                                                                                    | `Etc/UTC` |
| `KEEPALIVED_VIRTUAL_IP`    | Floating IP that is used by keepalived                                                                                                                                                                                                                 | undefined |
| `KEEPALIVED_VIRTUAL_MASK`  | Subnet mask of the floating IP (e.g. `24`)                                                                                                                                                                                                             | undefined |
| `KEEPALIVED_CHECK_IP`      | Set this to a specific IP if you only want to check `KEEPALIVED_CHECK_PORT` on the given IP address                                                                                                                                                    | `any`     |
| `KEEPALIVED_CHECK_PORT`    | Set this to the port you want to check                                                                                                                                                                                                                 | undefined |
| `KEEPALIVED_VRID`          | The virtual router id                                                                                                                                                                                                                                  | undefined |
| `KEEPALIVED_INTERFACE`     | Interface on your host e.g. `eth0` (use `ip -br l` to list all your interfaces). `auto` automatically determines which interface to use based on set `KEEPALIVED_VIRTUAL_IP` and `KEEPALIVED_VIRTUAL_MASK`.                                            | `auto`    |
| `KEEPALIVED_CHECK_SCRIPT`  | You can set a custom script that is used for checking if a host is alive                                                                                                                                                                               | undefined |
| `KEEPALIVED_CUSTOM_CONFIG` | If you set this to `true` the configuration `/etc/keepalived/keepalived.conf` will not be set up automatically. Use this if you want to customize your keepalived.conf manually (see [Using a custom keepalived.conf](#using-a-custom-keepalivedconf)) | `false`   |

### Changing Parameters of a Running Container

As seen, environment variables, volume mappings and port mappings are specified
while creating the container.

The following steps describe the method used to add, remove or update
parameter(s) of an existing container. The generic idea is to destroy and
re-create the container:

1. Stop the container (if it is running):

```
docker stop keepalived
```

2. Remove the container:

```
docker rm keepalived
```

3. Create/start the container using the `docker run` command, by adjusting
   parameters as needed.

## Docker Compose File

Here is an example of a `docker-compose.yml` file that can be used with
[Docker Compose](https://docs.docker.com/compose/overview/).

Make sure to adjust according to your needs. Note that only mandatory network
ports are part of the example.

```yaml
version: "3"
services:
  keepalived:
    image: shawly/keepalived
    environment:
      TZ: Europe/Berlin
      KEEPALIVED_VIRTUAL_IP: 172.17.8.150
      KEEPALIVED_VIRTUAL_MASK: 24
      KEEPALIVED_CHECK_IP: any
      KEEPALIVED_CHECK_PORT: 80
      KEEPALIVED_VRID: 150
      KEEPALIVED_INTERFACE: eth0
    network_mode: host
    cap_add:
      - NET_ADMIN
      - NET_BROADCAST
```

## Docker Image Update

If the system on which the container runs doesn't provide a way to easily update
the Docker image, the following steps can be followed:

1. Fetch the latest image:

```
docker pull shawly/keepalived
```

2. Stop the container:

```
docker stop keepalived
```

3. Remove the container:

```
docker rm keepalived
```

4. Start the container using the `docker run` command.

## Using a custom keepalived.conf

If you want to mount a custom configuration, you need to set the environment variable `KEEPALIVED_CUSTOM_CONFIG=true`.

This will stop the `init-kepalived-config` service from applying the values from environment variables and checking them for validity.

This means you need to set IPs, scripts etc. in your custom config!

You can find a lot of example configurations [here](https://github.com/acassen/keepalived/tree/master/doc/samples).

### Example with `docker run`

Create a `keepalived.conf` with your configuration and mount it to `/etc/keepalived/keepalived.conf`. The file needs to exist before mounting!

```bash
docker run -d \
    --name=keepalived \
    --cap-add=NET_ADMIN \
    --cap-add=NET_BROADCAST \
    --net host \
    -e TZ=Europe/Berlin \
    -e KEEPALIVED_CUSTOM_CONFIG=true \
    -v "$(pwd)/keepalived.conf:/etc/keepalived/keepalived.conf:ro" \
    shawly/keepalived
```

### Example `docker-compose.yml`

If you use the environment property with a map instead of a list, make sure to wrap the `true` value in double quotes like shown in the example below!

```yaml
version: "3"
services:
  keepalived:
    image: shawly/keepalived
    environment:
      TZ: Europe/Berlin
      KEEPALIVED_CUSTOM_CONFIG: "true"
    network_mode: host
    cap_add:
      - NET_ADMIN
      - NET_BROADCAST
    volumes:
      # mount the conf as read only, so it can't be modified from within the container for additional security
      - "./keepalived.conf:/etc/keepalived/keepalived.conf:ro"
```

## Sending email notifications

This container contains `msmtp` and `mailx` so you can send email notifications via keepalived.

For that you need to mount msmtprc config in the container under `/root/.msmtprc`. Create a file `msmtprc`:

```
# Set default values for all following accounts.
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
syslog         on

# Gmail
account        gmail
host           smtp.gmail.com
port           587
from           yourgmail+keepalived@gmail.com
user           yourgmail@gmail.com
password       <your app password>

# Set a default account
account default : gmail
aliases        /etc/aliases
```

And setup an alias for your root user in `/etc/aliases` in the container. Create a file `mail-aliases`:

```
root: yourgmail+keepalived@gmail.com
default: yourgmail+keepalived@gmail.com
```

I recommend to use the `+keepalived` alias so you can easily filter emails, but it's up to you. Your mail provider/server should support this though if you are not using gmail.

The default config doesn't have any mail notifications configured, so you are requried to create and use a custom `keepalived.conf` [as described above](#using-a-custom-keepalivedconf).

To use the `msmtpd` that pipes mails to `msmtp`, you need to send your mails to `localhost` on port `25` in your `keepalived.conf`, like this:

```
global_defs {
  notification_email {
    acassen
  }
  notification_email_from yourgmail+keepalived@gmail.com
  smtp_server 127.0.0.1 25
  smtp_connect_timeout 30
  router_id EXAMPLE
}
```

**Note:** The mail server only listens on `127.0.0.1` port `25` by default which should not be changed and port `25` should never be opened to the public!  
**NEVER** configure your mail server directly in the `keepalived.conf`! It has no support for encryption or any security features, that's why you need to pipe your e-mails through msmtp which act's as a relay and supports TLS/SSL.

### Example with `docker run`

```bash
docker run -d \
    --name=keepalived \
    --cap-add=NET_ADMIN \
    --cap-add=NET_BROADCAST \
    --net host \
    -e TZ=Europe/Berlin \
    -e KEEPALIVED_CUSTOM_CONFIG=true \
    -v "$(pwd)/keepalived.conf:/etc/keepalived/keepalived.conf:ro" \
    -v "$(pwd)/msmtprc:/root/.msmtprc:ro" \
    -v "$(pwd)/mail-aliases:/etc/aliases:ro" \
    shawly/keepalived
```

### Example `docker-compose.yml`

```yaml
version: "3"
services:
  keepalived:
    image: shawly/keepalived
    environment:
      TZ: Europe/Berlin
      KEEPALIVED_CUSTOM_CONFIG: "true"
    network_mode: host
    cap_add:
      - NET_ADMIN
      - NET_BROADCAST
    volumes:
      # mount the files as read only, so it can't be modified from within the container for additional security
      - "./keepalived.conf:/etc/keepalived/keepalived.conf:ro"
      - "./msmtprc:/root/.msmtprc:ro"
      - "./mail-aliases:/etc/aliases:ro"
```

## Controlling the Docker daemon

If you want to control containers on your host, you can mount `/var/run/docker.sock` into your `keepalived` container.

This will allow you to take control of the containers on your host via `notify` scripts defined in your `keepalived.conf`.

An example `notify` script:

```bash
#!/usr/bin/env bash

TYPE=$1
NAME=$2
STATE=$3

nginx_start () {
  docker start nginx
}

nginx_stop () {
  docker stop nginx
}

logger "starting nginx notify"
case $STATE in
     "MASTER")
        touch "/etc/keepalived/MASTER"
        # mark node as master and start Nginx, if it is not running. Do nothing, if Nginx is ok
        logger "MASTER state"
        docker ps -f name=nginx | grep nginx >/dev/null 2>&1
        NGINX_RUN_STATE=$?
        if [ "$NGINX_RUN_STATE" -eq 0 ]; then
          logger "nginx is RUNNING, no action necessary"
        else
          logger "nginx is NOT RUNNING, starting nginx"
          nginx_start
        fi
        exit 0
        ;;
     "BACKUP")
        rm "/etc/keepalived/MASTER"

        logger "nginx BACKUP state"
        if [ "$(docker inspect -f "{{.State.Status}}" nginx)" == "running" ] ; then
          logger "nginx is RUNNING, stopping"
          nginx_stop
        fi
        exit 0
       ;;
     "FAULT")
        rm "/etc/keepalived/MASTER"

        logger "FAULT state, stopping Nginx"
        if [ "$(docker inspect -f "{{.State.Status}}" nginx)" == "running" ] ; then
          logger "nginx is RUNNING, stopping"
          nginx_stop
        fi
        exit 0
     ;;
       *) logger "nginx unknown state"
       exit 1
       ;;
esac
```

Define it like this in your `keepalived.conf`:

```
vrrp_instance NGINX {
  ...
  notify /root/keepalived/notify_nginx.sh
```

Now mount the `docker.sock` and your script in your containers.

If your container is using a macvlan network you can also use `docker network connect <your macvlan net>` and `docker network disconnect <your macvlan net>` for joining and leaving your macvlan network with a notify script. That way you can keep the container running in the background. But you probably need to bind your application to all interfaces (e.g. `0.0.0.0`).

### Example with `docker run`

```bash
docker run -d \
    --name=keepalived \
    --cap-add=NET_ADMIN \
    --cap-add=NET_BROADCAST \
    --net host \
    -e TZ=Europe/Berlin \
    -e KEEPALIVED_CUSTOM_CONFIG=true \
    -v "$(pwd)/keepalived.conf:/etc/keepalived/keepalived.conf:ro" \
    -v "$(pwd)/notify_nginx.sh:/root/keepalived/notify_nginx.sh:ro" \
    -v "/var/run/docker.sock:/var/run/docker.sock:ro" \
    shawly/keepalived
```

### Example `docker-compose.yml`

```yaml
version: "3"
services:
  keepalived:
    image: shawly/keepalived
    environment:
      TZ: Europe/Berlin
      KEEPALIVED_CUSTOM_CONFIG: "true"
    network_mode: host
    cap_add:
      - NET_ADMIN
      - NET_BROADCAST
    volumes:
      # mount the files as read only, so it can't be modified from within the container for additional security
      - "./keepalived.conf:/etc/keepalived/keepalived.conf:ro"
      - "./notify_nginx.sh:/root/keepalived/notify_nginx.sh:ro"
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
```

## Support

[Issues](https://github.com/shawly/docker-keepalived/issues) are disabled for now, since this image is still a work in progress.

Feel free to open a pull request if you want to fix any bugs and help maintain this image. Otherwise you are out of luck (for now at least).

## Contribution

Please follow the [contributing guide](https://github.com/shawly/docker-keepalived/blob/main/CONTRIBUTING.md)

## Credits

- [NeoAssist/docker-keepalived](https://github.com/NeoAssist/docker-keepalived) for their scripts I reused
- [acassen/keepalived](https://github.com/acassen/keepalived) obviously!
