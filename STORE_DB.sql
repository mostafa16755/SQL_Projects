/*
The DB Schema
EMPLOYEE (FNAME, MINIT, LNAME, SSN, BDATE, ADDRESS, Gender, SALARY, #SUPERSSN, #DNO)
DEPARTMENT (DNAME, DNUMBER, #MGRSSN, MGRSTARTDATE)
PROJECT (PNAME, PNUMBER, PLOCATION, #DNUM)
WORKS_ON (#ESSN, #PNO, HOURS)
*/

CREATE DATABASE STORE_DB;

USE STORE_DB;

CREATE TABLE CATEGORY (
  cat_id INT PRIMARY KEY,
  cname VARCHAR(50) NOT NULL
);

CREATE TABLE PRODUCT (
  product_id INT PRIMARY KEY,
  pname VARCHAR(255) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  description TEXT,
  size VARCHAR(50),
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES CATEGORY(cat_id)
);

CREATE TABLE CUSTOMERS (
  ssn INT PRIMARY KEY,
  city VARCHAR(50) NOT NULL,
  c_name VARCHAR(50) NOT NULL
);

CREATE TABLE ORDERS (
  order_number INT PRIMARY KEY,
  o_date DATE NOT NULL,
  cost DECIMAL(10, 2) NOT NULL,
  customer_id INT,
  FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(ssn)
);

CREATE TABLE ORDER_CONTENTS (
  order_number INT,
  product_id INT,
  qty INT,
  PRIMARY KEY (order_number, product_id),
  FOREIGN KEY (order_number) REFERENCES ORDERS(order_number),
  FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id)
);

INSERT INTO CATEGORY (cat_id, cname) VALUES
  (1, 'Electronics'),
  (2, 'Clothing'),
  (3, 'Home Goods');

SELECT * FROM CATEGORY;

INSERT INTO PRODUCT (product_id, pname, price, description, size, category_id) VALUES
  (1, 'iPhone 12', 799.99, 'The latest iPhone from Apple', '6.1 inches', 1),
  (2, 'Samsung Galaxy S21', 699.99, 'The latest Samsung flagship phone', '6.2 inches', 1),
  (3, 'Levi''s 501 Jeans', 59.99, 'Classic jeans from Levi''s', '32x30', 2),
  (4, 'Nike Air Force 1', 99.99, 'Iconic sneakers from Nike', 'US 10', 2),
  (5, 'KitchenAid Stand Mixer', 399.99, 'Powerful and versatile stand mixer', '5 qt', 3),
  (6, 'Dyson V11 Vacuum', 599.99, 'Powerful cordless vacuum cleaner', '2000', 3);

SELECT * FROM PRODUCT;

INSERT INTO CUSTOMERS (ssn, city, c_name) VALUES
  (123456789, 'New York', 'John Smith'),
  (234567890, 'Los Angeles', 'Jane Doe');
  
  SELECT * FROM CUSTOMERS;

INSERT INTO ORDERS (order_number, o_date, cost, customer_id) VALUES
  (1001, '2023-05-01', 999.99, 123456789),
  (1002, '2023-05-05', 159.98, 234567890);
  
  SELECT * FROM ORDERS;

INSERT INTO ORDER_CONTENTS (order_number, product_id, qty) VALUES
  (1001, 1, 1),
  (1002, 3, 2),
  (1002, 4, 1);
  
  SELECT * FROM ORDER_CONTENTS;
  
  --  most expensive product of each category
  SELECT c.Cname, p.Pname, p.Price
FROM CATEGORY c
JOIN PRODUCT p ON c.Cat_id = p.Category_id
WHERE p.Price = (
    SELECT MAX(Price)
    FROM PRODUCT
    WHERE Category_id = p.Category_id
)
ORDER BY c.Cname;

-- products with the highest quantity for each order
select o.order_number, p.Pname, MAX(oc.qty) AS max_qty
FROM ORDERS o
JOIN ORDER_CONTENTS oc ON o.order_number = oc.order_number
JOIN PRODUCT p ON oc.product_id = p.product_id
GROUP BY o.order_number, p.Pname;

-- data of customers and their orders who are from Assiut
-- and the orders cost higher than all the cost of orders of Cairo’s customers
SELECT c.SSN, c.C_name, o.order_number, o.O_date, o.Cost
FROM CUSTOMERS c
JOIN ORDERS o ON c.SSN = o.Customer_id
WHERE c.City = 'Assiut' AND o.Cost > (
    SELECT MAX(o2.Cost)
    FROM ORDERS o2
    JOIN CUSTOMERS c2 ON o2.Customer_id = c2.SSN
    WHERE c2.City = 'Cairo'
)
ORDER BY c.SSN, o.order_number;

-- all products ordered in March of the year 2020
SELECT p.product_id, p.Pname, o.order_number, o.O_date, oc.qty
FROM PRODUCT p
JOIN ORDER_CONTENTS oc ON p.product_id = oc.product_id
JOIN ORDERS o ON oc.order_number = o.order_number
WHERE o.O_date >= '2020-03-01' AND o.O_date < '2020-04-01'
ORDER BY p.product_id, o.order_number;