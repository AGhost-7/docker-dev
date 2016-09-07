FROM golang:1.4

RUN go get github.com/mailhog/MailHog && \
	go get github.com/mailhog/mhsendmail

ENTRYPOINT ["/go/bin/MailHog"]

