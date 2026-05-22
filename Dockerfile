FROM mwaeckerlin/very-base

ENV CONTAINERNAME "milter-greylist"
RUN $PKG_INSTALL milter-greylist \
    && mkdir -p /data /var/lib/milter-greylist /var/run/milter-greylist \
    && $ALLOW_USER /data /var/lib/milter-greylist /var/run/milter-greylist \
    && sed -i '/^stat "/d' /etc/milter-greylist/greylist.conf \
    && printf '%s\n' 'stat "|cat" "%T{%Y/%m/%d %T} %d [%i] %f -> %r %S (ACL %A) %Xc %Xe %Xm %Xh"' >> /etc/milter-greylist/greylist.conf

EXPOSE 10025
VOLUME /data
USER $RUN_USER
ENTRYPOINT ["/usr/bin/milter-greylist", "-c", "-p", "inet:0.0.0.0:10025", "-f", "/etc/milter-greylist/greylist.conf", "-d", "/data/greylist.db"]
CMD ["-w", "300", "-A", "-a", "5"]
