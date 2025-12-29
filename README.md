# trader-admin
交易员成长平台 (Trader admin)

# 交易员成长平台 (Trader Growth)

一个面向数字货币交易员的学习成长平台，提供系统化学习、交易记录、绩效分析和社区交流功能。

## 技术栈

- **前端**: Vue 3 + Vite + Element Plus + ECharts + md-editor-v3
- **后端**: Spring Boot 2.7 + JDK 1.8 + MyBatis Plus + Spring Security + JWT
- **数据库**: MySQL 5.7
- **部署**: Nginx + Jar + MySQL

## 项目结构

```
trader-growth/
├── docs/                    # 项目文档
├── sql/                     # 数据库脚本
├── trader-admin/            # 后端项目 (Spring Boot)
└── trader-web/              # 前端项目 (Vue 3)
```

## 快速开始

### 1. 数据库初始化

```bash
mysql -u root -p < sql/init.sql
```

### 2. 后端启动

```bash
cd trader-admin
# 修改 application.yml 中的数据库配置
mvn spring-boot:run
```

### 3. 前端启动

```bash
cd trader-web
npm install
npm run dev
```

### 4. 访问

- 前端: http://localhost:5173
- 后端API: http://localhost:8080/api
- 默认管理员账号: admin / admin123

## 功能模块

- **学习中心**: 课程管理、章节学习、进度追踪、学习笔记
- **交易日志**: 交易记录、截图上传、交易复盘
- **绩效分析**: 收益曲线、胜率统计、策略分析
- **社区交流**: 帖子发布、评论互动、点赞功能
- **工具箱**: 检查清单、每日分析、常用链接、计算器
- **系统管理**: 用户管理、课程管理（管理员）

## 部署

### Nginx配置示例

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        root /var/www/trader-web/dist;
        try_files $uri $uri/ /index.html;
    }

    location /api {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /uploads {
        alias /opt/trader-admin/uploads;
    }
}
```

### 后端打包

```bash
cd trader-admin
mvn clean package -DskipTests
java -jar target/trader-admin-1.0.0.jar
```

### 前端打包

```bash
cd trader-web
npm run build
# 将 dist 目录部署到 Nginx
```