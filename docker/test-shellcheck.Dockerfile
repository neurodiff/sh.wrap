FROM ubuntu:latest as build

RUN apt update && apt install --yes ca-certificates
RUN apt install --yes bash
RUN apt install --yes shellcheck

FROM build

COPY "${DOCKERFILE_SCRIPTS_PATH}"/entrypoint.sh entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD ["${WORK_DIR}", "${SCRIPT}", "${ARGS}"]
