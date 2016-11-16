FROM ubuntu
MAINTAINER mwaeckerlin
ENV TERM xterm

EXPOSE 10023

RUN apt-get update
RUN apt-get install -y postgrey postfix-

ADD start.sh /start.sh
CMD /start.sh
