ARG PY_BASE_IMG

FROM python:${PY_BASE_IMG}

WORKDIR /app

# Add Rust and cargo for tokenizers compilation
RUN apk add --update gcc python3-dev build-base libev-dev libffi-dev bash \
    rust cargo pkgconfig openssl-dev

# Install packages in groups to make debugging easier
COPY requirements.txt /app

# Basic packages first
RUN pip3 install --no-cache-dir Flask==2.1.1 bjoern==3.2.1 requests==2.26.0

# Data processing packages
RUN pip3 install --no-cache-dir pandas==2.2.2 numpy==1.21.6 scipy==1.13.0

# NLP packages - with extra environment variables to help tokenizers build
ENV RUSTFLAGS="-C target-feature=-crt-static"
RUN pip3 install --no-cache-dir nltk>=3.6.0 emoji>=1.7.0
RUN pip3 install --no-cache-dir transformers==4.21.0

# Remaining requirements
RUN pip3 install --no-cache-dir -r requirements.txt

COPY *.py /app/

ENV PYTHONUNBUFFERED=1
ENTRYPOINT ["python3"]
CMD ["server.py"]