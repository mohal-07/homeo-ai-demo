# Use Python 3.10 slim image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV C_FORCE_ROOT=true

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends gcc python3-dev curl netcat && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt ./
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose Koyeb’s expected port
EXPOSE 8000

# Run migrations and start server (web process)
CMD ["sh", "-c", "python manage.py migrate && gunicorn homeo_expert_ai.wsgi --bind 0.0.0.0:$PORT --workers 3"]
