FROM ubuntu

RUN apt-get update && \
    apt-get install --yes \
        g++ make python