#!/bin/bash
set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd )"

export DEP_LIBS_DIR="${script_dir}/dep_libs"
export INITRA_DIR="${script_dir}/init_ra"
export RATLS_DIR="${script_dir}/ra_tls"

function build_ratls()
{
    rm -rf ${DEP_LIBS_DIR} && mkdir ${DEP_LIBS_DIR}
    pushd ${RATLS_DIR}
    ./download_and_prepare.sh
    ./build_and_install.sh musl
    ./build_occlum_instance.sh musl

    cp ./grpc-src/examples/cpp/ratls/build/libgrpc_ratls_client.so ${DEP_LIBS_DIR}/
    cp ./grpc-src/examples/cpp/ratls/build/libhw_grpc_proto.so ${DEP_LIBS_DIR}/

    popd
}

function build_init_ra()
{
    pushd ${INITRA_DIR}
    occlum-cargo clean
    occlum-cargo build --release
    popd
}

function gen_secret_json() {
    # First generate cert/key by openssl
    ./gen-cert.sh

    # Then do base64 encode
    cert=$(base64 -w 0 flask.crt)
    key=$(base64 -w 0 flask.key)
    image_key=$(base64 -w 0 image_key)

    # Then generate secret json
    jq -n --arg cert "$cert" --arg key "$key" --arg image_key "$image_key" \
        '{"flask_cert": $cert, "flask_key": $key, "image_key": $image_key}' >  secret_config.json
}

function build_server_instance()
{
    occlum gen-image-key image_key
    gen_secret_json
    rm -rf occlum_server && occlum new occlum_server
    pushd occlum_server

    jq '.verify_mr_enclave = "off" |
        .verify_mr_signer = "off" |
        .verify_isv_prod_id = "off" |
        .verify_isv_svn = "off" |
        .verify_enclave_debuggable = "on" |
        .sgx_mrs[0].debuggable = false ' ../ra_config_template.json > dynamic_config.json

    new_json="$(jq '.resource_limits.user_space_size = "500MB" |
                    .metadata.debuggable = false ' Occlum.json)" && \
    echo "${new_json}" > Occlum.json

    rm -rf image
    copy_bom -f ../ra_server.yaml --root image --include-dir /opt/occlum/etc/template

    occlum build

    popd
}

build_ratls
build_init_ra

build_server_instance
