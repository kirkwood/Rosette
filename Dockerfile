FROM ioft/i386-ubuntu:14.04

RUN apt-get update && apt-get -y dist-upgrade && apt-get install -y g++ make

COPY . /src/
WORKDIR /src

RUN make -C src

ENTRYPOINT make -C rbl
