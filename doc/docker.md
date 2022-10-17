

# Docker image for sh.wrap testing


## Build docker image

Variables declarations.

    DOCKER_PATH="../docker"
    DOCKER_FILE="$DOCKER_PATH"/"Dockerfile.test"
    DOCKER_IMAGE="shwrap:testing"
    DOCKER_REPO="neurodiff"

    mkdir "$DOCKER_PATH"

\`ubuntu:bionic\` with \`shellcheck\` is a base image to run tests for sh.wrap.

    FROM ubuntu:bionic as build

    RUN apt update
    RUN apt install shellcheck

    FROM build

    RUN mkdir /opt/sh.wrap

    COPY entrypoint.sh entrypoint.sh
    ENTRYPOINT ["bash", "/entrypoint.sh"]
    CMD ["/opt/sh.wrap/", "test/tests.sh"]

    (org-babel-tangle)

Build and tag an image.

    docker build -t "$DOCKER_IMAGE" -f "$DOCKER_FILE" "$DOCKER_PATH"
    docker tag "$DOCKER_IMAGE" "$DOCKER_REPO"/"$DOCKER_IMAGE"


## Push to Docker Hub (optionally)

    docker push "$DOCKER_REPO"/"$DOCKER_IMAGE"


## Run tests

    docker run -it --rm --name shwrap-test --volume $(realpath `pwd`/..):/opt/sh.wrap "$DOCKER_REPO"/"$DOCKER_IMAGE" "/opt/sh.wrap/" "test/tests.sh" test

