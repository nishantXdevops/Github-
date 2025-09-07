FROM python:3.12-slim

# Install dependencies for pygame
RUN apt-get update && apt-get install -y --no-install-recommends \
    libsdl2-2.0-0 \
    libsdl2-image-2.0-0 \
    libsdl2-mixer-2.0-0 \
    libsdl2-ttf-2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libx11-6 \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files
COPY . /app

# Run the game using xvfb-run
CMD ["xvfb-run", "-s", "-screen", "0", "800x600x24", "python3", "snake-python.py"]
