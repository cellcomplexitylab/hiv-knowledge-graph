DOCKER_RUN= docker run --rm -v $$(pwd):/tmp -u$$(id -u):$$(id -g) kgim

all:
	docker build -t kgim . && \
	$(DOCKER_RUN) touch kgim_available

clean:
	docker rmi -f kgim && rm -f kgim_available
