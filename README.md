Docker Image for Milter Greylist to Link to a Postfix Container
==============================================================

> **DEPRECATED.** This image is no longer maintained and the repository
> is archived. Greylisting is integrated in
> [mwaeckerlin/mailservice](https://github.com/mwaeckerlin/mailservice)
> (score-based, via [rspamd](https://github.com/mwaeckerlin/rspamd))
> since mailservice 3.0.0 — use that stack instead. The published
> Docker Hub image stays available as-is for existing standalone
> setups, but receives no updates or security fixes.

There is a SPAM prevention algorithmus named
[greylisting](https://wikipedia.org/wiki/Greylisting), which means
that any new sender of emails is blocked for some time. Only if the
sender retries the mail is delivered. The advantage of this mechanism
is, that most spammers only try to send an email once, while correctly
implemented mailers must retry. So a lot of spam never reaches your
mailbox.

It used to be Postgrey, but that package has been dropped in Alpine,
so this image is now migrated to Milter Greylist.

To enable greylisting, run this image next to a mail server image
(e.g. [mwaeckerlin/mailforward](https://hub.docker.com/r/mwaeckerlin/mailforward))
on a shared docker network and point the mail server's `GREYLIST`
environment variable at it (host name, optional `:port`, default
10025):

```yaml
services:
  postgrey:
    image: mwaeckerlin/postgrey
    # no published ports: the milter is only for the mail server —
    # reach it over the shared compose network. Publishing 10025 on
    # the host would let anyone speak the milter protocol to it.
  mailforward:
    image: mwaeckerlin/mailforward
    ports:
      - 25:25
    volumes:
      # production persistence bind-mount onto shared storage
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
