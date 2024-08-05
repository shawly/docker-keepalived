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
    rm -f /root/.msmtprc
    apk del --no-cache mailx msmtp
}

@test "init-msmtp-install installs msmtp when /root/.msmtprc is mounted" {
    touch /root/.msmtprc

    run -0 /etc/s6-overlay/s6-rc.d/init-msmtp-install/run

    assert_output --partial 'Detected /root/.msmtprc mount, installing msmtp...'
    [ -L /usr/bin/sendmail ]
    [ -L /usr/sbin/sendmail ]
    assert_output --partial 'Enabling msmtpd service'
    [ -f /etc/s6-overlay/s6-rc.d/user/contents.d/svc-msmtpd ]
    assert_output --partial 'Installed msmtp!'
    msmtp --version
    command -v mail
}
