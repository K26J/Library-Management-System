# 📚 Library Management System - SQL Database Setup & Queries  

## 📌 Overview  
This repository contains **SQL scripts** for managing a **Library Management System**, covering:  
- **Database schema creation**  
- **Record management** (insert, update, delete)  
- **Advanced queries** for business insights  

---

## 🎯 Objectives  
The SQL scripts aim to:  
✅ Efficiently **store and manage** library data  
✅ Implement **business rules** through constraints  
✅ **Extract insights** from data using SQL queries  

---

## 📂 Database Schema  

The system contains the following **relational tables**:  
- **BOOKS** 📖 _(Stores book details)_  
- **BRANCH** 🏢 _(Manages branch records)_  
- **EMPLOYEE** 👨‍💼 _(Tracks employee details)_  
- **ISSUED_STATUS** 📋 _(Records book issuance)_  
- **MEMBERS** 🙍 _(Stores member information)_  
- **RETURN_STATUS** 🔁 _(Manages book returns)_  

---

## 📊 Entity Relationship Diagram (ERD)

Below is the ERD representation of the Library Management System:

![Library Management ERD](./path-to-your-image.png)


## 🔍 SQL Queries  

### **Task 1: Create a New Book Record**  
📌 **Problem Statement:** Add a new book to the `BOOKS` table.  

```sql
INSERT INTO BOOKS (isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

SELECT * FROM BOOKS;
```


### **Task 2: Update an Existing Member's Address**  
📌 **Problem Statement:** Update a member's address based on their `member_id`.  

```sql
UPDATE MEMBERS
SET member_address = '127 Main St'
WHERE member_id = 'C101';

SELECT * FROM MEMBERS WHERE member_id = 'C101';
```


### **Task 3: Delete a Record from Issued Status**  
📌 **Problem Statement:** Remove the issued book record where `issued_id = 'IS140'`.  

```sql
DELETE FROM ISSUED_STATUS
WHERE issued_id = 'IS140';

SELECT * FROM ISSUED_STATUS WHERE issued_id = 'IS140';
```


### **Task 4: Retrieve All Books Issued by a Specific Employee**  
📌 **Problem Statement:** Select books issued by employee `E104`.  

```sql
SELECT issued_book_name
FROM ISSUED_STATUS
WHERE issued_emp_id = 'E104';
```

### **Task 5: List Members Who Have Issued More Than One Book**  
📌 **Problem Statement:** Identify members who borrowed multiple books.  

```sql
SELECT issued_member_id, COUNT(DISTINCT issued_book_isbn) AS book_count
FROM ISSUED_STATUS
GROUP BY issued_member_id
HAVING COUNT(DISTINCT issued_book_isbn) > 1
ORDER BY book_count DESC;
```

### **Task 6: Create Summary Tables for Issued Books**  
📌 **Problem Statement:** Generate a summary table of books issued.  

```sql
CREATE TABLE BOOKS_SUMMARY AS
SELECT B.isbn, B.book_title, COUNT(I.issued_book_isbn) AS total_book_issued_cnt
FROM BOOKS B
LEFT JOIN ISSUED_STATUS I ON B.isbn = I.issued_book_isbn
GROUP BY B.isbn, B.book_title
ORDER BY total_book_issued_cnt DESC;

SELECT * FROM BOOKS_SUMMARY;
```

### **Task 7: Retrieve All Books in a Specific Category**  
📌 **Problem Statement:** List all books under the 'Classic' category.  

```sql
SELECT book_title, category, rental_price, status, author, publisher
FROM BOOKS
WHERE category = 'Classic';
```

### **Task 8: Find Total Rental Income by Category**  
📌 **Problem Statement:** Calculate total rental income grouped by book category.  

```sql
CREATE TABLE BOOKS_RENTAL_INCOME AS
SELECT B.category, SUM(B.rental_price) AS Total_Rental_Income
FROM BOOKS B
INNER JOIN ISSUED_STATUS I ON B.book_title = I.issued_book_name
GROUP BY B.category;

SELECT * FROM BOOKS_RENTAL_INCOME;
```

### **Task 9: List Members Who Registered in the Last 180 Days**  

```sql
SELECT member_id, member_name, reg_date
FROM MEMBERS
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

### **Task 10: Retrieve Employees and Their Branch Manager's Name**  

```sql
SELECT E.emp_id, E.emp_name, E.position, M.emp_name AS manager_name
FROM EMPLOYEE E
LEFT JOIN BRANCH B ON E.branch_id = B.branch_id
LEFT JOIN EMPLOYEE M ON B.manager_id = M.emp_id;
```

### **Task 11: Create Table for Books with High Rental Price**  

```sql
CREATE TABLE HIGH_RENT_BOOKS AS
SELECT * FROM BOOKS WHERE rental_price > 6.50;

SELECT * FROM HIGH_RENT_BOOKS;
```

### **Task 12: Retrieve Books Not Yet Returned**  

```sql
SELECT issued_book_name, issued_date, issued_emp_id
FROM ISSUED_STATUS
LEFT JOIN RETURN_STATUS ON ISSUED_STATUS.issued_id = RETURN_STATUS.issued_id
WHERE RETURN_STATUS.return_id IS NULL;
```

### **Task 13: Show Employees Along With Their Branch Details**  

```sql
SELECT E.emp_id, E.emp_name, B.branch_address, B.contact_no
FROM EMPLOYEE E JOIN BRANCH B ON E.branch_id = B.branch_id;
```

### **Task 14: Find Members Who Issued Books Along With Categories**  

```sql
SELECT M.member_name, I.issued_book_name, B.category
FROM MEMBERS M
JOIN ISSUED_STATUS I ON M.member_id = I.issued_member_id
JOIN BOOKS B ON I.issued_book_isbn = B.isbn;
```

### **Task 15: Show Books Issued Along With Authors & Employees**  

```sql
SELECT I.issued_book_name, B.author, E.emp_name
FROM ISSUED_STATUS I
JOIN BOOKS B ON I.issued_book_isbn = B.isbn
JOIN EMPLOYEE E ON I.issued_emp_id = E.emp_id;
```

### **Task 16:Find Members Who Issued the Most Books**  

```sql
SELECT member_name, COUNT(issued_book_isbn) AS book_count
FROM MEMBERS M LEFT JOIN ISSUED_STATUS I ON M.member_id = I.issued_member_id
GROUP BY member_name ORDER BY book_count DESC LIMIT 1;
```

### **Task 17:Find the Most Issued Book**  

```sql
SELECT issued_book_name, COUNT(issued_book_name) AS issue_count
FROM ISSUED_STATUS GROUP BY issued_book_name ORDER BY issue_count DESC LIMIT 1;
```

### **Task 18: Find Most Popular Author**

```sql
SELECT author FROM BOOKS WHERE isbn IN (
SELECT issued_book_isbn FROM ISSUED_STATUS GROUP BY issued_book_isbn ORDER BY COUNT(issued_book_isbn) DESC LIMIT 1);
```

### **Task 19: Books Issued But Never Returned**
```sql
SELECT issued_book_name FROM ISSUED_STATUS WHERE issued_id NOT IN (
SELECT return_id FROM RETURN_STATUS);
```

### **Task 20:  Branch That Issued Most Books**

```sql
SELECT branch_id FROM BRANCH WHERE branch_id = (
SELECT branch_id FROM EMPLOYEE WHERE emp_id IN (
SELECT issued_emp_id FROM ISSUED_STATUS GROUP BY issued_emp_id ORDER BY COUNT(issued_book_isbn) DESC LIMIT 1));
```

---

## ✅ Conclusion  
This project **enhances library operations** through **efficient data storage, management, and reporting**. By executing these structured queries, we optimize **book rentals, employee tracking, and financial insights**.  


