# syntax=docker/dockerfile:1
FROM python:3.11-slim AS builder
WORKDIR /app
# Upgrade pip and install wheel for building dependencies
RUN pip install --upgrade pip wheel
# Copy dependency list and build wheels
COPY requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

FROM python:3.11-slim AS runtime
WORKDIR /app
# Create non-root user
RUN useradd -m appuser
# Copy pre-built wheels from builder and install them
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir /wheels/* && rm -rf /wheels
# Copy application code
COPY . .
# Use non-root user
USER appuser
# Expose FastAPI port
EXPOSE 8000
# Start the FastAPI app using Uvicorn
CMD ["uvic]()
