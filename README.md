# Docker container for keepalived

[![Docker Automated build](https://img.shields.io/badge/docker%20build-automated-brightgreen)](https://github.com/shawly/docker-keepalived/actions) [![GitHub Workflow Status](https://img.shields.io/github/workflow/status/shawly/docker-keepalived/Docker)](https://github.com/shawly/docker-keepalived/actions) [![Docker Pulls](https://img.shields.io/docker/pulls/shawly/keepalived)](https://hub.docker.com/r/shawly/keepalived) [![Docker Image Size (tag)](https://img.shields.io/docker/image-size/shawly/keepalived/latest)](https://hub.docker.com/r/shawly/keepalived)

This is a Docker container for keepalived.

---

[![keepalived](https://dummyimage.com/400x110/ffffff/575757&text=keepalived)](https://github.com/acassen/keepalived)

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
  - [Credits](#credits)

## Supported tags

<!-- supported tags will be auto updated through workflows! -->

- `latest`, `2`, `2.2`, `2.2.7` <!-- latest tag -->

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

```
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

| Variable                   | Description                                                                                                                                                                                                                                         | Default   |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| `TZ`                       | Timezone of the container. Timezone can also be set by mapping `/etc/localtime` between the host and the container.                                                                                                                                 | `Etc/UTC` |
| `KEEPALIVED_VIRTUAL_IP`    | Floating IP that is used by keepalived                                                                                                                                                                                                              | undefined |
| `KEEPALIVED_VIRTUAL_MASK`  | Subnet mask of the floating IP (e.g. `24`)                                                                                                                                                                                                          | undefined |
| `KEEPALIVED_CHECK_IP`      | Set this to a specific IP if you only want to check `KEEPALIVED_CHECK_PORT` on the given IP address                                                                                                                                                 | `any`     |
| `KEEPALIVED_CHECK_PORT`    | Set this to the port you want to check                                                                                                                                                                                                              | undefined |
| `KEEPALIVED_VRID`          | The virtual router id                                                                                                                                                                                                                               | undefined |
| `KEEPALIVED_INTERFACE`     | Interface in your container usually `eth0`                                                                                                                                                                                                          | `eth0`    |
| `KEEPALIVED_CHECK_SCRIPT`  | You can set a custom script that is used for checking if a host is alive                                                                                                                                                                            | undefined |
| `KEEPALIVED_CUSTOM_CONFIG` | If you set this to `true` the configuration `/etc/keepalived/keepalived.conf` will not be set up automatically. Use this if you want to customize your keepalived.conf manually (see [Using a custom configuration](#using-a-custom-configuration)) | `false`   |

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
    net: host
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

## Using a custom configuration

If you want to mount a custom configuration, you need to set the environment variable `KEEPALIVED_CUSTOM_CONFIG=true`.

This will stop the `init-kepalived-config` service from applying the values from other variables and checking them for validity.

This is for advanced users only.

### Example with `docker run`

Create a `keepalived.conf` with your configuration and mount it to `/etc/keepalived/keepalived.conf`. The file needs to exist before mounting!

```
docker run -d \
    --name=keepalived \
    --cap-add=NET_ADMIN \
    --cap-add=NET_BROADCAST \
    --net host \
    -e TZ=Europe/Berlin \
    -e KEEPALIVED_CUSTOM_CONFIG=true \
    -v "$(pwd)/keepalived.conf:/etc/keepalived/keepalived.conf" \
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
    net: host
    cap_add:
      - NET_ADMIN
      - NET_BROADCAST
    volumes:
      # mount the conf as read only, so it can't be modified from within the container for additional security
      - "./keepalived.conf:/etc/keepalived/keepalived.conf:ro"
```

## Credits

- [NeoAssist/docker-keepalived](https://github.com/NeoAssist/docker-keepalived) for their scripts I reused
