# Build and run as shown below.
# docker build -t kgim .
# Then run as shown in the examples below.
# docker run --rm -v $(pwd):/tmp -u$(id -u):$(id -g) kgim make
# docker run --rm -r $(pwd):/tmp -u$(id -u):$(id -g) kgim pytest

FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    wget \
    python3 \
    python-pytest \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Use /tmp as shared volume.
WORKDIR /tmp
