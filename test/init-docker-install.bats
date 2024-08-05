#!/usr/bin/env bats

bats_require_minimum_version 1.5.0
load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

setup() {
    # prepare s6 paths
    export PATH="/command:$PATH"
    mkdir -p /run/s6/container_environment
}

teardown() {
    rm -f /run/s6/container_environment/DOCKER_*
    apk del --no-cache docker-cli docker-cli-compose
}

@test "init-docker-install installs Docker when DOCKER_HOST is set" {
    echo -n "blablabla" > /run/s6/container_environment/DOCKER_HOST

    run -0 /etc/s6-overlay/s6-rc.d/init-docker-install/run

    assert_output --partial 'Detected DOCKER_HOST variable, installing docker-cli...'
    assert_output --partial 'Installed docker-cli!'
    docker -v
    docker compose version
}

@test "init-docker-install installs Docker when /var/run/docker.sock is mounted" {
    apk add --no-cache socat
    nohup socat - UNIX-LISTEN:/var/run/docker.sock &
    socat_pid="$!"

    run -0 /etc/s6-overlay/s6-rc.d/init-docker-install/run
    kill "$socat_pid"

    assert_output --partial 'Detected /var/run/docker.sock mount, installing docker-cli...'
    assert_output --partial 'Installed docker-cli!'
    docker -v
    docker compose version
}