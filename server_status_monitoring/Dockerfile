FROM python:3.8-slim

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir django==3.1.1 psycopg2-binary

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
