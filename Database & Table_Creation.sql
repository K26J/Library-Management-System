-- CREATE DATABASE

-- CREATE TABLE BOOKS
DROP TABLE IF EXISTS BOOKS;
CREATE TABLE BOOKS (
                    isbn VARCHAR(30) PRIMARY KEY,
					book_title VARCHAR(70), 
					category VARCHAR(25),
					rental_price DECIMAL,
					status VARCHAR(15),
					author VARCHAR(50),
					publisher VARCHAR(50)

                    );

-- CREATE TABLE BRANCH
DROP TABLE IF EXISTS BRANCH;
CREATE TABLE BRANCH (
                     branch_id VARCHAR(10) PRIMARY KEY,
					 manager_id VARCHAR(10),
					 branch_address VARCHAR(30),
					 contact_no VARCHAR(20)

                     );

--CREATE TABLE EMPLOYEE
DROP TABLE IF EXISTS EMPLOYEE;
CREATE TABLE EMPLOYEE(
                      emp_id VARCHAR(10) PRIMARY KEY,
					  emp_name VARCHAR(25),
					  position VARCHAR (25),
					  salary INT,
					  branch_id VARCHAR(10)

                      );

-- CREATE TABLE ISSUED STATUS
DROP TABLE IF EXISTS ISSUED_STATUS;
CREATE TABLE ISSUED_STATUS (
                            issued_id VARCHAR(15) PRIMARY KEY,
                            issued_member_id VARCHAR(15),
                            issued_book_name VARCHAR(75),
                            issued_date DATE,
                            issued_book_isbn VARCHAR(30),
                            issued_emp_id VARCHAR(10)
    
                            );

--CREATE TABLE MEMBERS
DROP TABLE IF EXISTS MEMBERS;
CREATE TABLE MEMBERS(
                     member_id VARCHAR(10) PRIMARY KEY,
					 member_name VARCHAR (40),
					 member_address VARCHAR (100),
					 reg_date DATE

                     );

--CREATE TABLE RETURN_STATUS
DROP TABLE IF EXISTS RETURN_STATUS;
CREATE TABLE RETURN_STATUS(
                           return_id VARCHAR(15) PRIMARY KEY,
						   issued_id VARCHAR(15),
						   return_book_name	VARCHAR(70),
						   return_date DATE,
						   return_book_isbn VARCHAR(15)

                           );

--Adding CONSTRINT
ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_issued_member
FOREIGN KEY (issued_member_id)
REFERENCES MEMBERS(member_id); 

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_book_isbn
FOREIGN KEY (issued_book_isbn)
REFERENCES BOOKS(isbn);

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_emp_id
FOREIGN KEY (issued_emp_id)
REFERENCES EMPLOYEE(emp_id);

ALTER TABLE EMPLOYEE
ADD CONSTRAINT fk_branch_id
FOREIGN KEY (branch_id)
REFERENCES BRANCH(branch_id);


ALTER TABLE RETURN_STATUS
ADD CONSTRAINT fk_issued_id
FOREIGN KEY (issued_id)
REFERENCES ISSUED_STATUS(issued_id);

SELECT * FROM BOOKS;
SELECT * FROM BRANCH;
SELECT * FROM EMPLOYEE;
SELECT * FROM ISSUED_STATUS;
SELECT * FROM MEMBERS;
SELECT * FROM RETURN_STATUS;



