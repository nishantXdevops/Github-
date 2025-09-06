FROM python:3.12-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy python file
COPY snake-python.py .

# Run app
CMD ["python", "snake-python.py"]

