ARG VERSION="dev"

FROM golang:1.17-alpine AS builder

WORKDIR $GOPATH/src/mypackage/myapp/

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download
COPY ./cmd/ops-test-app ./cmd/ops-test-app

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/bin/service ./cmd/ops-test-app/main.go

FROM alpine:3.15.0
ENV USER=appuser
ENV UID=1000
ENV GID=1000

RUN addgroup --gid "${GID}" appgroup

RUN adduser \
  --disabled-password \
  --gecos "" \
  --home "/nonexistent" \
  --shell "/sbin/nologin" \
  --no-create-home \
  --uid "${UID}" \
  -G appgroup \
  "${USER}"

USER 1000:1000

COPY --from=builder /go/bin/service /go/bin/service

CMD ["/go/bin/service"]
