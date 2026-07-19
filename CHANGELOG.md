# Changelog

- 2026-07-18 **documentation hardening**
    - The compose example no longer publishes the milter port (10025)
      on the host: the milter speaks an unauthenticated protocol and
      is meant only for the mail server on the shared docker network.
    - The obsolete `--link` run example is gone.
