Docker Image for Postgrey to Link to a Postfix Container
========================================================

There is a SPAM prevention algorithmus named
[greylisting](https://wikipedia.org/wiki/Greylisting), which means
that any new sender of emails is blocked for some times. Only if the
sender retries the mail is delivered. The advantage of this mechanism
is, that most spammers only try to send an email once, while correctly
implemented mailers must retry. So a lot of spam never reaches your
mailbox.

To enable greylisting, run a separate greylisting container, using
e.g. [mwaeckerlin/postgrey](https://hub.docker.com/r/mwaeckerlin/postgrey/),
then either link it to this container or use teh environment variable
`GREYLIST` to specify the greylisting container's url and port:

   docker run -d --restart unless-stopped --name postgrey \
              mwaeckerlin/postgrey
   docker run -d --restart unless-stopped --name mailforward \
              -p 25:25 \
              -e 'MAPPINGS=…' \
              --link postgrey:postgrey \
              mwaeckerlin/mailforward

Alternatively, e.g. for docker swarm, specify a yaml file:

```
version: '3.3'
services:
  postgrey:
    image: mwaeckerlin/postgrey
    ports:
      - 10023:10023
  mailforward:
    image: mwaeckerlin/mailforward
    ports:
      - 25:25
    volumes:
      - type: bind
        source: /srv/volumes/reverse-proxy/letsencrypt
        target: /etc/letsencrypt
    environment:
      - 'GREYLIST=postgrey:10023'
      - 'MAPPINGS=…'
```
