#!/bin/bash
# Wrapper to configure Collabora Online with the correct LDFLAGS for this machine.
# Reason: /usr/local has Poco 1.13.3 (correct API); /usr/lib has Poco 1.11 from apt.
# Without -L/usr/local/lib the linker picks the system Poco -> undefined references.
set -e
export LOCOREPATH="${LOCOREPATH:-/home/admin1/test}"
./configure --enable-silent-rules \
    --with-lokit-path="${LOCOREPATH}/include" \
    --with-lo-path="${LOCOREPATH}/instdir" \
    --disable-debug --enable-cypress \
    --with-dictionaries="en_US th_TH" \
    --disable-ssl \
    LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib" \
    "$@"
