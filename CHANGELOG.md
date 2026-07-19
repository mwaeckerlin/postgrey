# Changelog

- 2026-07-19 **deprecated**
    - The image is deprecated and the repository is archived:
      greylisting is integrated in mwaeckerlin/mailservice (rspamd)
      since mailservice 3.0.0. The Docker Hub image stays available
      for existing standalone setups but receives no further updates.
    - Removed the dead `health.sh` (telnet-based; never wired as a
      container healthcheck, telnet is not present in the image).

- 2026-07-18 **documentation hardening**
    - The compose example no longer publishes the milter port (10025)
      on the host: the milter speaks an unauthenticated protocol and
      is meant only for the mail server on the shared docker network.
    - The obsolete `--link` run example is gone.
