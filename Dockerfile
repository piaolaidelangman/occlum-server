FROM occlum/occlum:0.27.1-ubuntu20.04

ARG HTTP_PROXY_HOST
ARG HTTP_PROXY_PORT
ARG HTTPS_PROXY_HOST
ARG HTTPS_PROXY_PORT
ENV HTTP_PROXY=http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT
ENV HTTPS_PROXY=http://$HTTPS_PROXY_HOST:$HTTPS_PROXY_PORT

RUN cd /opt/ && \
    git clone https://github.com/piaolaidelangman/occlum-server && \
    cd occlum-server/content && \
    bash build_content.sh
