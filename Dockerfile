FROM ubuntu:20.04
ADD ./content /opt

RUN cd /opt/content && \
    bash build_content.sh