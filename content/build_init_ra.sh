#!/bin/bash
set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd )"

export INITRA_DIR="${script_dir}/init_ra"

function build_init_ra()
{
    pushd ${INITRA_DIR}
    sed -i "s#localhost:50051#${ATTESTATION_SERVER_IP}:${ATTESTATION_SERVER_PORT}#g" src/main.rs
    occlum-cargo clean
    occlum-cargo build --release
    popd
}

build_init_ra
