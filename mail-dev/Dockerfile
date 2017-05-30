# vim: set ft=dockerfile:

FROM golang:1.6

RUN go get github.com/mailhog/MailHog && \
	go get github.com/AGhost-7/mhsendmail

RUN echo '{ "default": { "name": "default", "host": "app", "port": "2525" } }' > /outgoing.json

# Workaround due to pipes not working afaik.
RUN echo '#!/usr/bin/env bash\necho "$1" | /go/bin/mhsendmail "${@:2}"' > /sendmail && \
	chmod +x /sendmail

ENV MH_OUTGOING_SMTP /outgoing.json

ENV MH_SMTP_BIND_ADDR 0.0.0.0:25

ENTRYPOINT ["/go/bin/MailHog"]
