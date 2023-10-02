.PHONY: $(MAKECMDGOALS)

clean:
	@find . -name "*.pyc" | xargs rm -rf
	@find . -name "*.pyo" | xargs rm -rf
	@find . -name "*.log" | xargs rm -rf
	@find . -name "__pycache__" -type d | xargs rm -rf
	@find . -name ".pytest_cache" -type d | xargs rm -rf
	@rm -f .coverage
	@rm -f .coverage.NB-SBDEV*
	@rm -rf htmlcov/
	@rm -f coverage.xml
	@rm -f *.log

delete-image:
	docker rmi k6-presentation:latest || true

build-image: delete-image
	docker build -t k6-presentation:latest .

run-api: build-image
	docker run \
		--rm \
		-it \
		--network=host \
		k6-presentation:latest \
		gunicorn app.main:app \
		--workers $(workers) \
		--worker-class uvicorn.workers.UvicornWorker \
		--bind 0.0.0.0:8000

delete-container:
	docker rm k6-presentation || true

create-container: delete-container build-image
	docker create --name k6-presentation k6-presentation:latest

run-container:
	docker run --network=host -it k6-presentation

test:
	docker run --network=host --rm -i grafana/k6 run - <test/$(t).js

# https://hub.docker.com/r/grafana/xk6
build-k6:
	docker run --network=host --rm -it \
		-u "$(id -u):$(id -g)" \
		-v "${PWD}:/xk6" \
		grafana/xk6 build v0.46.0 \
			--with github.com/Juandavi1/xk6-prompt@0.0.1


