# ===== 阶段1：构建层（使用官方轻量构建镜像）=====
FROM golang:1.25-alpine AS builder
# 设置工作目录
WORKDIR /app
# 安装构建依赖（仅必要工具）
RUN apk add --no-cache gcc musl-dev
# 复制依赖文件（利用缓存，优先复制go.mod）
COPY go.mod ./
RUN go mod download
# 复制源码
COPY . .
# 编译为静态二进制（无外部依赖）
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o app .

# ===== 阶段2：运行层（仅保留运行时）=====
FROM alpine:3.20
# 安全优化：创建非root用户
RUN adduser -D -H appuser
USER appuser
# 设置工作目录
WORKDIR /app
# 从构建层复制仅编译好的二进制文件
COPY --from=builder /app/app .
# 暴露端口（按需修改）
EXPOSE 8080
# 启动命令
CMD ["./app"]