# Build stage
FROM golang:1.18.8-alpine3.16 AS builder
WORKDIR /app
COPY . .
RUN go build -o childbank main.go

# Run stage
FROM alpine:3.16
WORKDIR /app
COPY --from=builder /app/childbank .
COPY app.env .

EXPOSE 8080

CMD ["/app/childbank"]