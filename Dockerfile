ARG PY_BASE_IMG

FROM python:${PY_BASE_IMG}

WORKDIR /app

# Install system dependencies
RUN apk add --update gcc python3-dev build-base libev-dev libffi-dev bash \
    openblas-dev lapack-dev musl-dev linux-headers

# Install Python packages directly in the Dockerfile
RUN pip3 install --no-cache-dir \
    bjoern==3.2.1 \
    blinker==1.4 \
    certifi==2021.10.8 \
    chardet==4.0.0 \
    charset-normalizer==2.0.7 \
    click==8.0.3 \
    Flask==2.1.1 \
    gevent==21.12.0 \
    gevent-ws==2.1.0 \
    greenlet==1.1.2 \
    hiredis==2.0.0 \
    httplib2==0.20.1 \
    idna==3.3 \
    importlib-metadata==4.11.3 \
    itsdangerous==2.0.1 \
    Jinja2==3.0.2 \
    MarkupSafe==2.0.1 \
    pyparsing==2.4.7 \
    python-dateutil==2.8.2 \
    redis==3.5.3 \
    requests==2.26.0 \
    sentry-sdk==1.5.10 \
    six==1.16.0 \
    urllib3==1.26.7 \
    Werkzeug==2.0.2 \
    zipp==3.8.0 \
    zope.event==4.5.0 \
    zope.interface==5.4.0 \
    elasticsearch8==8.11.0 \
    pandas==2.2.2 \
    scipy==1.13.0 \
    beautifulsoup4>=4.9.0 \
    nltk>=3.6.0 \
    emoji>=1.7.0 \
    transformers==4.21.0 \
    numpy==1.21.6

# Copy Python source files
COPY *.py /app/

# Environment settings
ENV PYTHONUNBUFFERED 1
ENTRYPOINT ["python3"]
CMD ["server.py"]