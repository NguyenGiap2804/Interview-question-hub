# Interview Question Hub Backend

Demo backend Spring Boot cho phase MVP. Ban hien tai dung du lieu mau trong bo nho, chua ket noi database.

## Chay bang IntelliJ IDEA

1. Mo thu muc `backend`.
2. De IntelliJ import Maven project tu `pom.xml`.
3. Vao `File > Project Structure > Project`, chon Project SDK la JDK 17 hoac JDK 21.
4. Dam bao SQL Server dang co database `InterviewQuestionHub`.
5. Chay class `com.project3.InterviewQuestionHubApplication`.
6. API se chay o `http://localhost:8080`.

## Cau hinh SQL Server

Mac dinh backend ket noi toi:

```text
jdbc:sqlserver://localhost;instanceName=MSSQLSERVER01;databaseName=InterviewQuestionHub;encrypt=true;trustServerCertificate=true;integratedSecurity=true
```

Neu may ban dung SQL Server Authentication, dat bien moi truong truoc khi chay:

```powershell
$env:DB_URL="jdbc:sqlserver://localhost;instanceName=MSSQLSERVER01;databaseName=InterviewQuestionHub;encrypt=true;trustServerCertificate=true"
$env:SPRING_DATASOURCE_USERNAME="ten_dang_nhap"
$env:SPRING_DATASOURCE_PASSWORD="mat_khau"
```

## Endpoint test nhanh

- `GET http://localhost:8080/api/health`
- `GET http://localhost:8080/api/categories`
- `GET http://localhost:8080/api/categories/4/questions`
- `GET http://localhost:8080/api/questions`
- `GET http://localhost:8080/api/questions?difficulty=BASIC`
- `GET http://localhost:8080/api/questions?categoryId=4&difficulty=INTERMEDIATE`
- `GET http://localhost:8080/api/questions/search?keyword=api`
- `GET http://localhost:8080/api/questions/1`

## Ghi chu

- `DemoDataStore` dang dong vai tro repository tam thoi.
- Khi ket noi database, co the thay `DemoDataStore` bang Spring Data JPA repository va giu controller/service gan nhu nguyen ven.
- Chua them Auth, Admin CRUD, Bookmark vi cac phan nay phu hop phase tiep theo sau khi API public da chay on dinh.
