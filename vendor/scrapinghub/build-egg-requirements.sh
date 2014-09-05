#!/bin/bash

STACK=cedar
PYTHON_VERSION=python-2.7.8

set -e
set -x

cd /tmp

mkdir -p /tmp/python
curl -s http://lang-python.s3.amazonaws.com/$STACK/runtimes/$PYTHON_VERSION.tar.gz |\
  tar zx -C /tmp/python

PYTHON=/tmp/python/bin/python

wget -qO/tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
$PYTHON /tmp/get-pip.py
$PYTHON -m pip install wheel

apt-get update -q
apt-get install -qy build-essential python-dev libxml2-dev \
  libxslt1-dev libmysqlclient-dev libevent-dev libffi-dev

cat >reqs.txt <<!
BeautifulSoup==3.2.1
boto==2.31.1
cffi==0.8.6
characteristic==0.1.0
cryptography==0.5.3
cssselect==0.9.1
hubstorage==0.16.0
loginform==1.0
lxml==3.3.5
MySQL_python==1.2.5
nltk==2.0.4
numpy==1.6.1
pika==0.9.13
Pillow==1.7.8
psycopg2==2.4.5
pyasn1==0.1.7
pyasn1_modules==0.0.5
pycparser==2.10
pymongo==2.6.3
pyOpenSSL==0.14
PyYAML==3.11
queuelib==1.2.2
raven==3.5.2
requests==1.2.3
scrapely==0.11.0
scrapinghub==1.7.0
Scrapy==0.24.4
scrapylib==1.3.0
service_identity==1.0.0
setuptools==5.5.1
six==1.7.3
Twisted==14.0.0
w3lib==1.8.0
zope.interface==4.1.1
https://github.com/scrapy/slybot/archive/ba6a8b41.zip#egg=slybot
!

$PYTHON -m pip wheel --find-links wheelhouse -r reqs.txt
$PYTHON -m pip install wheelhouse/numpy*whl
$PYTHON -m pip wheel scikit_learn==0.13.1
tar cf wheelhouse.tar wheelhouse
