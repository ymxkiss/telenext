# ============================================================
# TeleBox-Next Dockerfile
# 下一代 Telegram UserBot 框架
# 基于 Debian 12 + Node.js 24.x + PM2
# ============================================================

FROM debian:12-slim

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        python3 \
        git \
        curl \
        wget \
        ca-certificates \
        fonts-noto-cjk \
    && rm -rf /var/lib/apt/lists/*

# 安装 Node.js 24.x
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
 && apt-get install -y nodejs \
 && rm -rf /var/lib/apt/lists/*

# 安装 PM2
RUN npm install -g pm2

WORKDIR /app

# 克隆项目
RUN git clone https://github.com/TeleBoxOrg/TeleBox-Next.git /app

# 安装项目依赖
RUN npm ci --ignore-scripts 2>/dev/null || npm install --ignore-scripts

# 预编译插件（可选）
RUN npm run precompile 2>/dev/null || true

# 创建数据目录
RUN mkdir -p /app/data /app/plugins /app/logs /app/assets

# 启动命令
CMD ["npm", "start"]
