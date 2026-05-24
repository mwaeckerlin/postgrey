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
CMD ["-w", "300", "-A", "-a", "5"]

FROM build
