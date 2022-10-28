FROM ubuntu:latest as build

RUN apt update
RUN apt install --yes ca-certificates
RUN apt install --yes bash
RUN apt install --yes curl
RUN apt install --yes gettext
RUN apt install --yes git
RUN apt install --yes jq
RUN mkdir /go
COPY "${GH_BIN_SOURCE}" "${GH_BIN_DEST}"

FROM build as git-tasks

COPY "${DOCKERFILE_SCRIPTS_PATH}"/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD ["${WORK_DIR}", "${SCRIPT}", "${GH_BIN_DEST}", "${ARGS}"]
