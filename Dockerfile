# Build stage
FROM golang:1.18.8-alpine3.16 AS builder
WORKDIR /app
COPY . .
RUN go build -o childbank main.go
RUN apk --no-cache add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.14.1/migrate.linux-amd64.tar.gz | tar xvz

# Run stage
FROM alpine:3.16
WORKDIR /app
COPY --from=builder /app/childbank .
COPY --from=builder /app/migrate.linux-amd64 ./migrate
COPY app.env .
COPY /db/migration ./migration
COPY wait-for.sh .
COPY start.sh .

EXPOSE 8080

CMD ["/app/childbank"]
ENTRYPOINT [ "/app/start.sh" ]