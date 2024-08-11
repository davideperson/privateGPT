FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y     git     build-essential

RUN git clone https://github.com/imartinez/privateGPT .

RUN pip install poetry

RUN sed -i '/\[tool\.poetry\.dependencies\]/a openai="0.28.1"' pyproject.toml

RUN poetry lock
RUN poetry install --with ui,local

CMD ["poetry", "run", "python", "scripts/setup"]
