<div align="center">

# 🎯 Interview Question Hub

**Nền tảng tổng hợp câu hỏi phỏng vấn theo chuyên ngành**

[![React](https://img.shields.io/badge/React-18-61DAFB?style=for-the-badge&logo=react&logoColor=black)](https://reactjs.org/)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3-6DB33F?style=for-the-badge&logo=spring-boot&logoColor=white)](https://spring.io/projects/spring-boot)
[![TypeScript](https://img.shields.io/badge/TypeScript-5-3178C6?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)](https://www.microsoft.com/sql-server)

</div>

---

## 📖 Giới thiệu

**Interview Question Hub** là web app giúp ứng viên chuẩn bị phỏng vấn hiệu quả thông qua bộ câu hỏi & câu trả lời được tổng hợp theo từng chuyên ngành nghề nghiệp.

- 🔍 **Tìm kiếm** câu hỏi theo từ khóa
- 🗂️ **Phân loại** theo ngành: IT, Marketing, HR, Content, Sales, Finance...
- 📊 **Lọc** theo mức độ khó: Cơ bản / Trung bình / Nâng cao
- 🔖 **Bookmark** câu hỏi yêu thích (cần đăng nhập)
- 👨‍💼 **Admin Panel** quản lý câu hỏi và chuyên ngành

---

## 🛠️ Tech Stack

| Layer | Công nghệ |
|-------|-----------|
| **Frontend** | React 18, TypeScript, Vite, React Router |
| **Backend** | Spring Boot 3, Spring Data JPA, Spring Security |
| **Database** | Microsoft SQL Server |
| **Auth** | JWT (JSON Web Token) |
| **API Docs** | Swagger / OpenAPI |

---

## 📁 Cấu trúc dự án

```
Interview-question-hub/
├── frontend/                  # React + Vite app (port 5173)
│   ├── src/
│   │   ├── api/               # Axios API calls
│   │   ├── components/        # UI Components
│   │   ├── pages/             # Trang: Home, Category, Detail
│   │   ├── types/             # TypeScript interfaces
│   │   └── data/              # Demo data
│   └── vite.config.ts
│
├── backend/                   # Spring Boot app (port 8080)
│   └── src/main/java/com/project3/
│       ├── controller/        # REST Controllers
│       ├── service/           # Business Logic
│       ├── repository/        # JPA Repositories
│       ├── entity/            # JPA Entities
│       ├── dto/               # Request/Response DTOs
│       └── security/          # JWT & Spring Security
│
├── database/                  # SQL scripts
│   └── seed_*.sql             # Dữ liệu mẫu từng ngành
│
└── CONTEXT.md                 # Tài liệu kiến trúc hệ thống
```

---

## 🚀 Hướng dẫn chạy dự án

### Yêu cầu hệ thống
- Node.js ≥ 18
- Java ≥ 17
- Microsoft SQL Server
- Maven

### 1. Clone repository

```bash
git clone https://github.com/NguyenGiap2804/Interview-question-hub.git
cd Interview-question-hub
```

### 2. Cấu hình Database

Tạo database trong SQL Server:
```sql
CREATE DATABASE InterviewQuestionHub;
```

Chạy file SQL schema và seed data trong thư mục `database/`.

### 3. Chạy Backend

```bash
cd backend
# Cập nhật thông tin kết nối trong application.yml
mvn spring-boot:run
```

Backend chạy tại: `http://localhost:8080`  
Swagger UI: `http://localhost:8080/swagger-ui.html`

### 4. Chạy Frontend

```bash
cd frontend
npm install
npm run dev
```

Frontend chạy tại: `http://localhost:5173`

---

## ⚙️ Cấu hình

Cập nhật file `backend/src/main/resources/application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:sqlserver://localhost;instanceName=MSSQLSERVER01;databaseName=InterviewQuestionHub;encrypt=true;trustServerCertificate=true
    username: sa
    password: your_password
```

---

## 📡 API Endpoints

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| GET | `/api/categories` | Danh sách chuyên ngành |
| GET | `/api/categories/{id}/questions` | Câu hỏi theo ngành |
| GET | `/api/questions` | Tất cả câu hỏi (có filter) |
| GET | `/api/questions/search?keyword=` | Tìm kiếm |
| POST | `/api/auth/login` | Đăng nhập |
| POST | `/api/auth/register` | Đăng ký |

---

## 🗺️ Roadmap

- [x] Hiển thị câu hỏi theo chuyên ngành
- [x] Tìm kiếm & lọc câu hỏi
- [x] REST API với Spring Boot
- [ ] Authentication với JWT
- [ ] Tính năng Bookmark
- [ ] Admin Dashboard
- [ ] Dark Mode
- [ ] AI gợi ý câu trả lời

---

## 👤 Tác giả

**Nguyen Giap** – [@NguyenGiap2804](https://github.com/NguyenGiap2804)

---

<div align="center">
  <sub>Built with ❤️ using React & Spring Boot</sub>
</div>
