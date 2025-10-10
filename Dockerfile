# Sử dụng Node LTS gọn nhẹ
FROM node:20-alpine

# Thư mục làm việc trong container
WORKDIR /usr/src/app

# Chỉ copy file manifest trước để tối ưu layer cache
COPY package*.json ./

# Cài dependencies ở chế độ production
# - Nếu bạn dùng npm: giữ lệnh dưới
RUN npm ci --omit=dev --no-audit --no-fund

# Nếu bạn dùng yarn, thay bằng:
# COPY yarn.lock ./
# RUN yarn install --frozen-lockfile --production

# Copy phần còn lại của code
COPY . .

# Biến môi trường
ENV NODE_ENV=production

# Back4App sẽ cung cấp PORT; ta vẫn EXPOSE 3000 để tương thích local
EXPOSE 3000

# Healthcheck (tuỳ chọn, giúp Back4App biết app đã sẵn sàng)
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://127.0.0.1:${PORT:-3000}/ || exit 1

# Lệnh chạy ứng dụng
CMD ["npm", "start"]
