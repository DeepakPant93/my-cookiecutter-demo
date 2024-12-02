# Makefile for Python Project

# Variables
PYTHON = python
PIP = $(PYTHON) -m pip
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
	@echo "  clean        - Remove build artifacts and cache"
	@echo "  shell        - Start a Python shell"
	@echo "  docs         - Generate documentation"
	@echo "  setup        - Set up the development environment"


# Install dependencies
.PHONY: install
install:
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	$(PIP) install -r requirements_dev.txt

# Update dependencies
.PHONY: update
update:
	$(PIP) install --upgrade -r requirements.txt
	$(PIP) install --upgrade -r requirements_dev.txt

# Run test cases
.PHONY: test
test:
	PYTHONPATH=src $(PYTHON) -m pytest tests/

# Run tests with coverage
.PHONY: test-cov
test-cov:
	$(PYTHON) -m pytest --cov=$(PROJECT_NAME) --cov-report=html

# Lint the code
.PHONY: lint
lint:
	$(PYTHON) -m flake8 src/$(PROJECT_NAME)
	$(PYTHON) -m black --check src/$(PROJECT_NAME)

# Format code
.PHONY: format
format:
	$(PYTHON) -m black src/$(PROJECT_NAME) tests/ --line-length 100

# Run the application (example with input file)
.PHONY: run
run:
	$(PYTHON) -m $(PROJECT_NAME) data/spam_ham_dataset.csv

# Build distribution packages
.PHONY: build
build:
	$(PYTHON) setup.py sdist bdist_wheel


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

# Start a Python shell
.PHONY: shell
shell:
	$(PYTHON)

# Generate documentation
.PHONY: docs
docs:
	@echo "Generating documentation..."
	$(PYTHON) -m sphinx-build -b html docs/ docs/_build/html

# Check dependencies for security vulnerabilities
.PHONY: security
security:
	$(PYTHON) -m safety check


# Development setup instructions
.PHONY: setup
setup:
	@echo "Setting up development environment..."
	@echo "1. Install Python: Ensure Python is installed on your system"
	@echo "2. Install dependencies: make install"
	@echo "3. Activate virtualenv (if any): source <venv>/bin/activate"
	@echo "4. Run tests: make test"
