#Stage 1: FrontEnd 
FROM node:24-alpine AS frontend
WORKDIR /app/web
COPY app/web .
RUN npm install -g pnpm && pnpm install && pnpm release


#Stage 2: Backend
FROM golang:1.26.2-alpine AS builder
WORKDIR /app
COPY /app .
COPY --from=frontend app/server/router/frontend/dist  ./server/router/frontend/dist
RUN go build -o memos ./cmd/memos

#Stage 3: Final Image
FROM alpine:3.21 AS final
WORKDIR /app
COPY --from=builder /app /app
EXPOSE 8081
CMD [ "./memos" ]




