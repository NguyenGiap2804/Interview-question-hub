/*
  Interview Question Hub - SQL Server database, schema, and Vietnamese seed data
  Target: Microsoft SQL Server

  Database: InterviewQuestionHub

  Seed count:
  - categories: 50 rows
  - users: 50 rows
  - questions: 50 rows
  - bookmarks: 50 rows
  - tags: 50 rows
  - question_tags: 50 rows
  - question_views: 50 rows
  - practice_sessions: 50 rows
  - practice_session_questions: 50 rows
  - roles: 3 rows
  - user_roles: 50 rows
*/

SET NOCOUNT ON;
GO

IF DB_ID(N'InterviewQuestionHub') IS NULL
BEGIN
    CREATE DATABASE InterviewQuestionHub;
END
GO

USE InterviewQuestionHub;
GO

IF OBJECT_ID(N'dbo.practice_session_questions', N'U') IS NOT NULL DROP TABLE dbo.practice_session_questions;
IF OBJECT_ID(N'dbo.practice_sessions', N'U') IS NOT NULL DROP TABLE dbo.practice_sessions;
IF OBJECT_ID(N'dbo.question_views', N'U') IS NOT NULL DROP TABLE dbo.question_views;
IF OBJECT_ID(N'dbo.question_tags', N'U') IS NOT NULL DROP TABLE dbo.question_tags;
IF OBJECT_ID(N'dbo.user_roles', N'U') IS NOT NULL DROP TABLE dbo.user_roles;
IF OBJECT_ID(N'dbo.bookmarks', N'U') IS NOT NULL DROP TABLE dbo.bookmarks;
IF OBJECT_ID(N'dbo.questions', N'U') IS NOT NULL DROP TABLE dbo.questions;
IF OBJECT_ID(N'dbo.tags', N'U') IS NOT NULL DROP TABLE dbo.tags;
IF OBJECT_ID(N'dbo.users', N'U') IS NOT NULL DROP TABLE dbo.users;
IF OBJECT_ID(N'dbo.roles', N'U') IS NOT NULL DROP TABLE dbo.roles;
IF OBJECT_ID(N'dbo.categories', N'U') IS NOT NULL DROP TABLE dbo.categories;
GO

CREATE TABLE dbo.categories (
    id BIGINT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    slug VARCHAR(120) NOT NULL,
    description NVARCHAR(500) NULL,
    icon_url NVARCHAR(255) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT df_categories_created_at DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT df_categories_updated_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_categories PRIMARY KEY CLUSTERED (id),
    CONSTRAINT uq_categories_slug UNIQUE (slug)
);

CREATE TABLE dbo.users (
    id BIGINT IDENTITY(1,1) NOT NULL,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CONSTRAINT df_users_role DEFAULT 'USER',
    is_active BIT NOT NULL CONSTRAINT df_users_is_active DEFAULT 1,
    created_at DATETIME2(0) NOT NULL CONSTRAINT df_users_created_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_users PRIMARY KEY CLUSTERED (id),
    CONSTRAINT uq_users_username UNIQUE (username),
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT ck_users_role CHECK (role IN ('USER', 'ADMIN'))
);

CREATE TABLE dbo.roles (
    id BIGINT IDENTITY(1,1) NOT NULL,
    code VARCHAR(30) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(300) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT df_roles_created_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_roles PRIMARY KEY CLUSTERED (id),
    CONSTRAINT uq_roles_code UNIQUE (code)
);

CREATE TABLE dbo.user_roles (
    id BIGINT IDENTITY(1,1) NOT NULL,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    assigned_at DATETIME2(0) NOT NULL CONSTRAINT df_user_roles_assigned_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_user_roles PRIMARY KEY CLUSTERED (id),
    CONSTRAINT fk_user_roles_users FOREIGN KEY (user_id) REFERENCES dbo.users(id),
    CONSTRAINT fk_user_roles_roles FOREIGN KEY (role_id) REFERENCES dbo.roles(id),
    CONSTRAINT uq_user_roles_user_role UNIQUE (user_id, role_id)
);

CREATE TABLE dbo.tags (
    id BIGINT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(80) NOT NULL,
    slug VARCHAR(100) NOT NULL,
    description NVARCHAR(300) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT df_tags_created_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_tags PRIMARY KEY CLUSTERED (id),
    CONSTRAINT uq_tags_slug UNIQUE (slug)
);

CREATE TABLE dbo.questions (
    id BIGINT IDENTITY(1,1) NOT NULL,
    category_id BIGINT NOT NULL,
    title NVARCHAR(500) NOT NULL,
    answer NVARCHAR(MAX) NOT NULL,
    difficulty VARCHAR(20) NOT NULL CONSTRAINT df_questions_difficulty DEFAULT 'BASIC',
    view_count INT NOT NULL CONSTRAINT df_questions_view_count DEFAULT 0,
    is_active BIT NOT NULL CONSTRAINT df_questions_is_active DEFAULT 1,
    created_at DATETIME2(0) NOT NULL CONSTRAINT df_questions_created_at DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT df_questions_updated_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_questions PRIMARY KEY CLUSTERED (id),
    CONSTRAINT fk_questions_categories FOREIGN KEY (category_id) REFERENCES dbo.categories(id),
    CONSTRAINT ck_questions_difficulty CHECK (difficulty IN ('BASIC', 'INTERMEDIATE', 'ADVANCED')),
    CONSTRAINT ck_questions_view_count CHECK (view_count >= 0)
);

CREATE TABLE dbo.bookmarks (
    id BIGINT IDENTITY(1,1) NOT NULL,
    user_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT df_bookmarks_created_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_bookmarks PRIMARY KEY CLUSTERED (id),
    CONSTRAINT fk_bookmarks_users FOREIGN KEY (user_id) REFERENCES dbo.users(id),
    CONSTRAINT fk_bookmarks_questions FOREIGN KEY (question_id) REFERENCES dbo.questions(id),
    CONSTRAINT uq_bookmarks_user_question UNIQUE (user_id, question_id)
);

CREATE TABLE dbo.question_tags (
    id BIGINT IDENTITY(1,1) NOT NULL,
    question_id BIGINT NOT NULL,
    tag_id BIGINT NOT NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT df_question_tags_created_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_question_tags PRIMARY KEY CLUSTERED (id),
    CONSTRAINT fk_question_tags_questions FOREIGN KEY (question_id) REFERENCES dbo.questions(id),
    CONSTRAINT fk_question_tags_tags FOREIGN KEY (tag_id) REFERENCES dbo.tags(id),
    CONSTRAINT uq_question_tags_question_tag UNIQUE (question_id, tag_id)
);

CREATE TABLE dbo.question_views (
    id BIGINT IDENTITY(1,1) NOT NULL,
    question_id BIGINT NOT NULL,
    user_id BIGINT NULL,
    session_id VARCHAR(80) NULL,
    ip_address VARCHAR(45) NULL,
    user_agent NVARCHAR(300) NULL,
    viewed_at DATETIME2(0) NOT NULL CONSTRAINT df_question_views_viewed_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT pk_question_views PRIMARY KEY CLUSTERED (id),
    CONSTRAINT fk_question_views_questions FOREIGN KEY (question_id) REFERENCES dbo.questions(id),
    CONSTRAINT fk_question_views_users FOREIGN KEY (user_id) REFERENCES dbo.users(id)
);

CREATE TABLE dbo.practice_sessions (
    id BIGINT IDENTITY(1,1) NOT NULL,
    user_id BIGINT NOT NULL,
    title NVARCHAR(200) NOT NULL,
    mode VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL,
    total_questions INT NOT NULL CONSTRAINT df_practice_sessions_total_questions DEFAULT 0,
    correct_count INT NOT NULL CONSTRAINT df_practice_sessions_correct_count DEFAULT 0,
    started_at DATETIME2(0) NOT NULL CONSTRAINT df_practice_sessions_started_at DEFAULT SYSUTCDATETIME(),
    completed_at DATETIME2(0) NULL,
    CONSTRAINT pk_practice_sessions PRIMARY KEY CLUSTERED (id),
    CONSTRAINT fk_practice_sessions_users FOREIGN KEY (user_id) REFERENCES dbo.users(id),
    CONSTRAINT ck_practice_sessions_mode CHECK (mode IN ('FLASHCARD', 'MOCK_INTERVIEW', 'REVIEW')),
    CONSTRAINT ck_practice_sessions_status CHECK (status IN ('IN_PROGRESS', 'COMPLETED', 'ABANDONED')),
    CONSTRAINT ck_practice_sessions_counts CHECK (total_questions >= 0 AND correct_count >= 0 AND correct_count <= total_questions)
);

CREATE TABLE dbo.practice_session_questions (
    id BIGINT IDENTITY(1,1) NOT NULL,
    practice_session_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    display_order INT NOT NULL,
    user_answer NVARCHAR(MAX) NULL,
    score TINYINT NULL,
    note NVARCHAR(500) NULL,
    answered_at DATETIME2(0) NULL,
    CONSTRAINT pk_practice_session_questions PRIMARY KEY CLUSTERED (id),
    CONSTRAINT fk_practice_session_questions_sessions FOREIGN KEY (practice_session_id) REFERENCES dbo.practice_sessions(id),
    CONSTRAINT fk_practice_session_questions_questions FOREIGN KEY (question_id) REFERENCES dbo.questions(id),
    CONSTRAINT uq_practice_session_questions_order UNIQUE (practice_session_id, display_order),
    CONSTRAINT uq_practice_session_questions_question UNIQUE (practice_session_id, question_id),
    CONSTRAINT ck_practice_session_questions_score CHECK (score IS NULL OR score BETWEEN 0 AND 100)
);
GO

CREATE INDEX ix_questions_category_id ON dbo.questions(category_id);
CREATE INDEX ix_questions_difficulty ON dbo.questions(difficulty);
CREATE INDEX ix_questions_active_category ON dbo.questions(is_active, category_id);
CREATE INDEX ix_bookmarks_user_id ON dbo.bookmarks(user_id);
CREATE INDEX ix_bookmarks_question_id ON dbo.bookmarks(question_id);
CREATE INDEX ix_user_roles_user_id ON dbo.user_roles(user_id);
CREATE INDEX ix_user_roles_role_id ON dbo.user_roles(role_id);
CREATE INDEX ix_question_tags_question_id ON dbo.question_tags(question_id);
CREATE INDEX ix_question_tags_tag_id ON dbo.question_tags(tag_id);
CREATE INDEX ix_question_views_question_viewed ON dbo.question_views(question_id, viewed_at DESC);
CREATE INDEX ix_question_views_user_viewed ON dbo.question_views(user_id, viewed_at DESC);
CREATE INDEX ix_practice_sessions_user_started ON dbo.practice_sessions(user_id, started_at DESC);
CREATE INDEX ix_practice_session_questions_session ON dbo.practice_session_questions(practice_session_id, display_order);
GO

;WITH category_seed AS (
    SELECT *
    FROM (VALUES
        (N'Công nghệ thông tin', 'cong-nghe-thong-tin', N'Lập trình phần mềm, DevOps, QA, BA và kiến trúc hệ thống'),
        (N'Marketing', 'marketing', N'Digital marketing, thương hiệu, performance và lập kế hoạch chiến dịch'),
        (N'Kinh doanh / Phát triển kinh doanh', 'kinh-doanh-phat-trien-kinh-doanh', N'Bán hàng, đàm phán, quan hệ đối tác và tăng trưởng khách hàng'),
        (N'Tài chính / Kế toán', 'tai-chinh-ke-toan', N'Kế toán, kiểm toán, báo cáo tài chính và phân tích doanh nghiệp'),
        (N'Nhân sự', 'nhan-su', N'Tuyển dụng, lương thưởng, vận hành nhân sự và phát triển tổ chức'),
        (N'Thiết kế / UI UX', 'thiet-ke-ui-ux', N'Thiết kế sản phẩm, nghiên cứu người dùng và thiết kế giao diện'),
        (N'Nội dung / Viết lách', 'noi-dung-viet-lach', N'Chiến lược nội dung, SEO content, copywriting và biên tập'),
        (N'Truyền thông / PR', 'truyen-thong-pr', N'Quan hệ báo chí, xử lý khủng hoảng và truyền thông thương hiệu'),
        (N'Phân tích dữ liệu', 'phan-tich-du-lieu', N'BI, báo cáo, SQL, dashboard và phân tích kinh doanh'),
        (N'Quản lý sản phẩm', 'quan-ly-san-pham', N'Lộ trình sản phẩm, khám phá nhu cầu và ưu tiên tính năng'),
        (N'Chăm sóc khách hàng', 'cham-soc-khach-hang', N'Onboarding, giữ chân khách hàng, gia hạn và sức khỏe tài khoản'),
        (N'Vận hành', 'van-hanh', N'Cải tiến quy trình, điều phối và đảm bảo chất lượng dịch vụ'),
        (N'Pháp chế', 'phap-che', N'Hợp đồng, tuân thủ, chính sách và vận hành pháp lý'),
        (N'Giáo dục / Đào tạo', 'giao-duc-dao-tao', N'Giảng dạy, thiết kế chương trình học và đào tạo nội bộ'),
        (N'Y tế', 'y-te', N'Chăm sóc bệnh nhân, vận hành cơ sở y tế và quản trị y tế'),
        (N'Kỹ thuật', 'ky-thuat', N'Cơ khí, điện, xây dựng, công nghiệp và giải pháp kỹ thuật'),
        (N'Logistics / Chuỗi cung ứng', 'logistics-chuoi-cung-ung', N'Mua hàng, tồn kho, vận chuyển và lập kế hoạch cung ứng'),
        (N'Bán lẻ', 'ban-le', N'Vận hành cửa hàng, trưng bày, dịch vụ khách hàng và bán hàng'),
        (N'Khách sạn / Nhà hàng', 'khach-san-nha-hang', N'Dịch vụ khách, vận hành nhà hàng, khách sạn và sự kiện'),
        (N'Bất động sản', 'bat-dong-san', N'Môi giới, cho thuê, định giá và tư vấn khách hàng'),
        (N'Ngân hàng', 'ngan-hang', N'Nghiệp vụ ngân hàng, tín dụng, rủi ro và tài chính cá nhân'),
        (N'Bảo hiểm', 'bao-hiem', N'Bồi thường, thẩm định, tư vấn hợp đồng và dịch vụ khách hàng'),
        (N'Quản lý dự án', 'quan-ly-du-an', N'Lập kế hoạch, giao tiếp, quản trị rủi ro và triển khai dự án'),
        (N'Phân tích nghiệp vụ', 'phan-tich-nghiep-vu', N'Thu thập yêu cầu, mô hình quy trình và làm việc với stakeholder'),
        (N'Đảm bảo chất lượng', 'dam-bao-chat-luong', N'Lập kế hoạch kiểm thử, quản lý lỗi và kiểm soát chất lượng'),
        (N'DevOps / Cloud', 'devops-cloud', N'CI/CD, hạ tầng cloud, tự động hóa và độ tin cậy hệ thống'),
        (N'An toàn thông tin', 'an-toan-thong-tin', N'Vận hành bảo mật, quản trị rủi ro và ứng phó sự cố'),
        (N'AI / Machine Learning', 'ai-machine-learning', N'Mô hình học máy, chuẩn bị dữ liệu, đánh giá và triển khai'),
        (N'Phát triển mobile', 'phat-trien-mobile', N'iOS, Android và phát triển ứng dụng đa nền tảng'),
        (N'Frontend Development', 'frontend-development', N'React, UI engineering, accessibility và hiệu năng web'),
        (N'Backend Development', 'backend-development', N'API, service, cơ sở dữ liệu và hệ thống phân tán'),
        (N'Quản trị cơ sở dữ liệu', 'quan-tri-co-so-du-lieu', N'Thiết kế, tối ưu, sao lưu, phục hồi và quản trị dữ liệu'),
        (N'Phát triển game', 'phat-trien-game', N'Gameplay, engine, đồ họa, hiệu năng và quy trình sản xuất game'),
        (N'Sản xuất video', 'san-xuat-video', N'Quay dựng, biên tập, kịch bản hình ảnh và hậu kỳ'),
        (N'Mạng xã hội', 'mang-xa-hoi', N'Quản lý cộng đồng, lịch nội dung, phân tích và tương tác'),
        (N'Thương mại điện tử', 'thuong-mai-dien-tu', N'Vận hành gian hàng, chuyển đổi, catalog và hoàn tất đơn hàng'),
        (N'Kiến trúc', 'kien-truc', N'Thiết kế công trình, vật liệu, bản vẽ và trình bày với khách hàng'),
        (N'Xây dựng', 'xay-dung', N'Điều phối công trường, an toàn, tiến độ và kiểm soát chi phí'),
        (N'Sản xuất', 'san-xuat', N'Lập kế hoạch sản xuất, lean, chất lượng và bảo trì'),
        (N'Năng lượng', 'nang-luong', N'Điện, năng lượng tái tạo, vận hành và tuân thủ kỹ thuật'),
        (N'Môi trường', 'moi-truong', N'Bền vững, kiểm soát môi trường, báo cáo và đánh giá tác động'),
        (N'Khu vực công', 'khu-vuc-cong', N'Chính sách, hành chính, dịch vụ công dân và tuân thủ'),
        (N'Phi lợi nhuận', 'phi-loi-nhuan', N'Chương trình cộng đồng, gây quỹ, tài trợ và tác động xã hội'),
        (N'Nghiên cứu', 'nghien-cuu', N'Thiết kế nghiên cứu, phân tích, thử nghiệm và công bố kết quả'),
        (N'Khoa học / Phòng thí nghiệm', 'khoa-hoc-phong-thi-nghiem', N'Quy trình phòng lab, an toàn, dữ liệu và tài liệu hóa'),
        (N'Hành chính', 'hanh-chinh', N'Điều phối văn phòng, tài liệu, lịch làm việc và hỗ trợ vận hành'),
        (N'Trợ lý điều hành', 'tro-ly-dieu-hanh', N'Hỗ trợ lãnh đạo, lịch họp, giao tiếp và ưu tiên công việc'),
        (N'Mua hàng', 'mua-hang', N'Tìm nguồn cung, đàm phán, đặt hàng và quản lý nhà cung cấp'),
        (N'Quản trị rủi ro', 'quan-tri-rui-ro', N'Đánh giá, giảm thiểu, kiểm soát và theo dõi rủi ro'),
        (N'Tuân thủ', 'tuan-thu', N'Quy định, kiểm toán, chính sách và kiểm soát nội bộ')
    ) AS v(name, slug, description)
)
INSERT INTO dbo.categories (name, slug, description, icon_url)
SELECT name, slug, description, CONCAT(N'/icons/', slug, N'.svg')
FROM category_seed;
GO

;WITH number_seed AS (
    SELECT TOP (50) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.users (username, email, password_hash, role, is_active, created_at)
SELECT
    CONCAT('nguoidung', RIGHT(CONCAT('00', n), 2)),
    CONCAT('nguoidung', RIGHT(CONCAT('00', n), 2), '@interviewhub.test'),
    CONCAT('$2a$10$mat-khau-demo-', RIGHT(CONCAT('00', n), 2), '-khong-dung-production'),
    CASE WHEN n IN (1, 2, 3, 4, 5) THEN 'ADMIN' ELSE 'USER' END,
    CASE WHEN n IN (47, 48, 49, 50) THEN 0 ELSE 1 END,
    DATEADD(DAY, -n, SYSUTCDATETIME())
FROM number_seed;
GO

INSERT INTO dbo.roles (code, name, description)
VALUES
    ('GUEST', N'Khách', N'Người dùng chưa đăng nhập, chỉ có quyền xem nội dung công khai'),
    ('USER', N'Ứng viên', N'Người dùng đã đăng nhập, có thể lưu câu hỏi và luyện tập'),
    ('ADMIN', N'Quản trị viên', N'Người quản trị có quyền quản lý danh mục, câu hỏi và người dùng');
GO

;WITH user_role_seed AS (
    SELECT TOP (50) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.user_roles (user_id, role_id, assigned_at)
SELECT
    n,
    CASE WHEN n IN (1, 2, 3, 4, 5) THEN 3 ELSE 2 END,
    DATEADD(DAY, -n, SYSUTCDATETIME())
FROM user_role_seed;
GO

;WITH tag_seed AS (
    SELECT *
    FROM (VALUES
        (N'JavaScript', 'javascript', N'Câu hỏi về JavaScript và nền tảng web'),
        (N'API Design', 'api-design', N'Thiết kế API, REST, GraphQL và versioning'),
        (N'SEO', 'seo', N'Tối ưu công cụ tìm kiếm và nội dung organic'),
        (N'Recruitment', 'recruitment', N'Tuyển dụng, phỏng vấn và đánh giá ứng viên'),
        (N'React', 'react', N'Xây dựng giao diện với React'),
        (N'Spring Boot', 'spring-boot', N'Phát triển backend Java với Spring Boot'),
        (N'SQL', 'sql', N'Truy vấn và thiết kế cơ sở dữ liệu quan hệ'),
        (N'Database Index', 'database-index', N'Index, tối ưu truy vấn và hiệu năng database'),
        (N'Content Strategy', 'content-strategy', N'Chiến lược nội dung theo mục tiêu kinh doanh'),
        (N'Copywriting', 'copywriting', N'Viết nội dung thuyết phục và chuyển đổi'),
        (N'Brand Marketing', 'brand-marketing', N'Xây dựng thương hiệu và nhận diện dài hạn'),
        (N'Performance Marketing', 'performance-marketing', N'Tối ưu chuyển đổi, CAC, ROAS và paid media'),
        (N'Sales Objection', 'sales-objection', N'Xử lý phản đối và đàm phán bán hàng'),
        (N'Client Management', 'client-management', N'Quản lý quan hệ và kỳ vọng khách hàng'),
        (N'UX Research', 'ux-research', N'Nghiên cứu người dùng và insight'),
        (N'UI Design', 'ui-design', N'Thiết kế giao diện, component và visual hierarchy'),
        (N'Financial Statement', 'financial-statement', N'Báo cáo tài chính và phân tích số liệu'),
        (N'Cash Flow', 'cash-flow', N'Dòng tiền, thanh khoản và vận hành tài chính'),
        (N'HR Operations', 'hr-operations', N'Vận hành nhân sự, chính sách và quy trình'),
        (N'Compensation', 'compensation', N'Lương thưởng, phúc lợi và C&B'),
        (N'Public Relations', 'public-relations', N'Quan hệ công chúng và báo chí'),
        (N'Crisis Communication', 'crisis-communication', N'Xử lý khủng hoảng truyền thông'),
        (N'Data Analysis', 'data-analysis', N'Phân tích dữ liệu và tạo insight'),
        (N'Dashboard', 'dashboard', N'Báo cáo trực quan và dashboard vận hành'),
        (N'Product Discovery', 'product-discovery', N'Khám phá nhu cầu và xác thực vấn đề'),
        (N'Roadmap', 'roadmap', N'Lập lộ trình sản phẩm và ưu tiên'),
        (N'Customer Success', 'customer-success', N'Giữ chân khách hàng và quản lý sức khỏe tài khoản'),
        (N'Onboarding', 'onboarding', N'Đưa người dùng hoặc nhân sự mới vào hệ thống'),
        (N'Project Planning', 'project-planning', N'Lập kế hoạch, milestone và quản trị tiến độ'),
        (N'Risk Management', 'risk-management', N'Nhận diện, đánh giá và giảm thiểu rủi ro'),
        (N'QA Testing', 'qa-testing', N'Kiểm thử phần mềm và quản lý lỗi'),
        (N'Automation', 'automation', N'Tự động hóa quy trình và kiểm thử'),
        (N'DevOps', 'devops', N'CI/CD, hạ tầng và vận hành hệ thống'),
        (N'Cloud', 'cloud', N'Cloud computing, triển khai và scaling'),
        (N'Cybersecurity', 'cybersecurity', N'Bảo mật, kiểm soát và ứng phó sự cố'),
        (N'Machine Learning', 'machine-learning', N'Học máy, mô hình và đánh giá'),
        (N'Mobile App', 'mobile-app', N'Phát triển ứng dụng di động'),
        (N'Accessibility', 'accessibility', N'Tiếp cận, WCAG và trải nghiệm cho mọi người dùng'),
        (N'System Design', 'system-design', N'Thiết kế hệ thống và kiến trúc phần mềm'),
        (N'Microservices', 'microservices', N'Dịch vụ nhỏ, giao tiếp và triển khai độc lập'),
        (N'Negotiation', 'negotiation', N'Đàm phán trong bán hàng và công việc'),
        (N'Leadership', 'leadership', N'Lãnh đạo, ảnh hưởng và phát triển đội nhóm'),
        (N'Communication', 'communication', N'Giao tiếp rõ ràng trong môi trường làm việc'),
        (N'Problem Solving', 'problem-solving', N'Phân tích vấn đề và ra quyết định'),
        (N'Time Management', 'time-management', N'Quản lý thời gian và ưu tiên công việc'),
        (N'Stakeholder Management', 'stakeholder-management', N'Làm việc với các bên liên quan'),
        (N'Compliance', 'compliance', N'Tuân thủ quy định và kiểm soát nội bộ'),
        (N'Procurement', 'procurement', N'Mua hàng, nhà cung cấp và hợp đồng'),
        (N'Supply Chain', 'supply-chain', N'Chuỗi cung ứng và logistics'),
        (N'Business Development', 'business-development', N'Phát triển thị trường và cơ hội kinh doanh')
    ) AS v(name, slug, description)
)
INSERT INTO dbo.tags (name, slug, description)
SELECT name, slug, description
FROM tag_seed;
GO

;WITH question_seed AS (
    SELECT TOP (50) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.questions (category_id, title, answer, difficulty, view_count, is_active, created_at, updated_at)
SELECT
    ((n - 1) % 50) + 1,
    CONCAT(
        N'Câu hỏi phỏng vấn ',
        RIGHT(CONCAT('00', n), 2),
        N': ',
        CASE ((n - 1) % 10)
            WHEN 0 THEN N'Hãy giải thích một khái niệm cốt lõi trong vị trí này.'
            WHEN 1 THEN N'Hãy mô tả một dự án khó mà bạn từng xử lý.'
            WHEN 2 THEN N'Bạn đo lường thành công trong công việc này như thế nào?'
            WHEN 3 THEN N'Bạn xử lý stakeholder khó tính như thế nào?'
            WHEN 4 THEN N'Bạn thường dùng công cụ hoặc quy trình nào nhiều nhất?'
            WHEN 5 THEN N'Bạn ưu tiên công việc khi có nhiều việc gấp như thế nào?'
            WHEN 6 THEN N'Một sai lầm nào đã giúp bạn học được nhiều nhất?'
            WHEN 7 THEN N'Bạn truyền đạt thông tin phức tạp cho người không chuyên như thế nào?'
            WHEN 8 THEN N'Bạn cải thiện chất lượng công việc theo thời gian như thế nào?'
            ELSE N'Bạn sẽ làm gì trong 30 ngày đầu tiên nhận việc?'
        END
    ),
    CONCAT(
        N'Câu trả lời mẫu cho câu hỏi số ',
        n,
        N' nên bắt đầu bằng bối cảnh, sau đó trình bày cách suy nghĩ, các lựa chọn đã cân nhắc, rủi ro hoặc đánh đổi, và kết thúc bằng kết quả đo lường được. Ứng viên nên đưa ví dụ thật, nói rõ vai trò cá nhân và tránh trả lời quá chung chung.'
    ),
    CASE
        WHEN n % 5 = 0 THEN 'ADVANCED'
        WHEN n % 2 = 0 THEN 'INTERMEDIATE'
        ELSE 'BASIC'
    END,
    10 + (n * 7),
    CASE WHEN n IN (49, 50) THEN 0 ELSE 1 END,
    DATEADD(DAY, -n, SYSUTCDATETIME()),
    DATEADD(DAY, -(n / 2), SYSUTCDATETIME())
FROM question_seed;
GO

;WITH question_tag_seed AS (
    SELECT TOP (50) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.question_tags (question_id, tag_id, created_at)
SELECT
    n,
    ((n * 3 - 1) % 50) + 1,
    DATEADD(DAY, -n, SYSUTCDATETIME())
FROM question_tag_seed;
GO

;WITH bookmark_seed AS (
    SELECT TOP (50) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.bookmarks (user_id, question_id, created_at)
SELECT
    ((n - 1) % 50) + 1,
    ((n * 7 - 1) % 50) + 1,
    DATEADD(HOUR, -n, SYSUTCDATETIME())
FROM bookmark_seed;
GO

;WITH question_view_seed AS (
    SELECT TOP (50) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.question_views (question_id, user_id, session_id, ip_address, user_agent, viewed_at)
SELECT
    ((n * 5 - 1) % 50) + 1,
    CASE WHEN n % 6 = 0 THEN NULL ELSE ((n * 2 - 1) % 50) + 1 END,
    CONCAT('session-', RIGHT(CONCAT('0000', n), 4)),
    CONCAT('192.168.1.', (n % 200) + 10),
    N'Mozilla/5.0 demo browser cho Interview Question Hub',
    DATEADD(MINUTE, -n * 13, SYSUTCDATETIME())
FROM question_view_seed;
GO

;WITH practice_session_seed AS (
    SELECT TOP (50) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.practice_sessions (user_id, title, mode, status, total_questions, correct_count, started_at, completed_at)
SELECT
    ((n - 1) % 50) + 1,
    CONCAT(N'Phiên luyện tập số ', RIGHT(CONCAT('00', n), 2)),
    CASE
        WHEN n % 3 = 0 THEN 'MOCK_INTERVIEW'
        WHEN n % 3 = 1 THEN 'FLASHCARD'
        ELSE 'REVIEW'
    END,
    CASE
        WHEN n % 10 = 0 THEN 'ABANDONED'
        WHEN n % 4 = 0 THEN 'IN_PROGRESS'
        ELSE 'COMPLETED'
    END,
    5 + (n % 6),
    CASE
        WHEN n % 4 = 0 THEN 0
        ELSE 1 + (n % 5)
    END,
    DATEADD(DAY, -n, SYSUTCDATETIME()),
    CASE
        WHEN n % 4 = 0 THEN NULL
        ELSE DATEADD(MINUTE, 30 + n, DATEADD(DAY, -n, SYSUTCDATETIME()))
    END
FROM practice_session_seed;
GO

;WITH practice_session_question_seed AS (
    SELECT TOP (50) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.practice_session_questions (practice_session_id, question_id, display_order, user_answer, score, note, answered_at)
SELECT
    n,
    ((n * 9 - 1) % 50) + 1,
    1,
    CONCAT(N'Câu trả lời luyện tập của người dùng cho câu hỏi số ', n, N'.'),
    CASE WHEN n % 4 = 0 THEN NULL ELSE CAST(60 + (n % 35) AS TINYINT) END,
    CASE
        WHEN n % 4 = 0 THEN N'Chưa hoàn thành câu trả lời'
        WHEN n % 3 = 0 THEN N'Cần bổ sung ví dụ thực tế và số liệu'
        ELSE N'Câu trả lời có cấu trúc rõ ràng'
    END,
    CASE WHEN n % 4 = 0 THEN NULL ELSE DATEADD(MINUTE, -n * 7, SYSUTCDATETIME()) END
FROM practice_session_question_seed;
GO

SELECT N'categories' AS table_name, COUNT(*) AS row_count FROM dbo.categories
UNION ALL
SELECT N'users', COUNT(*) FROM dbo.users
UNION ALL
SELECT N'roles', COUNT(*) FROM dbo.roles
UNION ALL
SELECT N'user_roles', COUNT(*) FROM dbo.user_roles
UNION ALL
SELECT N'tags', COUNT(*) FROM dbo.tags
UNION ALL
SELECT N'questions', COUNT(*) FROM dbo.questions
UNION ALL
SELECT N'question_tags', COUNT(*) FROM dbo.question_tags
UNION ALL
SELECT N'bookmarks', COUNT(*) FROM dbo.bookmarks
UNION ALL
SELECT N'question_views', COUNT(*) FROM dbo.question_views
UNION ALL
SELECT N'practice_sessions', COUNT(*) FROM dbo.practice_sessions
UNION ALL
SELECT N'practice_session_questions', COUNT(*) FROM dbo.practice_session_questions;
GO


-- UPDATED ANSWERS CHUẨN HƠN
INSERT INTO dbo.questions (category_id, title, answer, difficulty, view_count, is_active, created_at, updated_at)
VALUES

(1, N'Java là gì và tại sao nó phổ biến?',
 N'Java là ngôn ngữ lập trình hướng đối tượng, chạy trên JVM với nguyên tắc "write once, run anywhere". Java phổ biến vì có hệ sinh thái mạnh (Spring, Hibernate), tính bảo mật cao, quản lý bộ nhớ tốt và được dùng rộng rãi trong hệ thống enterprise.',
 'BASIC', 10, 1, GETDATE(), GETDATE()),

(1, N'Sự khác nhau giữa JDK, JRE và JVM?',
 N'JVM là máy ảo thực thi bytecode. JRE bao gồm JVM và thư viện runtime để chạy ứng dụng. JDK là bộ công cụ phát triển bao gồm JRE và các tool như compiler (javac), debugger. Nói ngắn gọn: JDK để code, JRE để chạy, JVM để thực thi.',
 'BASIC', 15, 1, GETDATE(), GETDATE()),

(1, N'HTTP và HTTPS khác nhau như thế nào?',
 N'HTTP là giao thức truyền dữ liệu không mã hóa, dễ bị nghe lén. HTTPS sử dụng SSL/TLS để mã hóa dữ liệu, đảm bảo tính bảo mật, toàn vẹn và xác thực server. HTTPS là tiêu chuẩn bắt buộc trong các hệ thống hiện đại.',
 'BASIC', 20, 1, GETDATE(), GETDATE()),

(1, N'RESTful API là gì?',
 N'REST là kiến trúc thiết kế API dựa trên resource và HTTP methods như GET, POST, PUT, DELETE. RESTful API có tính stateless, dễ mở rộng, dễ cache và được sử dụng phổ biến trong web services.',
 'BASIC', 12, 1, GETDATE(), GETDATE()),

(1, N'SQL và NoSQL khác nhau như thế nào?',
 N'SQL là cơ sở dữ liệu quan hệ, có schema cố định, phù hợp với dữ liệu có cấu trúc và cần tính toàn vẹn cao. NoSQL linh hoạt hơn, không cần schema cố định, phù hợp với big data và hệ thống phân tán.',
 'INTERMEDIATE', 18, 1, GETDATE(), GETDATE()),

(1, N'Index trong database là gì?',
 N'Index là cấu trúc dữ liệu giúp tăng tốc truy vấn bằng cách giảm số lần scan dữ liệu. Tuy nhiên, index sẽ làm chậm các thao tác insert/update vì phải cập nhật index.',
 'INTERMEDIATE', 25, 1, GETDATE(), GETDATE()),

(1, N'JOIN trong SQL dùng để làm gì?',
 N'JOIN được dùng để kết hợp dữ liệu từ nhiều bảng dựa trên khóa liên kết. Các loại JOIN phổ biến gồm INNER JOIN, LEFT JOIN, RIGHT JOIN và FULL JOIN.',
 'BASIC', 14, 1, GETDATE(), GETDATE()),

(1, N'Bạn hiểu gì về OOP?',
 N'OOP là lập trình hướng đối tượng, dựa trên 4 nguyên lý: encapsulation (đóng gói), inheritance (kế thừa), polymorphism (đa hình), abstraction (trừu tượng). OOP giúp code dễ bảo trì và tái sử dụng.',
 'BASIC', 11, 1, GETDATE(), GETDATE()),

(1, N'Polymorphism là gì?',
 N'Polymorphism là khả năng một đối tượng có nhiều hình dạng, thể hiện qua method overloading và overriding. Nó giúp tăng tính linh hoạt và mở rộng của hệ thống.',
 'INTERMEDIATE', 13, 1, GETDATE(), GETDATE()),

(1, N'Spring Boot là gì?',
 N'Spring Boot là framework Java giúp phát triển ứng dụng nhanh bằng cách tự động cấu hình, tích hợp sẵn server và giảm boilerplate code.',
 'BASIC', 22, 1, GETDATE(), GETDATE()),

(1, N'MVC là gì?',
 N'MVC là mô hình thiết kế gồm Model (dữ liệu), View (giao diện), Controller (xử lý logic), giúp tách biệt trách nhiệm và dễ bảo trì.',
 'BASIC', 9, 1, GETDATE(), GETDATE()),

(1, N'Git là gì?',
 N'Git là hệ thống quản lý version phân tán giúp theo dõi thay đổi code, hỗ trợ làm việc nhóm và quản lý source code hiệu quả.',
 'BASIC', 17, 1, GETDATE(), GETDATE()),

(1, N'CI/CD là gì?',
 N'CI/CD là quy trình tự động hóa build, test và deploy phần mềm. CI giúp tích hợp code liên tục, CD giúp triển khai nhanh và giảm lỗi.',
 'INTERMEDIATE', 19, 1, GETDATE(), GETDATE()),

(1, N'Docker là gì?',
 N'Docker là nền tảng container hóa giúp đóng gói ứng dụng cùng môi trường chạy, đảm bảo chạy giống nhau ở mọi nơi.',
 'INTERMEDIATE', 23, 1, GETDATE(), GETDATE()),

(1, N'Caching là gì?',
 N'Caching là kỹ thuật lưu dữ liệu tạm thời để giảm thời gian truy xuất và giảm tải cho database.',
 'INTERMEDIATE', 21, 1, GETDATE(), GETDATE()),

(1, N'Load balancing là gì?',
 N'Load balancing là kỹ thuật phân phối request đến nhiều server nhằm tăng hiệu năng và độ sẵn sàng.',
 'INTERMEDIATE', 16, 1, GETDATE(), GETDATE()),

(1, N'Authentication và Authorization khác nhau?',
 N'Authentication là xác thực danh tính người dùng, còn Authorization là xác định quyền truy cập tài nguyên.',
 'BASIC', 18, 1, GETDATE(), GETDATE()),

(1, N'Microservices là gì?',
 N'Microservices là kiến trúc chia hệ thống thành các service nhỏ độc lập, dễ deploy và scale.',
 'ADVANCED', 27, 1, GETDATE(), GETDATE()),

(1, N'Concurrency là gì?',
 N'Concurrency là khả năng xử lý nhiều tác vụ cùng lúc, thường sử dụng thread hoặc async programming.',
 'ADVANCED', 24, 1, GETDATE(), GETDATE()),

(1, N'Bạn tối ưu hiệu năng ứng dụng như thế nào?',
 N'Tối ưu bằng cách cải thiện query, sử dụng cache (Redis), load balancing, profiling và tối ưu code logic.',
 'ADVANCED', 30, 1, GETDATE(), GETDATE());