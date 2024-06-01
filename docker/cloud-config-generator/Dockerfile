FROM python:3.12.3-slim-bullseye

RUN apt-get update \
    && apt-get install -y --no-install-recommends jq wget wpasupplicant \
    && wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq \
    && chmod +x /usr/bin/yq \
    && pip install jinja2-cli

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
