CWD=$(shell pwd)

build:
	docker build --rm -t local-jupyter .

start:
	mkdir -p notebooks/
	docker run \
		--env GRANT_SUDO=yes\
		--mount type=bind,source="$(CWD)/notebooks",target=/jupyter/notebooks\
		--memory=8G\
		--cpus=2\
		--publish 8888:8888\
		local-jupyter
