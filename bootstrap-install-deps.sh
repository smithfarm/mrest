#!/bin/bash
set -e
sudo zypper --gpg-auto-import-keys --non-interactive refresh
#
# NOTE: the following is not a full list of dependencies. Before running
# this script, make sure you have also bootstrapped the repo
# https://github.com/smithfarm/dochazka
#
sudo zypper --non-interactive install \
    perl-JSON \
    perl-Path-Router \
    perl-Plack-Middleware-LogErrors \
    perl-Plack-Middleware-Session \
    perl-Plack \
    perl-Web-Machine \
    perl-Test-JSON
