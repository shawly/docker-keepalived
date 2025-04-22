#!/usr/bin/env bats

bats_require_minimum_version 1.5.0
load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

setup() {
    # prepare s6 paths
    export PATH="/command:$PATH"
    mkdir -p /run/s6/container_environment

    ip link add dummy0 type dummy || true
    ip addr add 192.168.0.2/24 dev dummy0 || true
    ip link set dummy0 up || true
}

teardown() {
    rm -f /run/s6/container_environment/KEEPALIVED_*
    ip link del dummy0 || true
}

@test "init-keepalived-config exits early when KEEPALIVED_CUSTOM_CONFIG is set" {
    echo -n "true" > /run/s6/container_environment/KEEPALIVED_CUSTOM_CONFIG

    run -0 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output 'KEEPALIVED_CUSTOM_CONFIG was enabled, skipping validation!'
}

@test "init-keepalived-config fails when KEEPALIVED_VIRTUAL_IP is not set" {
    run -1 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial 'The KEEPALIVED_VIRTUAL_IP environment variable () is not a valid IP address, exiting...'
}

@test "init-keepalived-config fails when KEEPALIVED_VIRTUAL_IP is set to an invalid ip" {
    echo -n "999.999.999.999" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP

    run -1 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial 'The KEEPALIVED_VIRTUAL_IP environment variable (999.999.999.999) is not a valid IP address, exiting...'
}

@test "init-keepalived-config fails when KEEPALIVED_VIRTUAL_MASK is not set" {
    echo -n "192.168.0.10" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP

    run -1 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial 'The KEEPALIVED_VIRTUAL_MASK environment variable () is not a valid subnet mask, exiting...'
}

@test "init-keepalived-config fails when KEEPALIVED_VIRTUAL_MASK is set to an invalid subnet mask" {
    echo -n "192.168.0.10" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP
    echo -n "999" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_MASK

    run -1 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial 'The KEEPALIVED_VIRTUAL_MASK environment variable (999) is not a valid subnet mask, exiting...'
}

@test "init-keepalived-config fails when KEEPALIVED_VRID is not set" {
    echo -n "192.168.0.10" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP
    echo -n "24" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_MASK

    run -1 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial 'The KEEPALIVED_VRID environment variable () is not a number between 1 and 255, exiting...'
}

@test "init-keepalived-config fails when KEEPALIVED_VRID is set to an invalid number" {
    echo -n "192.168.0.10" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP
    echo -n "24" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_MASK
    echo -n "999" > /run/s6/container_environment/KEEPALIVED_VRID

    run -1 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial 'The KEEPALIVED_VRID environment variable (999) is not a number between 1 and 255, exiting...'
}

@test "init-keepalived-config fails when KEEPALIVED_PRIORITY is not set" {
    echo -n "192.168.0.10" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP
    echo -n "24" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_MASK
    echo -n "1" > /run/s6/container_environment/KEEPALIVED_VRID
    echo -n "" > /run/s6/container_environment/KEEPALIVED_PRIORITY

    run -1 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial 'The KEEPALIVED_PRIORITY environment variable () is not a number, exiting...'
}

@test "init-keepalived-config fails when KEEPALIVED_PRIORITY is not a number" {
    echo -n "192.168.0.10" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP
    echo -n "24" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_MASK
    echo -n "1" > /run/s6/container_environment/KEEPALIVED_VRID
    echo -n "abc" > /run/s6/container_environment/KEEPALIVED_PRIORITY

    run -1 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial 'The KEEPALIVED_PRIORITY environment variable (abc) is not a number, exiting...'
}

@test "init-keepalived-config fails when KEEPALIVED_STATE is not set" {
    echo -n "192.168.0.10" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP
    echo -n "24" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_MASK
    echo -n "1" > /run/s6/container_environment/KEEPALIVED_VRID
    echo -n "" > /run/s6/container_environment/KEEPALIVED_STATE

    run -1 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial 'The KEEPALIVED_STATE environment variable () must be either MASTER or BACKUP, exiting...'
}

@test "init-keepalived-config fails when KEEPALIVED_STATE is not MASTER or BACKUP" {
    echo -n "192.168.0.10" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP
    echo -n "24" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_MASK
    echo -n "1" > /run/s6/container_environment/KEEPALIVED_VRID
    echo -n "ABC" > /run/s6/container_environment/KEEPALIVED_STATE

    run -1 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial 'The KEEPALIVED_STATE environment variable (ABC) must be either MASTER or BACKUP, exiting...'
}

@test "init-keepalived-config fails when KEEPALIVED_INTERFACE is set to an interface that doesn't exist" {
    echo -n "192.168.0.10" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP
    echo -n "24" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_MASK
    echo -n "1" > /run/s6/container_environment/KEEPALIVED_VRID
    echo -n "100" > /run/s6/container_environment/KEEPALIVED_PRIORITY
    echo -n "eth999" > /run/s6/container_environment/KEEPALIVED_INTERFACE
    echo -n "BACKUP" > /run/s6/container_environment/KEEPALIVED_STATE

    run -1 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial 'The KEEPALIVED_INTERFACE environment variable contains a non-existent interface "eth999".'
}

@test "init-keepalived-config removes VIP from KEEPALIVED_INTERFACE if it already existed" {
    echo -n "192.168.0.10" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP
    echo -n "24" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_MASK
    echo -n "1" > /run/s6/container_environment/KEEPALIVED_VRID
    echo -n "100" > /run/s6/container_environment/KEEPALIVED_PRIORITY
    echo -n "dummy0" > /run/s6/container_environment/KEEPALIVED_INTERFACE
    echo -n "BACKUP" > /run/s6/container_environment/KEEPALIVED_STATE

    run -0 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert ip addr show dummy0 | grep -vq "192.168.0.10/24"
}

@test "init-keepalived-config replaces placeholders in /etc/keepalived/keepalived.conf" {
    echo -n "192.168.0.10" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP
    echo -n "24" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_MASK
    echo -n "1" > /run/s6/container_environment/KEEPALIVED_VRID
    echo -n "100" > /run/s6/container_environment/KEEPALIVED_PRIORITY
    echo -n "dummy0" > /run/s6/container_environment/KEEPALIVED_INTERFACE
    echo -n "BACKUP" > /run/s6/container_environment/KEEPALIVED_STATE

    run -0 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert [ -f /etc/keepalived/keepalived.conf ]
    #assert grep -q 'script "iptables -t nat -nL CATTLE_PREROUTING | grep \':${KEEPALIVED_CHECK_PORT}\'"' /etc/keepalived/keepalived.conf
    assert grep -q "interface dummy0" /etc/keepalived/keepalived.conf
    assert grep -q "virtual_router_id 1" /etc/keepalived/keepalived.conf
    assert grep -Pz 'virtual_ipaddress {.*\n\s*192.168.0.10/24 dev dummy0\n.*}' /etc/keepalived/keepalived.conf
}

@test "init-keepalived-config autodetermines KEEPALIVED_INTERFACE if set to 'auto'" {
    echo -n "192.168.0.123" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP
    echo -n "24" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_MASK
    echo -n "1" > /run/s6/container_environment/KEEPALIVED_VRID
    echo -n "100" > /run/s6/container_environment/KEEPALIVED_PRIORITY
    echo -n "auto" > /run/s6/container_environment/KEEPALIVED_INTERFACE
    echo -n "BACKUP" > /run/s6/container_environment/KEEPALIVED_STATE

    run -0 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial 'Found interface dummy0 for 192.168.0.123/24'
    assert grep -Pz 'virtual_ipaddress {.*\n\s*192.168.0.10/24 dev dummy0\n.*}' /etc/keepalived/keepalived.conf
}

@test "init-keepalived-config fails when KEEPALIVED_INTERFACE is set to 'auto' and no interface is found" {
    echo -n "192.168.33.123" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_IP
    echo -n "22" > /run/s6/container_environment/KEEPALIVED_VIRTUAL_MASK
    echo -n "1" > /run/s6/container_environment/KEEPALIVED_VRID
    echo -n "100" > /run/s6/container_environment/KEEPALIVED_PRIORITY
    echo -n "auto" > /run/s6/container_environment/KEEPALIVED_INTERFACE
    echo -n "BACKUP" > /run/s6/container_environment/KEEPALIVED_STATE

    run -1 /etc/s6-overlay/s6-rc.d/init-keepalived-config/run

    assert_output --partial "The KEEPALIVED_VIRTUAL_IP and KEEPALIVED_VIRTUAL_MASK don't match any interfaces on this device."
}
