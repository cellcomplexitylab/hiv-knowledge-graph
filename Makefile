DOCKER_RUN= docker run --rm -v $$(pwd):/tmp -u$$(id -u):$$(id -g) kgim

all: docker/kgim_available kg-genes.json

test: docker/kgim_available
	rm -rf __pycache__ && $(DOCKER_RUN) pytest

docker/kgim_available:
	$(MAKE) -C docker

Danio_rerio.gene_info.gz:
	$(DOCKER_RUN) wget ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/GENE_INFO/Non-mammalian_vertebrates/Danio_rerio.gene_info.gz -qO $@

Drosophila_melanogaster.gene_info.gz:
	$(DOCKER_RUN) wget ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/GENE_INFO/Invertebrates/Drosophila_melanogaster.gene_info.gz -qO $@

Homo_sapiens.gene_info.gz:
	$(DOCKER_RUN) wget ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/GENE_INFO/Mammalia/Homo_sapiens.gene_info.gz -qO $@

Mus_musculus.gene_info.gz:
	$(DOCKER_RUN) wget ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/GENE_INFO/Mammalia/Mus_musculus.gene_info.gz -qO $@

kg-genes.json: Danio_rerio.gene_info.gz Drosophila_melanogaster.gene_info.gz Homo_sapiens.gene_info.gz Mus_musculus.gene_info.gz
	$(DOCKER_RUN) python3 ncbi_info_to_json.py Homo_sapiens.gene_info.gz >  kg-genes.json && \
	$(DOCKER_RUN) python3 ncbi_info_to_json.py Mus_musculus.gene_info.gz >> kg-genes.json && \
	$(DOCKER_RUN) python3 ncbi_info_to_json.py Danio_rerio.gene_info.gz >> kg-genes.json && \
	$(DOCKER_RUN) python3 ncbi_info_to_json.py Drosophila_melanogaster.gene_info.gz >> kg-genes.json
