FROM ubuntu:22.04

RUN apt update && apt install sudo -y
RUN useradd -ms /bin/bash tester && \
    echo "tester:pass" | chpasswd && \
    adduser tester sudo

USER tester
WORKDIR /home/tester

COPY --chown=tester:tester . .

CMD /bin/bash
