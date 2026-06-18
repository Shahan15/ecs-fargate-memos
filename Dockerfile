#Stage 1: FrontEnd 
FROM node:24-alpine AS frontend
WORKDIR /app/web
COPY app/web .
RUN npm install -g pnpm && pnpm install && pnpm release


#Stage 2: Backend
FROM golang:1.26.2-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git ca-certificates
COPY app/go.mod app/go.sum ./
RUN go mod download 
COPY /app .
COPY --from=frontend app/server/router/frontend/dist  ./server/router/frontend/dist
RUN --mount=type=cache,target=/root/.cache/go-build \
 CGO_ENABLED=0 go build -o memos ./cmd/memos

#Stage 3: Final Image
FROM scratch AS runner
WORKDIR /app
COPY --from=builder etc/ssl/certs/ca-certificates.crt /etc/ssl/certs
COPY --from=builder /app/memos .
EXPOSE 8081
CMD [ "./memos" ]