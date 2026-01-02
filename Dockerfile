FROM docker.io/golang:1.25.5@sha256:31c1e53dfc1cc2d269deec9c83f58729fa3c53dc9a576f6426109d1e319e9e9a AS builder

ENV CGO_ENABLED=0

# renovate: datasource=github-releases depName=google/go-jsonnet
ENV JSONNET_VERSION="v0.21.0"

RUN go install \
    "github.com/google/go-jsonnet/cmd/jsonnet@${JSONNET_VERSION}" \
    "github.com/google/go-jsonnet/cmd/jsonnetfmt@${JSONNET_VERSION}" \
    "github.com/google/go-jsonnet/cmd/jsonnet-deps@${JSONNET_VERSION}" \
    "github.com/google/go-jsonnet/cmd/jsonnet-lint@${JSONNET_VERSION}"


FROM docker.io/alpine:3.23@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62

COPY --from=builder /go/bin/jsonnet /usr/local/bin/
COPY --from=builder /go/bin/jsonnetfmt /usr/local/bin/
COPY --from=builder /go/bin/jsonnet-deps /usr/local/bin/
COPY --from=builder /go/bin/jsonnet-lint /usr/local/bin/
