# Use a more compatible base image
FROM python:3.9-slim as builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    libev-dev \
    libffi-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt /app/

# Install dependencies in layers to isolate problems
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel
# Web framework and utilities
RUN pip3 install --no-cache-dir \
    Flask==2.1.1 \
    bjoern==3.2.1 \
    blinker==1.4 \
    click==8.0.3 \
    itsdangerous==2.0.1 \
    Jinja2==3.0.2 \
    MarkupSafe==2.0.1 \
    Werkzeug==2.0.2

# HTTP and networking
RUN pip3 install --no-cache-dir \
    requests==2.26.0 \
    urllib3==1.26.7 \
    httplib2==0.20.1 \
    certifi==2021.10.8 \
    chardet==4.0.0 \
    charset-normalizer==2.0.7 \
    idna==3.3

# Concurrency and messaging
RUN pip3 install --no-cache-dir \
    gevent==21.12.0 \
    gevent-ws==2.1.0 \
    greenlet==1.1.2 \
    redis==3.5.3 \
    hiredis==2.0.0

# Utilities
RUN pip3 install --no-cache-dir \
    importlib-metadata==4.11.3 \
    zipp==3.8.0 \
    six==1.16.0 \
    python-dateutil==2.8.2 \
    pyparsing==2.4.7 \
    zope.event==4.5.0 \
    zope.interface==5.4.0 \
    sentry-sdk==1.5.10

# Data science packages
RUN pip3 install --no-cache-dir \
    numpy==1.21.6 \
    pandas==2.2.2

# Install remaining packages
RUN pip3 install --no-cache-dir \
    scipy==1.13.0 \
    elasticsearch8==8.11.0 \
    beautifulsoup4>=4.9.0 \
    nltk>=3.6.0 \
    emoji>=1.7.0 \
    transformers==4.21.0

# Final stage with runtime dependencies
FROM python:3.9-slim

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libev4 \
    libffi7 \
    && rm -rf /var/lib/apt/lists/*

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy Python source files
COPY *.py /app/

# Environment settings
ENV PYTHONUNBUFFERED 1
ENTRYPOINT ["python3"]
CMD ["server.py"]