FROM mwaeckerlin/very-base AS build

ENV CONTAINERNAME "milter-greylist"
RUN $PKG_INSTALL milter-greylist
RUN mkdir -p /data /var/lib/milter-greylist /var/run/milter-greylist
RUN $ALLOW_USER /data /var/lib/milter-greylist /var/run/milter-greylist
ADD greylist.conf /etc/milter-greylist/greylist.conf

EXPOSE 10025
VOLUME /data
USER $RUN_USER
ENTRYPOINT ["/usr/bin/milter-greylist", "-D", "-p", "inet:10025@0.0.0.0", "-f", "/etc/milter-greylist/greylist.conf", "-d", "/data/greylist.db"]
# -w 300: 5 min greylist delay; -a 35d: auto-whitelist a passed tuple for 35
# days (the classic postgrey defaults). NEVER pass -A — it disables the
# SMTP-AUTH whitelisting, so our own users' submissions would be greylisted.
CMD ["-w", "300", "-a", "35d"]

FROM build
