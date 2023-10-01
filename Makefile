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

build-image:
	docker build -t k6-presentation:latest .

run-temp-container: build-image
	docker run \
		--rm \
		-it \
		--network=host \
		k6-presentation:latest \
		gunicorn app.main:app \
		--workers $(workers) \
		--worker-class \
		uvicorn.workers.UvicornWorker \
		--bind 0.0.0.0:8000

remove-container:
	docker rm k6-presentation || true

create-container: remove-container
	docker create \
		--name k6-presentation \
		--network=host \
		k6-presentation:latest \
		gunicorn app.main:app \
		--workers $(workers) \
		--worker-class uvicorn.workers.UvicornWorker \
		--bind 0.0.0.0:8000

run-container:
	docker run -it k6-presentation
