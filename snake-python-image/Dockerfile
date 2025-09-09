FROM python:3.12-slim

# Install dependencies (pygame + GUI + VNC + noVNC)
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
    x11vnc \
    wget \
    unzip \
    novnc \
    websockify \
    && rm -rf /var/lib/apt/lists/*

# Working directory
WORKDIR /app

# Copy and install python requirements
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . /app

# Download noVNC (if not installed via apt)
RUN mkdir -p /opt/novnc && \
    wget -qO- https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz | tar xz --strip 1 -C /opt/novnc && \
    ln -s /opt/novnc/vnc.html /opt/novnc/index.html

# Set environment variables
ENV DISPLAY=:1
ENV SDL_VIDEODRIVER=x11

# Expose ports
EXPOSE 8080   
# noVNC web client
EXPOSE 5900   
# VNC server

# Start script
CMD xvfb-run -s "-screen 0 800x600x24" python3 snake-python.py & \
    x11vnc -display :1 -nopw -forever -shared -rfbport 5900 & \
    websockify --web=/opt/novnc 8080 localhost:5900
