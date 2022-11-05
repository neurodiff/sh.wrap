FROM ubuntu:latest as build

RUN apt update && apt install --yes ca-certificates
RUN apt install --yes bash
RUN apt install --yes curl
RUN apt install --yes git
RUN apt install --yes golang
RUN mkdir /go
COPY "${HUGO_BIN_SOURCE}" "${HUGO_BIN_DEST}"

FROM build as hugo-site

COPY "${DOCKERFILE_SCRIPTS_PATH}"/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD ["${WORK_DIR}", "${SCRIPT}", "${HUGO_BIN_DEST}", "${DOCS_DIR}", "${SITE_DIR}", "${PUBLIC_DIR}"]
