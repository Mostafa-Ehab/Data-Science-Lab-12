# TODO: Add common commands for students.
# Suggested targets:
# - setup: install dependencies
# - test: run tests
# - lint: run lint checks
# - clean: remove generated files

CONFIG := configs/config.toml

.PHONY: help pipeline setup validate clean_data features train classify test lint clean

pipeline:  # run the entire pipeline
	$(MAKE) setup
	$(MAKE) lint
	$(MAKE) test
	$(MAKE) validate
	$(MAKE) clean_data
	$(MAKE) features
	$(MAKE) train
	$(MAKE) classify

setup:
	@echo "TODO: Install dependencies."
	pip install -r requirements.txt
	pip install -e .

validate: # run data validation
	make reports/validation_raw.json

clean_data:
	python -m src.data.preprocess --config ${CONFIG}

features:
	python -m src.features.engineer --config ${CONFIG}

train:
	python -m src.models.train --config ${CONFIG}

classify:
	python -m src.models.classify --config ${CONFIG}

test:
	@echo "TODO: Run tests."
	python -m pytest ./test

lint:
	@echo "TODO: Run linting/format checks."
	flake8 src test
	black --check src test
	ruff check src test

clean:
	@echo "TODO: Remove generated files."
	rm -rf reports/* __pycache__ src/__pycache__ test/__pycache__

reports/validation_raw.json: data/raw/Teen_Mental_Health_Dataset.csv src/data/validate.py $(CONFIG)
	$(PYTHON) src/data/validate.py --config $(CONFIG) --input data/raw/Teen_Mental_Health_Dataset.csv --output reports/validation_raw.json
