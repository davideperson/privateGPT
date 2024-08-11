FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    build-essential

RUN git clone https://github.com/davideperson/privateGPT .

RUN pip install poetry

# Remove the line that adds openai="0.28.1" to pyproject.toml
# RUN sed -i '/\[tool\.poetry\.dependencies\]/a openai="0.28.1"' pyproject.toml

# Instead, update pyproject.toml to use a compatible version of openai
RUN sed -i 's/openai = ".*"/openai = "^1.1.0"/' pyproject.toml

# Update llama-index-core to a compatible version
RUN sed -i 's/llama-index-core = ".*"/llama-index-core = "^0.10.64"/' pyproject.toml

RUN poetry lock
RUN poetry install --with ui,local

CMD ["poetry", "run", "python", "scripts/setup"]
