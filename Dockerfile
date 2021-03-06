# builder
FROM registry.access.redhat.com/ubi8/go-toolset:latest AS builder
ARG ARCH
ARG VERSION
ARG GITREV
ARG GOVARS
RUN echo $ARCH
RUN echo $VERSION
RUN echo $GITREV
RUN echo $GOVARS

# prepare
WORKDIR /opt/app-root/src
COPY go.mod go.mod
COPY go.sum go.sum
COPY cmd/ cmd/
COPY internal/ internal/
COPY vendor/ vendor/

# build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$ARCH \
  go build -a -o /opt/app-root/src/hpessa-exporter \
  -ldflags="-s -w $GOVARS" cmd/main.go

# image
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
COPY --from=builder /opt/app-root/src/hpessa-exporter /bin
USER 65532:65532

ENTRYPOINT ["/bin/sh"]
EXPOSE 8080
