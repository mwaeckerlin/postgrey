Docker Image for Postgrey to Link to a Postfix Container
========================================================

There is a SPAM prevention algorithmus named
[greylisting](https://wikipedia.org/wiki/Greylisting), which means
that any new sender of emails is blocked for some time. Only if the
sender retries the mail is delivered. The advantage of this mechanism
is, that most spammers only try to send an email once, while correctly
implemented mailers must retry. So a lot of spam never reaches your
mailbox.

To enable greylisting, run a separate greylisting container, using
e.g. [mwaeckerlin/postgrey](https://hub.docker.com/r/mwaeckerlin/postgrey/),
then either link it to this container or use the environment variable
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


Volumes
-------

Database is stored in `/data`.


Configuration
-------------

The following environment variables are supported:

 - `PORT`: port to listen, default 10023
 - `OPTIONS`: additional options to `postgrey`
 
Postgrey useful options:

```
Usage:
    postgrey [options...]

     -v, --verbose           increase verbosity level
     -q, --quiet             decrease verbosity level
         --delay=N           greylist for N seconds (default: 300)
         --max-age=N         delete entries older than N days since the last time
                             that they have been seen (default: 35)
         --retry-window=N    allow only N days for the first retrial (default: 2)
                             append 'h' if you want to specify it in hours
         --greylist-action=A if greylisted, return A to Postfix (default: DEFER_IF_PERMIT)
         --greylist-text=TXT response when a mail is greylisted
                             (default: Greylisted + help url, see below)
         --lookup-by-subnet  strip the last N bits from IP addresses, determined by ipv4cidr and ipv6cidr (default)
         --ipv4cidr=N        What cidr to use for the subnet on IPv4 addresses when using lookup-by-subnet (default: 24)
         --ipv6cidr=N        What cidr to use for the subnet on IPv6 addresses when using lookup-by-subnet (default: 64)
         --lookup-by-host    do not strip the last 8 bits from IP addresses
         --privacy           store data using one-way hash functions
         --hostname=NAME     set the hostname (default: `hostname`)
         --exim              don't reuse a socket for more than one query (exim compatible)
         --whitelist-clients=FILE     default: /etc/postfix/postgrey_whitelist_clients
         --whitelist-recipients=FILE  default: /etc/postfix/postgrey_whitelist_recipients
         --auto-whitelist-clients=N   whitelist host after first successful delivery
                                      N is the minimal count of mails before a client is 
                                      whitelisted (turned on by default with value 5)
                                      specify N=0 to disable.
         --listen-queue-size=N        allow for N waiting connections to our socket
         --x-greylist-header=TXT      header when a mail was delayed by greylisting
                                      default: X-Greylist: delayed <seconds> seconds by postgrey-<version> at <server>; <date>

     Note that the --whitelist-x options can be specified multiple times,
     and that per default /etc/postfix/postgrey_whitelist_clients.local is
     also read, so that you can put there local entries.
```
