# ---------- build stage ----------
FROM golang:1.24.4-alpine3.22 AS builder

WORKDIR /app
RUN apk add --no-cache curl git

# build your Go API
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o main main.go

# fetch migrate CLI binary
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.17.0/migrate.linux-amd64.tar.gz | tar xvz && \
    mv migrate /usr/local/bin/migrate && \
    chmod +x /usr/local/bin/migrate

# ---------- run stage ----------
FROM alpine:3.22

WORKDIR /app

# API binary
COPY --from=builder /app/main .

# migrate CLI
COPY --from=builder /usr/local/bin/migrate /usr/local/bin/migrate

# app files
COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./migration

RUN chmod +x /app/start.sh /app/wait-for.sh

EXPOSE 8080

CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]

