FROM mwaeckerlin/base

ENV PORT=10023
ENV OPTIONS=

ENV CONTAINERNAME "postgrey"
RUN $PKG_INSTALL postgrey \
    && mkdir /data \
    && $ALLOW_USER /data \
    && ln -sf /proc/1/fd/1 /var/log/mail.log

EXPOSE $PORT
VOLUME /data
USER $RUN_USER
