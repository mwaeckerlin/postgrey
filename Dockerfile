FROM mwaeckerlin/ubuntu-base
MAINTAINER mwaeckerlin

EXPOSE 10023

RUN apt-get install --no-install-recommends --no-install-suggests -y postgrey postfix-
