FROM docker.io/golang:1.26.2@sha256:b54cbf583d390341599d7bcbc062425c081105cc5ef6d170ced98ef9d047c716 AS builder

ENV CGO_ENABLED=0

# renovate: datasource=github-releases depName=google/go-jsonnet
ENV JSONNET_VERSION="v0.22.0"

RUN go install \
    "github.com/google/go-jsonnet/cmd/jsonnet@${JSONNET_VERSION}" \
    "github.com/google/go-jsonnet/cmd/jsonnetfmt@${JSONNET_VERSION}" \
    "github.com/google/go-jsonnet/cmd/jsonnet-deps@${JSONNET_VERSION}" \
    "github.com/google/go-jsonnet/cmd/jsonnet-lint@${JSONNET_VERSION}"


FROM docker.io/alpine:3.23@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

COPY --from=builder /go/bin/jsonnet /usr/local/bin/
COPY --from=builder /go/bin/jsonnetfmt /usr/local/bin/
COPY --from=builder /go/bin/jsonnet-deps /usr/local/bin/
COPY --from=builder /go/bin/jsonnet-lint /usr/local/bin/
