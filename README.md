Docker Image for Milter Greylist to Link to a Postfix Container
==============================================================

There is a SPAM prevention algorithmus named
[greylisting](https://wikipedia.org/wiki/Greylisting), which means
that any new sender of emails is blocked for some time. Only if the
sender retries the mail is delivered. The advantage of this mechanism
is, that most spammers only try to send an email once, while correctly
implemented mailers must retry. So a lot of spam never reaches your
mailbox.

It used to be Postgrey, but that package has been dropped in Alpine,
so this image is now migrated to Milter Greylist.

To enable greylisting, run a separate greylisting container, using
e.g. [mwaeckerlin/postgrey](https://hub.docker.com/r/mwaeckerlin/postgrey/),
then either link it to this container or use the environment variable
`GREYLIST` to specify the greylisting container's host name (optional :port):

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
      - 10025:10025
  mailforward:
    image: mwaeckerlin/mailforward
    ports:
      - 25:25
    volumes:
      - type: bind
        source: /srv/volumes/reverse-proxy/letsencrypt
        target: /etc/letsencrypt
    environment:
      - 'GREYLIST=postgrey'
      - 'MAPPINGS=…'
```


Volumes
-------

Database is stored in `/data/greylist.db`.


Configuration
-------------

The container listens on port 10025.
 
Milter-greylist useful options:

```
Usage:
  milter-greylist [options...]

  -p socket         milter socket, e.g. inet:10025@0.0.0.0
  -f configfile     config file, default /etc/milter-greylist/greylist.conf
  -w delay          greylist delay in seconds
  -u user[:group]   run as user/group

Configuration is primarily done in /etc/milter-greylist/greylist.conf.
```
