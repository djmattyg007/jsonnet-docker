FROM docker.io/golang:1.25.5@sha256:a22b2e6c5e753345b9759fba9e5c1731ebe28af506745e98f406cc85d50c828e AS builder

ENV CGO_ENABLED=0

# renovate: datasource=github-releases depName=google/go-jsonnet
ENV JSONNET_VERSION="v0.21.0"

RUN go install \
    "github.com/google/go-jsonnet/cmd/jsonnet@${JSONNET_VERSION}" \
    "github.com/google/go-jsonnet/cmd/jsonnetfmt@${JSONNET_VERSION}" \
    "github.com/google/go-jsonnet/cmd/jsonnet-deps@${JSONNET_VERSION}" \
    "github.com/google/go-jsonnet/cmd/jsonnet-lint@${JSONNET_VERSION}"


FROM docker.io/alpine:3.23@sha256:51183f2cfa6320055da30872f211093f9ff1d3cf06f39a0bdb212314c5dc7375

COPY --from=builder /go/bin/jsonnet /usr/local/bin/
COPY --from=builder /go/bin/jsonnetfmt /usr/local/bin/
COPY --from=builder /go/bin/jsonnet-deps /usr/local/bin/
COPY --from=builder /go/bin/jsonnet-lint /usr/local/bin/
