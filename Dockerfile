# To build:
#    make docker-build
# To push:
#    make docker-push

FROM golang:1.22.5-bullseye as build
ARG GIT_COMMIT

WORKDIR /src/wallet-backend
ADD go.mod go.sum ./
RUN go mod download
ADD . ./
RUN go build -o /bin/wallet-backend -ldflags "-X main.GitCommit=$GIT_COMMIT" .


FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates
COPY --from=build /bin/wallet-backend /app/
EXPOSE 8001
WORKDIR /app
ENTRYPOINT ["./wallet-backend"]
