FROM docker.io/golang:1.26.1@sha256:c7e98cc0fd4dfb71ee7465fee6c9a5f079163307e4bf141b336bb9dae00159a5 AS builder

ENV CGO_ENABLED=0

# renovate: datasource=github-releases depName=google/go-jsonnet
ENV JSONNET_VERSION="v0.21.0"

RUN go install \
    "github.com/google/go-jsonnet/cmd/jsonnet@${JSONNET_VERSION}" \
    "github.com/google/go-jsonnet/cmd/jsonnetfmt@${JSONNET_VERSION}" \
    "github.com/google/go-jsonnet/cmd/jsonnet-deps@${JSONNET_VERSION}" \
    "github.com/google/go-jsonnet/cmd/jsonnet-lint@${JSONNET_VERSION}"


FROM docker.io/alpine:3.23@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659

COPY --from=builder /go/bin/jsonnet /usr/local/bin/
COPY --from=builder /go/bin/jsonnetfmt /usr/local/bin/
COPY --from=builder /go/bin/jsonnet-deps /usr/local/bin/
COPY --from=builder /go/bin/jsonnet-lint /usr/local/bin/
