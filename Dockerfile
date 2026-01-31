# Build stage
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache gcc musl-dev

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN go build -ldflags="-s -w" -o whatsappapi main.go

# Final stage
FROM alpine:latest

WORKDIR /app

# Install runtime dependencies (sqlite needs some libs if not using modernc, but we are)
RUN apk add --no-cache ca-certificates tzdata

# Copy binary from builder
COPY --from=builder /app/whatsappapi .

# Expose port
EXPOSE 1012

# Command to run
CMD ["./whatsappapi"]
