# Makefile for Sentence Preprocessor Project

# Variables
POETRY = poetry
PYTHON = $(POETRY) run python
PROJECT_NAME = my_cookiecutter_demo


# Default target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  install      - Install project dependencies"
	@echo "  update       - Update dependencies"
	@echo "  test         - Run test cases"
	@echo "  test-cov     - Run tests with coverage"
	@echo "  lint         - Run linters (flake8, black)"
	@echo "  format       - Format code using black"
	@echo "  run          - Run the application"
	@echo "  build        - Build distribution packages"
	@echo "  publish      - Publish to PyPI"
	@echo "  clean        - Remove build artifacts and cache"
	@echo "  shell        - Start a Poetry shell"
	@echo "  docs         - Generate documentation"

# Install dependencies
.PHONY: install
install:
	$(POETRY) install

# Update dependencies
.PHONY: update
update:
	$(POETRY) update

# Run test cases
.PHONY: test
test:
	PYTHONPATH=src $(POETRY) run pytest tests/

# Run tests with coverage
.PHONY: test-cov
test-cov:
	$(POETRY) run pytest --cov=$(PROJECT_NAME) --cov-report=html

# Lint the code
.PHONY: lint
lint:
	$(POETRY) run flake8 src/$(PROJECT_NAME)
	$(POETRY) run black --check src/$(PROJECT_NAME)

# Format code
.PHONY: format
format:
	$(POETRY) run black src/$(PROJECT_NAME) tests/ --line-length 100

# Run the application (example with input file)
.PHONY: run
run:
	$(POETRY) run python -m $(PROJECT_NAME) data/spam_ham_dataset.csv

# Build distribution packages
.PHONY: build
build:
	$(POETRY) build

pypi-config:
	$(POETRY) config pypi-token.pypi $(TOKEN)


# Publish to PyPI
.PHONY: publish
publish: format  build pypi-config
	$(POETRY) publish --build

# Clean up build artifacts
.PHONY: clean
clean:
	rm -rf dist/
	rm -rf build/
	rm -rf *.egg-info
	rm -rf .pytest_cache
	rm -rf .coverage
	rm -rf htmlcov/
	find . -type d -name "__pycache__" -exec rm -rf {} +

# Start a Poetry shell
.PHONY: shell
shell:
	$(POETRY) shell

# Generate documentation (placeholder - adjust as needed)
.PHONY: docs
docs:
	@echo "Generating documentation..."
	$(POETRY) run sphinx-build -b html docs/ docs/_build/html

# Check dependencies for security vulnerabilities
.PHONY: security
security:
	$(POETRY) run safety check

# Create a new release (bump version and tag)
.PHONY: release
release:
	@read -p "Enter new version (e.g., patch/minor/major): " version; \
	$(POETRY) version $$version; \
	git add pyproject.toml; \
	git commit -m "Bump version to $$($(POETRY) version -s)"; \
	git tag "v$$($(POETRY) version -s)"

# Development setup instructions
.PHONY: setup
setup:
	@echo "Setting up development environment..."
	@echo "1. Install Poetry: pip install poetry"
	@echo "2. Install dependencies: make install"
	@echo "3. Activate virtualenv: make shell"
	@echo "4. Run tests: make test"

# Additional development tools
.PHONY: dev-tools
dev-tools:
	$(POETRY) add --group dev \
		flake8 \
		black \
		isort \
		mypy \
		sphinx
