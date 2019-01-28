FROM ubuntu

RUN apt-get update && \
    apt-get install --yes \
        build-essential \
        python
