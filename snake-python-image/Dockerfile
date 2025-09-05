# Base image
FROM python:3.12-slim

# Install system dependencies for pygame (SDL, fonts, sound etc.)
RUN apt-get update && apt-get install -y \
    python3-dev \
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    libsdl2-ttf-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libx11-6 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy game code
COPY snake-python.py .

# Install pygame
RUN pip install pygame==2.6.0

# Default command to run the game
CMD ["python", "snake_game.py"]
