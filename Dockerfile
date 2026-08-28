FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/games:${PATH}"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        cowsay \
        fortune-mod \
        netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY wisecow.sh .

RUN sed -i 's/\r$//' wisecow.sh \
    && chmod +x wisecow.sh

EXPOSE 4499

CMD ["./wisecow.sh"]