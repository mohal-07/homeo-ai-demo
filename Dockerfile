# Use Python 3.10 image (matches your local version)
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies (needed for some Python packages)
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev curl netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

# Create work directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose port (Sevalla uses $PORT)
EXPOSE 8000

# Run migrations + start server
CMD ["sh", "-c", "python manage.py migrate && gunicorn homeo_expert_ai.wsgi --bind 0.0.0.0:$PORT --workers 3"]
