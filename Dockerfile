FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    build-essential

RUN git clone https://github.com/davideperson/privateGPT .

# Print current directory and list its contents
RUN pwd && ls -la

RUN pip install poetry

# Try to find pyproject.toml
RUN find / -name pyproject.toml

# If pyproject.toml exists, proceed with modifications
RUN if [ -f pyproject.toml ]; then \
        sed -i 's/openai = ".*"/openai = "^1.1.0"/' pyproject.toml && \
        sed -i 's/llama-index-core = ".*"/llama-index-core = "^0.10.64"/' pyproject.toml; \
    else \
        echo "pyproject.toml not found"; \
        exit 1; \
    fi

RUN poetry lock
RUN poetry install --with ui,local

CMD ["poetry", "run", "python", "scripts/setup"]
