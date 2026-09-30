# Use lightweight Python image
FROM python:3.10-slim

# Install system dependencies (slim images need this)
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 8080

# Start Flask app
CMD ["python", "app.py"]
