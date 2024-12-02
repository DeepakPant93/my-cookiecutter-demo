FROM python:3.12-slim
LABEL authors="deepakpant"

WORKDIR /app

# Install poetry
RUN pip install poetry

# Copy project files
COPY pyproject.toml poetry.lock* ./

# Install dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

# Copy the rest of the application
COPY . .

# Command to run the application
CMD ["poetry", "run", "python", "-m", "my_cookiecutter_demo"]
