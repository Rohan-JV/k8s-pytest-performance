# Use Python 3.10 slim image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy test files into container
COPY tests/ ./tests/

# Define entry point to run pytest
ENTRYPOINT ["pytest", "tests/"]