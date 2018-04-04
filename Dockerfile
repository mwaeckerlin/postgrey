FROM mwaeckerlin/ubuntu-base
MAINTAINER mwaeckerlin

EXPOSE 10023

RUN apt-get install -y postgrey postfix-
