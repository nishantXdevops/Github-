# Use the official Python image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy files
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py .

# Expose port
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]
