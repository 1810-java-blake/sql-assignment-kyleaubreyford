-- Part I – Working with an existing database

-- 1.0	Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.


-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.
	SELECT * FROM employee;
-- Task – Select all records from the Employee table where last name is King.
	SELECT * FROM employee WHERE lastname = 'King'
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
	SELECT * FROM employee WHERE firstname = 'Andrew' AND reportsto IS NULL;

-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
	SELECT * FROM album ORDER BY title DESC;
-- Task – Select first name from Customer and sort result set in ascending order by city
	SELECT firstname FROM customer ORDER BY city;
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
INSERT INTO Genre (GenreId, Name) VALUES (26, N'Pokemon');
INSERT INTO Genre (GenreId, Name) VALUES (27, N'Anime');
-- Task – Insert two new records into Employee table
INSERT INTO Employee (EmployeeId, LastName, FirstName, Title, ReportsTo, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email) VALUES (8, N'Ford', N'Bob', N'IT Staff', 6, '1948/1/9', '2006/3/4', N'92 7 ST NW', N'Metbridge', N'AB', N'CanadaTheLandOftheGreat', N'T1H 1Y8', N'+1 (401) 467-4251', N'+1 (444) 467-8772', N'rop@runescape.com');
INSERT INTO Employee (EmployeeId, LastName, FirstName, Title, ReportsTo, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email) VALUES (8, N'Celahan', N'Jim', N'IT Staff', 6, '1928/1/9', '2005/3/4', N'23 7 ST NW', N'Lumbridge', N'AB', N'America', N'T1H 1Y8', N'+1 (402) 467-3451', N'+1 (423) 462-8772', N'laura@gmail.com');
-- Task – Insert two new records into Customer table
INSERT INTO Customer (CustomerId, FirstName, LastName, Address, City, Country, PostalCode, Phone, Email, SupportRepId) VALUES (2, N'Josh', N'Ko', N'Potato Street', N'Texas', N'USA', N'74174', N'+49 2222 2842222', N'bob@surfeu.de', 5);
INSERT INTO Customer (CustomerId, FirstName, LastName, Address, City, Country, PostalCode, Phone, Email, SupportRepId) VALUES (2, N'Josh2', N'Ko2', N'Theodor 4', N'Stuttgart', N'Mexico', N'70374', N'+49 0711 2342222', N'kohler@surfeu.de', 5);
-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE customer SET (firstname,lastname) = ('Robert','Walter') WHERE firstname = 'Aaron' AND lastname = 'Mitchell';
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE artist SET name = ('CCR') WHERE name = 'Creedence Clearwater Revival';
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SELECT * FROM invoice WHERE billingaddress LIKE 'T%';
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SELECT * FROM invoice WHERE total BETWEEN 15 AND 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
select * from employee  WHERE hiredate BETWEEN '2003-06-03' AND '2004-03-01';
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
DELETE FROM invoiceline
WHERE invoiceid = 50 OR invoiceid = 62 OR invoiceid = 116 OR invoiceid = 245
OR invoiceid = 268 OR invoiceid = 290 OR invoiceid = 342;
DELETE FROM invoice
WHERE customerid = 32;
DELETE FROM customer
WHERE firstname = 'Robert' AND lastname='Walter';


 
alter table invoice
DROP CONSTRAINT FK_InvoiceCustomerId;

alter table invoice
add constraint FK_InvoiceCustomerId
FOREIGN KEY (CustomerId) 
REFERENCES Customer (CustomerId) 
ON DELETE cascade;

ALTER TABLE InvoiceLine 
DROP CONSTRAINT FK_InvoiceLineInvoiceId;

ALTER TABLE InvoiceLine 
ADD CONSTRAINT FK_InvoiceLineInvoiceId
FOREIGN KEY (InvoiceId) 
REFERENCES Invoice (InvoiceId) 
ON DELETE cascade;

commit;
--You can also define foreign key constraints with ON DELETE CASCADE


-- 3.0	SQL Functions
-- In this section you will be using the POSTGRESQL system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
CREATE OR REPLACE FUNCTION timeReturn()
 RETURNS DATE AS $$
 BEGIN
 	RETURN NOW();
 END;
 $$ LANGUAGE plpgsql;
-- Task – create a function that returns the length of a mediatype from the mediatype table
CREATE OR REPLACE FUNCTION lengthMediaType(number INT)
  RETURNS int AS $$
 
  BEGIN
  	RETURN LENGTH(name) FROM mediatype WHERE mediatypeid = number;
  END;
  $$ LANGUAGE plpgsql;
  
 
-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION avgInvoices()
 RETURNS INT AS $$
 BEGIN
 	RETURN AVG(total) FROM invoice;
 END;
 $$ LANGUAGE plpgsql;
-- Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION maxUnitPrice()
 RETURNS INT AS $$
 BEGIN
 	RETURN MAX(unitprice) FROM track;
 END;
 $$ LANGUAGE plpgsql;
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION avgPrice()
 RETURNS INT AS $$
 BEGIN
 	RETURN AVG(unitprice) FROM invoiceline;
 END;
 $$ LANGUAGE plpgsql;
 
-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.

CREATE OR REPLACE FUNCTION employeesAfter1968()
 RETURNS TABLE(fname Varchar,
			   lname Varchar) AS $$
 BEGIN
 	RETURN  QUERY SELECT employee.firstname AS fname,employee.lastname AS lname FROM employee WHERE birthdate >= '1969-01-01'::date;
 END;
 $$ LANGUAGE plpgsql;
 
 SELECT employeesAfter1968();


-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
CREATE OR REPLACE FUNCTION employeeNames()
 RETURNS TABLE(fname Varchar,
			   lname Varchar) AS $$
 BEGIN
 	RETURN  QUERY SELECT employee.firstname AS fname,employee.lastname AS lname FROM employee WHERE birthdate >= '1969-01-01'::date;
 END;
 $$ LANGUAGE plpgsql;
 
 SELECT employeeNames();
-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
 CREATE OR REPLACE FUNCTION updateEmployee(
 	empID int,
     address text,
     city text,
     state text,
     country text,
     postalCode text,
     phone text) RETURNS void AS $$
 	BEGIN
  	UPDATE employee SET employee.address = address, employee.city = city, employee.state = state,
 	employee.country = country, employee.postalCode = postalCode, employee.phone = phone WHERE employeeid = 'empID';
  END;
  $$ LANGUAGE plpgsql;
 
 
-- Task – Create a stored procedure that returns the managers of an employee.
 CREATE OR REPLACE FUNCTION getManager(empID INT)
  RETURNS INT AS $$
  BEGIN
  	RETURN reportsto FROM employee WHERE employeeid = empID;
  END;
  $$ LANGUAGE plpgsql;
 
  SELECT getManager(2);

-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
 CREATE OR REPLACE FUNCTION getNameAndCompany(cusID INT)
  RETURNS TABLE( cname varchar,
				 lname varchar,
				 business varchar
  					) AS $$
  BEGIN
  	RETURN QUERY SELECT firstname AS cname, lastname AS lname, company AS business FROM customer WHERE customerid = cusID;
  END;
  $$ LANGUAGE plpgsql;
 
  SELECT getNameAndCompany(1);

-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
	CREATE OR REPLACE FUNCTION removeinvoice(iid INT)
		RETURNS void as $$
	BEGIN
		DELETE FROM invoice WHERE invoiceID = 2;
	END;
	$$ LANGUAGE plpgsql;
 

-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
	CREATE OR REPLACE FUNCTION addCustomer(
	customerI INT,
    firstNam VARCHAR(40),
    lastNam VARCHAR(20) ,
    compan VARCHAR(80),
    addres VARCHAR(70),
    cit VARCHAR(40),
    stat VARCHAR(40),
    countr VARCHAR(40),
    postalCod VARCHAR(10),
    phon VARCHAR(24),
    fa VARCHAR(24),
    emai VARCHAR(60),
    supportRepI INT)
    RETURNS void as $$				 
	BEGIN
		INSERT INTO Customer (CustomerId, FirstName, LastName, Company, Address, City, State, Country, PostalCode, Phone, Fax, Email, SupportRepId) VALUES (customerI, firstNam, lastNam, compan, addres, cit, stat, countr, postalCod, phon, fa, emai, supportRepI);
	END;
	$$ LANGUAGE plpgsql;
 
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
CREATE TRIGGER employeeTrigger;
 AFTER INSERT ON employee
 FOR EACH ROW
 EXECUTE PROCEDURE whateverFunction();
-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table.
 CREATE TRIGGER albumTrigger;
 AFTER UPDATE ON album
 FOR EACH ROW
 EXECUTE PROCEDURE whateverFunction();
-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
 CREATE TRIGGER customerTrigger;
 AFTER DELETE ON customer
 FOR EACH ROW
 EXECUTE PROCEDURE whateverFunction();
-- 6.2 Before
-- Task – Create a before trigger that restricts the deletion of any invoice that is priced over 50 dollars.
 CREATE OR REPLACE FUNCTION restrictDeleteTrigFunction()
 RETURNS TRIGGER AS $$
 BEGIN
 	IF (OLD.total > 50) THEN
            RAISE EXCEPTION 'invoice too expensive';
    END IF;
 	RETURN NEW;
    END;
 $$ LANGUAGE plpgsql;

 CREATE TRIGGER restrictDeleteTrig
 BEFORE DELETE ON invoice
 FOR EACH ROW
 EXECUTE PROCEDURE restrictDeleteTrigFunction();
-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.








