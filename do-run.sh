#!/bin/bash
# Wrapper to run coolwsd natively (no podman) with --disable-cool-user-checking.
# Required because Makefile only adds that flag when apparmor=1 (podman path).
# We disabled apparmor restriction, so we run native and need this manually.
set -e
cd "$(dirname "$0")"

# In release builds (without --enable-debug), kit reads coolkitconfig.xcu from
# COOLWSD_CONFIGDIR (e.g. /etc/coolwsd/) which isn't populated in a source build.
# Point it at the source file so our overrides (e.g. default font) take effect.
export COOLKITCONFIG_XCU="$(pwd)/coolkitconfig.xcu"

./coolwsd \
    --disable-cool-user-checking \
    --o:sys_template_path="$(pwd)/systemplate" \
    --o:child_root_path="$(pwd)/jails" \
    --o:cache_files.path="$(pwd)/cache" \
    --o:storage.filesystem[@allow]=true \
    --o:ssl.cert_file_path="$(pwd)/etc/cert.pem" \
    --o:ssl.key_file_path="$(pwd)/etc/key.pem" \
    --o:ssl.ca_file_path="$(pwd)/etc/ca-chain.cert.pem" \
    --o:admin_console.username=admin \
    --o:admin_console.password=admin \
    --o:logging.file[@enable]=false \
    --o:logging.level=error \
    --o:logging_ui_cmd.file[@enable]=false \
    --o:trace_event[@enable]=false \
    --o:per_document.autosave_duration_secs=300
