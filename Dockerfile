# Build Geth in a stock Go builder container
FROM golang:1.17-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /bor
RUN cd /bor && make bor-all

# Pull Bor into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /bor/build/bin/bor /usr/local/bin/
COPY --from=builder /bor/build/bin/bootnode /usr/local/bin/

EXPOSE 8545 8546 8547 30303 30303/udp