FROM ubuntu:20.04

RUN cd /opt/ && \
    git clone https://github.com/piaolaidelangman/occlum-server && \
    cd occlum-server/content && \
    bash build_content.sh