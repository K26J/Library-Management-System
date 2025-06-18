SELECT * FROM BOOKS;
SELECT * FROM BRANCH;
SELECT * FROM EMPLOYEE;
SELECT * FROM ISSUED_STATUS;
SELECT * FROM MEMBERS;
SELECT * FROM RETURN_STATUS;


-- Task 1. Create a New Book Record "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO BOOKS (isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM BOOKS;

--Task 2: Update an Existing Member's Address
UPDATE MEMBERS
SET member_address = '127 Main St'
WHERE member_id = 'C101';
SELECT * FROM MEMBERS
WHERE member_id = 'C101';

UPDATE MEMBERS
SET member_address = '790 Oak St'
WHERE member_id = 'C103';
SELECT member_name,
       member_address
FROM MEMBERS
WHERE member_id = 'C103';

-- Task 3: Delete a Record from the Issued Status Table  Objective: Delete the record with issued_id = 'IS140' from the issued_status table.
DELETE FROM ISSUED_STATUS
WHERE issued_id = 'IS140';
SELECT * FROM ISSUED_STATUS
WHERE issued_id ='IS140';


-- Task 4: Retrieve All Books Issued by a Specific Employee , Objective: Select all books issued by the employee with emp_id = 'E104'.
SELECT issued_book_name
FROM ISSUED_STATUS
WHERE issued_emp_id = 'E104';


-- Task 5: List Members Who Have Issued More Than One Book , Objective: Use GROUP BY to find members who have issued more than one book.
SELECT issued_emp_id,
       COUNT(DISTINCT(issued_book_isbn)) AS book_count
FROM ISSUED_STATUS
GROUP BY issued_emp_id
HAVING COUNT(DISTINCT(issued_book_isbn)) > 1
ORDER BY book_count DESC;


--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results , each book and total book_issued_cnt**
CREATE TABLE BOOKS_SUMMARY AS
SELECT B.isbn, B.book_title, COUNT(I.issued_book_isbn) AS total_book_issued_cnt
FROM BOOKS B
LEFT JOIN ISSUED_STATUS I ON B.isbn = I.issued_book_isbn
GROUP BY B.isbn, B.book_title
ORDER BY total_book_issued_cnt DESC;
SELECT * FROM BOOKS_SUMMARY;


--Task 7: Retrieve All Books in a Specific Category
SELECT book_title,
       category,
	   rental_price,
	   status,
	   author,
	   publisher
FROM BOOKS
WHERE category = 'Classic';


--Task 8: Create table which Find Total Rental Income by Category
CREATE TABLE BOOKS_RENTAL_INCOME
AS
  SELECT B.category,
       SUM(B.rental_price) AS Total_Rental_Income
  FROM BOOKS B
  INNER JOIN ISSUED_STATUS I ON
  B.book_title = I. issued_book_name
  GROUP BY B.category;
SELECT * FROM BOOKS_RENTAL_INCOME;

--Task 9: List Members Who Registered in the Last 180 Days
SELECT * FROM MEMBERS
ORDER BY reg_date DESC;

SELECT member_id, 
       member_name, 
       reg_date
FROM MEMBERS
WHERE reg_date >= '2024-06-01'::DATE - INTERVAL '180 days';


-- Task 10: List Employees with Their Branch Manager's Name and their branch details
SELECT E.emp_id, 
       E.emp_name, 
       E.position, 
       M.emp_name AS manager_name
FROM EMPLOYEE E
LEFT JOIN BRANCH B ON E.branch_id = B.branch_id
LEFT JOIN EMPLOYEE M ON B.manager_id = M.emp_id;
	   


-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold
CREATE TABLE HIGH_RENT_BOOKS
AS
  SELECT * FROM BOOKS
  WHERE rental_price > 6.50;
SELECT * FROM HIGH_RENT_BOOKS;

-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT issued_book_name,
       issued_date,
	   issued_emp_id
FROM ISSUED_STATUS
LEFT JOIN RETURN_STATUS ON ISSUED_STATUS.issued_id = RETURN_STATUS.issued_id
WHERE RETURN_STATUS.return_id IS NULL;


-- Task 13: Show employees along with their respective branch address and contact number.
SELECT E.emp_id,
       E.emp_name,
	   B.branch_address,
	   B.contact_no
FROM EMPLOYEE E
JOIN BRANCH B ON 
E.branch_id = B.branch_id;


--Task 14: Find Members Who Have Issued Books Along With Book Category
SELECT M. member_name,
	   I.issued_book_name,
	   B.category
FROM MEMBERS M
JOIN ISSUED_STATUS I ON
M.member_id = I.issued_member_id
JOIN BOOKS B ON
I.issued_book_isbn = B.isbn;   


--Task 15: Show all books along with the names of authors and employees who issued them.
SELECT I.issued_book_name,
       B.author,
	   E.emp_name
FROM ISSUED_STATUS I
JOIN BOOKS B ON
I.issued_book_isbn = B.isbn
JOIN EMPLOYEE E ON
I.issued_emp_id = E.emp_id;


--Task 16: Retrieve Members Who Have Issued the Most Books
SELECT M.member_name,
       COUNT(I.issued_book_isbn)
FROM MEMBERS M
LEFT JOIN ISSUED_STATUS I ON
M.member_id = I.issued_member_id
GROUP BY M.member_name
ORDER BY COUNT(I.issued_book_isbn) DESC
LIMIT 1;


--Task 17: Find the Book That Has Been Issued the Most
SELECT issued_book_name,
       COUNT(issued_book_name)
FROM ISSUED_STATUS
GROUP BY issued_book_name
ORDER BY COUNT(issued_book_name) DESC
LIMIT 1;


--Task 18: Find the Most Popular Author Based on Issued Books
SELECT author 
FROM BOOKS
WHERE isbn IN
             (SELECT issued_book_isbn
			 FROM ISSUED_STATUS
			 GROUP BY issued_book_isbn
			 ORDER BY COUNT(issued_book_isbn) DESC
			 LIMIT 1);


-- Task 19: Retrieve Books That Have Been Issued But Never Returned
SELECT issued_book_name
FROM ISSUED_STATUS
WHERE issued_id NOT IN (
    SELECT return_id FROM RETURN_STATUS
);


-- Task 20: Find the Branch That Has Issued the Most Books
SELECT branch_id
FROM BRANCH
WHERE branch_id = (
    SELECT branch_id
    FROM EMPLOYEE
    WHERE emp_id IN (
        SELECT issued_emp_id
        FROM ISSUED_STATUS
        GROUP BY issued_emp_id
        ORDER BY COUNT(issued_book_isbn) DESC
        LIMIT 1
    )
);