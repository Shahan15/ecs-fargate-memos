#Stage 1: FrontEnd 
FROM node:24 AS frontend
WORKDIR /app/web
COPY app/web .
RUN npm install -g pnpm && pnpm install && pnpm release


#Stage 2: Backend
FROM golang:1.26.2-alpine AS backend
WORKDIR /app
COPY /app .
COPY --from=frontend app/server/router/frontend/dist  ./server/router/frontend/dist
EXPOSE 8081
RUN go build -o memos ./cmd/memos
CMD ["./memos"]