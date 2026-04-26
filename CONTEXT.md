# 📋 CONTEXT – Interview Question Hub

> Tài liệu mô tả tổng quan hệ thống Web App tổng hợp câu hỏi phỏng vấn theo chuyên ngành.

---

## 1. Tổng Quan Dự Án

**Tên dự án:** Interview Question Hub  
**Mục tiêu:** Xây dựng một nền tảng web tổng hợp các câu hỏi & câu trả lời phỏng vấn, được phân loại theo từng chuyên ngành nghề nghiệp, giúp ứng viên chuẩn bị tốt hơn cho các buổi phỏng vấn tuyển dụng.

**Đối tượng sử dụng:**
- Ứng viên đang tìm việc, chuẩn bị phỏng vấn
- Nhà tuyển dụng / HR muốn tham khảo bộ câu hỏi theo ngành
- Sinh viên mới ra trường cần định hướng kiến thức phỏng vấn

---

## 2. Tech Stack

### Frontend
| Công nghệ | Mô tả |
|---|---|
| **React** (v18+) | Framework UI chính |
| **React Router DOM** | Điều hướng trang |
| **Axios** | Giao tiếp HTTP với backend |
| **Redux Toolkit** hoặc **Zustand** | Quản lý state toàn cục |
| **TailwindCSS** hoặc **MUI** | Thư viện UI / Styling |
| **Vite** | Build tool (thay thế CRA) |

### Backend
| Công nghệ | Mô tả |
|---|---|
| **Spring Boot** (v3+) | Framework backend chính |
| **Spring Data JPA** | ORM – tương tác với database |
| **Spring Security + JWT** | Xác thực & phân quyền |
| **Spring Web MVC** | Xây dựng REST API |
| **MySQL / PostgreSQL** | Database quan hệ chính |
| **Lombok** | Giảm boilerplate code |
| **MapStruct** | Mapping Entity ↔ DTO |

### Hạ tầng & Công cụ
| Công nghệ | Mô tả |
|---|---|
| **Docker / Docker Compose** | Container hóa môi trường |
| **Maven** | Build tool cho Java |
| **Swagger / OpenAPI** | Tài liệu hóa API |
| **Git + GitHub** | Quản lý phiên bản |

---

## 3. Kiến Trúc Hệ Thống

```
┌─────────────────────────────────────────────────────────┐
│                    CLIENT (Browser)                     │
│                React SPA – Port 3000                    │
└───────────────────────┬─────────────────────────────────┘
                        │ HTTP / REST API (JSON)
                        ▼
┌─────────────────────────────────────────────────────────┐
│                  BACKEND (Spring Boot)                  │
│                   REST API – Port 8080                  │
│  ┌─────────────┐  ┌───────────┐  ┌──────────────────┐  │
│  │  Controller │→ │  Service  │→ │   Repository     │  │
│  │  (REST API) │  │ (Business │  │ (Spring Data JPA)│  │
│  └─────────────┘  │  Logic)   │  └──────────────────┘  │
│                   └───────────┘          │              │
└──────────────────────────────────────────┼──────────────┘
                                           ▼
┌─────────────────────────────────────────────────────────┐
│                      DATABASE                           │
│                  MySQL / PostgreSQL                     │
└─────────────────────────────────────────────────────────┘
```

**Luồng xử lý chính:**
1. Người dùng truy cập frontend React → chọn chuyên ngành
2. Frontend gọi API tới Spring Boot backend
3. Backend truy vấn database → trả về dữ liệu JSON
4. Frontend render danh sách câu hỏi & câu trả lời

---

## 4. Các Chuyên Ngành (Category)

Hệ thống hỗ trợ nhiều chuyên ngành, mỗi ngành chứa bộ câu hỏi phỏng vấn riêng:

| ID | Chuyên Ngành | Slug | Mô tả |
|---|---|---|---|
| 1 | Truyền Thông | `truyen-thong` | PR, Media Relations, Báo chí |
| 2 | Content | `content` | Content Writer, Copywriter, SEO Content |
| 3 | Marketing | `marketing` | Digital Marketing, Brand, Performance |
| 4 | Công nghệ thông tin | `it` | Software Dev, DevOps, QA, BA |
| 5 | Nhân sự (HR) | `hr` | Tuyển dụng, C&B, HR Generalist |
| 6 | Kinh doanh | `sales` | Sales, Business Development |
| 7 | Thiết kế | `design` | UI/UX, Graphic Design |
| 8 | Tài chính | `finance` | Kế toán, Kiểm toán, Tài chính |

> 💡 Danh sách có thể mở rộng linh hoạt qua Admin Panel.

---

## 5. Tính Năng Chính

### 5.1 Dành Cho Người Dùng (Guest / User)

- **Trang chủ:** Hiển thị danh sách các chuyên ngành dưới dạng card
- **Danh sách câu hỏi:** Xem toàn bộ câu hỏi theo chuyên ngành đã chọn
- **Chi tiết câu hỏi:** Xem câu hỏi + câu trả lời gợi ý chi tiết
- **Tìm kiếm:** Tìm kiếm câu hỏi theo từ khóa
- **Lọc câu hỏi:** Lọc theo mức độ khó (Cơ bản / Trung bình / Nâng cao)
- **Lưu câu hỏi yêu thích:** (Cần đăng nhập) Bookmark các câu hỏi quan trọng
- **Đăng ký / Đăng nhập:** Tài khoản cá nhân với JWT Authentication

### 5.2 Dành Cho Admin

- **Quản lý chuyên ngành:** CRUD danh mục chuyên ngành
- **Quản lý câu hỏi:** CRUD câu hỏi & câu trả lời
- **Quản lý người dùng:** Xem, khoá, xoá tài khoản
- **Thống kê:** Số lượng câu hỏi theo ngành, lượt xem

---

## 6. Mô Hình Dữ Liệu (Database Schema)

### Bảng `categories` – Chuyên ngành
```sql
CREATE TABLE categories (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    slug        VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon_url    VARCHAR(255),
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Bảng `questions` – Câu hỏi
```sql
CREATE TABLE questions (
    id            BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_id   BIGINT NOT NULL,
    title         TEXT NOT NULL,
    answer        LONGTEXT NOT NULL,
    difficulty    ENUM('BASIC', 'INTERMEDIATE', 'ADVANCED') DEFAULT 'BASIC',
    view_count    INT DEFAULT 0,
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);
```

### Bảng `users` – Người dùng
```sql
CREATE TABLE users (
    id            BIGINT PRIMARY KEY AUTO_INCREMENT,
    username      VARCHAR(50) UNIQUE NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role          ENUM('USER', 'ADMIN') DEFAULT 'USER',
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### Bảng `bookmarks` – Câu hỏi yêu thích
```sql
CREATE TABLE bookmarks (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id     BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_user_question (user_id, question_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);
```

---

## 7. Thiết Kế API (REST Endpoints)

### Auth API
| Method | Endpoint | Mô tả |
|---|---|---|
| POST | `/api/auth/register` | Đăng ký tài khoản |
| POST | `/api/auth/login` | Đăng nhập, trả về JWT |
| POST | `/api/auth/logout` | Đăng xuất |

### Category API
| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api/categories` | Lấy tất cả chuyên ngành |
| GET | `/api/categories/{id}` | Chi tiết chuyên ngành |
| POST | `/api/admin/categories` | Tạo mới (Admin) |
| PUT | `/api/admin/categories/{id}` | Cập nhật (Admin) |
| DELETE | `/api/admin/categories/{id}` | Xoá (Admin) |

### Question API
| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api/questions` | Lấy tất cả câu hỏi (có filter) |
| GET | `/api/questions/{id}` | Chi tiết câu hỏi |
| GET | `/api/categories/{id}/questions` | Câu hỏi theo chuyên ngành |
| GET | `/api/questions/search?keyword=xxx` | Tìm kiếm câu hỏi |
| POST | `/api/admin/questions` | Tạo mới (Admin) |
| PUT | `/api/admin/questions/{id}` | Cập nhật (Admin) |
| DELETE | `/api/admin/questions/{id}` | Xoá (Admin) |

### Bookmark API (Cần xác thực)
| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api/bookmarks` | Lấy danh sách bookmark của user |
| POST | `/api/bookmarks/{questionId}` | Thêm bookmark |
| DELETE | `/api/bookmarks/{questionId}` | Xoá bookmark |

---

## 8. Cấu Trúc Thư Mục Dự Án

```
Project3/
├── frontend/                        # React App
│   ├── public/
│   ├── src/
│   │   ├── api/                     # Axios API calls
│   │   ├── components/              # UI Components dùng chung
│   │   ├── pages/                   # Các trang: Home, Category, Detail...
│   │   ├── store/                   # State management (Redux/Zustand)
│   │   ├── hooks/                   # Custom React hooks
│   │   ├── utils/                   # Hàm tiện ích
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── package.json
│   └── vite.config.js
│
├── backend/                         # Spring Boot App
│   ├── src/main/java/com/project3/
│   │   ├── controller/              # REST Controllers
│   │   ├── service/                 # Business Logic
│   │   ├── repository/              # JPA Repositories
│   │   ├── entity/                  # JPA Entities
│   │   ├── dto/                     # Request / Response DTOs
│   │   ├── mapper/                  # MapStruct Mappers
│   │   ├── security/                # JWT, Spring Security config
│   │   ├── exception/               # Global Exception Handler
│   │   └── config/                  # App Configuration (CORS, Swagger...)
│   ├── src/main/resources/
│   │   └── application.yml
│   └── pom.xml
│
├── docker-compose.yml               # Docker orchestration
├── CONTEXT.md                       # File này
└── README.md
```

---

## 9. Bảo Mật & Phân Quyền

| Role | Quyền hạn |
|---|---|
| **GUEST** (chưa đăng nhập) | Xem câu hỏi, tìm kiếm, lọc |
| **USER** (đã đăng nhập) | + Lưu bookmark |
| **ADMIN** | Toàn quyền CRUD dữ liệu + quản lý user |

**Cơ chế xác thực:**
- Sử dụng **JWT (JSON Web Token)** – stateless
- Token được lưu ở `localStorage` hoặc `httpOnly Cookie` trên frontend
- Backend validate token qua `Spring Security Filter Chain`

---

## 10. Giao Diện – UI/UX Concept

- **Trang chủ:** Grid card các chuyên ngành với icon, màu sắc đặc trưng
- **Trang danh sách câu hỏi:** Accordion / Card list với badge mức độ khó
- **Trang chi tiết câu hỏi:** Layout 2 cột (câu hỏi trái, câu trả lời phải) hoặc expand/collapse
- **Tìm kiếm:** Searchbar realtime với debounce
- **Responsive:** Hỗ trợ Mobile / Tablet / Desktop

---

## 11. Lộ Trình Phát Triển (Roadmap)

### Phase 1 – MVP
- [ ] Thiết lập project React + Spring Boot
- [ ] Thiết kế Database & API cơ bản
- [ ] CRUD Chuyên ngành & Câu hỏi (Admin)
- [ ] Hiển thị câu hỏi theo chuyên ngành (Public)
- [ ] Tìm kiếm & Lọc câu hỏi

### Phase 2 – Authentication
- [ ] Đăng ký / Đăng nhập với JWT
- [ ] Phân quyền USER / ADMIN
- [ ] Tính năng Bookmark

### Phase 3 – Enhancement
- [ ] Admin Dashboard với thống kê
- [ ] Phân trang (Pagination)
- [ ] Dark Mode
- [ ] Tính năng gợi ý câu hỏi liên quan

### Phase 4 – Advanced (Tùy chọn)
- [ ] AI tích hợp – tự động sinh câu trả lời gợi ý
- [ ] Người dùng tự đóng góp câu hỏi (với duyệt)
- [ ] Export PDF bộ câu hỏi theo ngành

---

*Cập nhật lần cuối: 2026-04-26*
