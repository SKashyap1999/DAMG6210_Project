/* Create Table */
CREATE DATABASE marketplace;
use marketplace;




/* Create Tables */ /*Added Zip code */
CREATE TABLE STUDENT
(
Student_ID        INTEGER      NOT NULL,
First_Name        VARCHAR(100) CHECK (First_Name NOT LIKE '%[^a-zA-Z ]%') NOT NULL,
Last_Name        VARCHAR(100) CHECK (Last_Name NOT LIKE '%[^a-zA-Z ]%') NOT NULL,
Email            VARCHAR(100) CHECK( Email LIKE '%@%') ,
Phone            VARCHAR(20)  CHECK(ISNUMERIC(Phone) = 1 AND LEN(Phone) >= 10),
Date_of_Birth    DATE           NOT NULL,
Address          VARCHAR(200)      NOT NULL,
Zip_Code         INTEGER       CHECK(LEN(Zip_Code) = 5) ,

CONSTRAINT Student_PK PRIMARY KEY (Student_ID),
);


CREATE TABLE ACCOUNT
(
Account_ID     INTEGER    NOT NULL,
Username       VARCHAR(100) NOT NULL,
Student_ID     INTEGER    NOT NULL,
Last_Login     DATETIME        ,
Account_Status VARCHAR(100) NOT NULL,
Account_Type   VARCHAR(2)   NOT NULL,
Date_Of_Creation DATE        ,
CONSTRAINT Account_PK PRIMARY KEY (Account_ID),
CONSTRAINT Account_FK FOREIGN KEY (Student_ID) REFERENCES STUDENT(Student_ID)
);


CREATE TABLE [ADMIN] 
(
Account_ID  INTEGER   NOT NULL,
Admin_ID INTEGER    NOT NULL,
Permissions VARCHAR(100) ,
Date_Registered DATE ,
CONSTRAINT Admin_PK PRIMARY KEY (Admin_ID),
CONSTRAINT Admin_FK FOREIGN KEY (Account_ID) REFERENCES ACCOUNT(Account_ID)
);


CREATE TABLE [USER]
  (
   Account_ID INTEGER       NOT NULL,
   User_ID     INTEGER      NOT NULL,
   Payment_Info VARCHAR(100)      NOT NULL,
   Shipping_Address VARCHAR(200),
   CONSTRAINT User_PK PRIMARY KEY (User_ID),
   CONSTRAINT User_FK FOREIGN KEY (Account_ID) REFERENCES ACCOUNT(Account_ID)
   );

CREATE TABLE CATEGORY
( Category_ID            INTEGER          NOT NULL,
  Category_Name          VARCHAR(100)     NOT NULL,
  Parent_Category_ID     VARCHAR(100)             ,
  Created_Date           DATE                     ,
  CONSTRAINT Category_PK PRIMARY KEY (Category_ID)
  );


CREATE TABLE ITEM

( Item_ID               VARCHAR(100)               NOT NULL,
  Seller_User_ID        INTEGER               NOT NULL,
  Item_Name             VARCHAR(100)     CHECK (Item_Name NOT LIKE '%[^a-zA-Z ]%') NOT NULL,
  Item_Desc             VARCHAR(100) ,
  Item_Category         INTEGER           NOT NULL,   
  Item_Price            INTEGER                 NOT NULL,
  Item_Cond             VARCHAR(100)     CHECK(Item_Cond IN
                                          ('New','Refurbished','Like-New','Good','Acceptable','Damaged')),
  Mfg_Date              DATE                             ,
  
  CONSTRAINT Item_PK PRIMARY KEY (Item_ID),
  CONSTRAINT Item_FK FOREIGN KEY (Seller_User_ID) REFERENCES [USER](User_ID),
  CONSTRAINT Item_FK2 FOREIGN KEY (Item_Category) REFERENCES CATEGORY(Category_ID)
);

-- 26th November added

ALTER TABLE ITEM ADD Selling_Price INTEGER;
SELECT * from ITEM;

UPDATE ITEM
SET Selling_Price = 
  CASE
    WHEN Item_Cond = 'New' THEN Item_Price * 0.8 
    WHEN Item_Cond = 'Like-New' THEN Item_Price * 0.7  
    WHEN Item_Cond = 'Refurbished' THEN Item_Price * 0.5  
    ELSE Item_Price  
  END
  * 
  CASE
    WHEN Item_Category = 1 THEN 0.6  
    WHEN Item_Category = 4 THEN 0.4 
    ELSE 1  
  END;

---------------------------------------------------------------

CREATE TABLE SUPERVISOR
(Supervisor_ID           INTEGER               NOT NULL,
Supervisor_Name          VARCHAR(100),
Date_of_Employment         DATE,
CONSTRAINT Supervisor_PK PRIMARY KEY (Supervisor_ID));

CREATE TABLE LISTING
(
Listing_ID               VARCHAR(100)   NOT NULL,
Listing_Seller_ID        INTEGER   NOT NULL,
Date_Posted              DATE     , 
Location                 VARCHAR(200) NOT NULL,
IsLive                   VARCHAR(10) CHECK(IsLive IN ('TRUE','FALSE')) NOT NULL,
Title                    VARCHAR(100) ,

CONSTRAINT Listing_PK PRIMARY KEY(Listing_ID),
CONSTRAINT Listing_FK FOREIGN KEY (Listing_ID) REFERENCES ITEM(Item_ID)
);



CREATE TABLE [TRANSACTION]
( Transaction_ID        INTEGER               NOT NULL,
  Transaction_Date      DATE                   NOT NULL,
  Listing_ID            VARCHAR(100)                NOT NULL,
  Transaction_Mode      VARCHAR(100)     CHECK (Transaction_Mode IN('DEBIT','CREDIT')) NOT NULL,
  User_ID               INTEGER               NOT NULL,
  Supervisor_ID         INTEGER               NOT NULL,
  CONSTRAINT Transaction_PK PRIMARY KEY (Transaction_ID),
  CONSTRAINT Transaction_FK1 FOREIGN KEY (User_ID) REFERENCES [USER](User_ID),
  CONSTRAINT Transaction_FK2 FOREIGN KEY (Listing_ID) REFERENCES LISTING(Listing_ID),
  CONSTRAINT Transaction_FK3 FOREIGN KEY (Supervisor_ID) REFERENCES SUPERVISOR(Supervisor_ID)
 );

/*CREATE TABLE SAVED_ITEM
(
Saved_Item_ID  INTEGER      NOT NULL,
Student_ID     INTEGER      NOT NULL,
Item_ID        VARCHAR(100)      NOT NULL,
Is_Favourite    VARCHAR(1)          ,
Saved_Date      DATE        NOT NULL,

CONSTRAINT Saved_Item_PK PRIMARY KEY (Saved_Item_ID),
CONSTRAINT Saved_Item_FK1 FOREIGN KEY (Student_ID) REFERENCES STUDENT(Student_ID),
CONSTRAINT Saved_Item_FK2 FOREIGN KEY (Item_ID) REFERENCES ITEM(Item_ID)
);*/

CREATE TABLE SAVED_ITEM
(
    Saved_Item_ID  INTEGER IDENTITY(1,1) NOT NULL,
    Student_ID     INTEGER      NOT NULL,
    Item_ID        VARCHAR(100)      NOT NULL,
    Is_Favourite    VARCHAR(1),
    Saved_Date      DATE        NOT NULL,

    CONSTRAINT Saved_Item_PK PRIMARY KEY (Saved_Item_ID),
    CONSTRAINT Saved_Item_FK1 FOREIGN KEY (Student_ID) REFERENCES STUDENT(Student_ID),
    CONSTRAINT Saved_Item_FK2 FOREIGN KEY (Item_ID) REFERENCES ITEM(Item_ID)
);

/*CREATE TABLE [MESSAGE]
(
Message_ID         INTEGER    NOT NULL,
Sender_Student_ID  INTEGER    NOT NULL,
Receiver_Student_ID INTEGER   NOT NULL,
Listing_ID          VARCHAR(100)  NOT NULL,
Content            VARCHAR(300) NOT NULL,
Date_Received       DATETIME    NOT NULL,
CONSTRAINT Message_PK PRIMARY KEY (Message_ID),
CONSTRAINT Message_FK1 FOREIGN KEY (Sender_Student_ID) REFERENCES STUDENT(Student_ID),
CONSTRAINT Message_FK2 FOREIGN KEY (Receiver_Student_ID) REFERENCES STUDENT(Student_ID),
CONSTRAINT Message_FK3 FOREIGN KEY (Listing_ID) REFERENCES LISTING(Listing_ID)
);
*/

CREATE TABLE [MESSAGE]
(
    Message_ID         INTEGER IDENTITY(1,1) NOT NULL,
    Sender_Student_ID  INTEGER    NOT NULL,
    Receiver_Student_ID INTEGER   NOT NULL,
    Listing_ID          VARCHAR(100)  NOT NULL,
    Content            VARCHAR(300) NOT NULL,
    Date_Received       DATETIME    NOT NULL,

    CONSTRAINT Message_PK PRIMARY KEY (Message_ID),
    CONSTRAINT Message_FK1 FOREIGN KEY (Sender_Student_ID) REFERENCES STUDENT(Student_ID),
    CONSTRAINT Message_FK2 FOREIGN KEY (Receiver_Student_ID) REFERENCES STUDENT(Student_ID),
    CONSTRAINT Message_FK3 FOREIGN KEY (Listing_ID) REFERENCES LISTING(Listing_ID)
);

CREATE TABLE REVIEW
(
Review_ID    INTEGER    NOT NULL,
Listing_ID   VARCHAR(100)    NOT NULL,
Student_ID   INTEGER    NOT NULL,
Rating       INTEGER    CHECK(Rating BETWEEN 1 AND 10) NOT NULL,
Comment      VARCHAR(300) ,
Helpful_Count INTEGER  ,
Reported_Count INTEGER,
CONSTRAINT  Review_PK PRIMARY KEY (Review_ID),
CONSTRAINT  Review_FK FOREIGN KEY (Listing_ID) REFERENCES LISTING (Listing_ID),
CONSTRAINT  Review_FK2 FOREIGN KEY (Student_ID) REFERENCES STUDENT (Student_ID)
);

CREATE TABLE REPORT
(
Report_ID  INTEGER  NOT NULL,
Reporter_Student_ID  INTEGER  NOT NULL,
Admin_ID     INTEGER   ,
Report_Description  VARCHAR(300),
Report_Type   VARCHAR(1) NOT NULL,
Report_Date   DATE NOT NULL,
Report_Status VARCHAR(200),
CONSTRAINT Report_PK PRIMARY KEY (Report_ID),
CONSTRAINT Report_FK1 FOREIGN KEY (Reporter_Student_ID) REFERENCES STUDENT(Student_ID),
CONSTRAINT Report_FK2 FOREIGN KEY (Admin_ID) REFERENCES [ADMIN](Admin_ID)
);

CREATE TABLE REVIEW_REPORT
(
Review_Report_ID INTEGER NOT NULL,
Report_ID INTEGER  NOT NULL,
CONSTRAINT Review_Report_PK PRIMARY KEY (Review_Report_ID),
CONSTRAINT Review_Report_FK FOREIGN KEY (Report_ID) REFERENCES REPORT(Report_ID)
);
select * from REVIEW_REPORT; -- reported review id 
select * from REPORT WHERE  Report_Type = 'R';
select * from REVIEW;

-----26th November Changes 

-- Add Review_ID column to REVIEW_REPORT table
ALTER TABLE REVIEW_REPORT
ADD Reported_Review_ID INTEGER ;

-- Add foreign key constraint
ALTER TABLE REVIEW_REPORT
ADD CONSTRAINT Review_Report_FK1 FOREIGN KEY (Reported_Review_ID) REFERENCES REVIEW(Review_ID);

--------------------------------------------------------------------------------------
CREATE TABLE MESSAGE_REPORT
(
Message_Report_ID INTEGER NOT NULL,
Report_ID INTEGER  NOT NULL,
Message_ID        INTEGER NOT NULL,
CONSTRAINT Message_Report_PK PRIMARY KEY (Message_Report_ID),
CONSTRAINT Message_Report_FK FOREIGN KEY (Report_ID) REFERENCES REPORT(Report_ID),
CONSTRAINT Message_Report_FK2 FOREIGN KEY (Message_ID) REFERENCES [MESSAGE](Message_ID)
);

CREATE TABLE LISTING_REPORT
(
Listing_Report_ID INTEGER NOT NULL,
Report_ID INTEGER  NOT NULL,
Reported_Listing_ID VARCHAR(100)   NOT NULL,
CONSTRAINT Listing_Report_PK PRIMARY KEY (Listing_Report_ID),
CONSTRAINT Listing_Report_FK1 FOREIGN KEY (Report_ID) REFERENCES REPORT(Report_ID),
CONSTRAINT Listing_Report_FK2 FOREIGN KEY (Reported_Listing_ID) REFERENCES LISTING(Listing_ID)
);

CREATE TABLE MEETUP
(
Meeting_ID   INTEGER   NOT NULL,
Buyer_ID    INTEGER   NOT NULL,
Seller_ID    INTEGER   NOT NULL,
Description  VARCHAR(300) ,
Date_Time    DATETIME  NOT NULL,
Location     VARCHAR(200) NOT NULL,
Type         VARCHAR(20) ,
CONSTRAINT Meetup_Table_PK PRIMARY KEY (Meeting_ID),
CONSTRAINT Meetup_Table_FK1 FOREIGN KEY (Buyer_ID) REFERENCES [USER](User_ID),
CONSTRAINT Meetup_Table_FK2 FOREIGN KEY (Seller_ID) REFERENCES [USER](User_ID)
);

/*----------------------------------------------Insert rows into table----------------------------*/

-- Insert data into the STUDENT table
INSERT INTO STUDENT (Student_ID, First_Name, Last_Name, Email, Phone, Date_of_Birth, Address, Zip_Code)
VALUES
  (1, 'John', 'Doe', 'john.doe@example.com', 1234567890, '1995-05-15', '123 Main St', 12345),
  (2, 'Jane', 'Smith', 'jane.smith@example.com', '9876543210', '1998-08-22', '456 Oak St', 54321),
  (3, 'Bob', 'Johnson', 'bob.johnson@example.com', 5551234567, '1990-03-10', '789 Maple Ave', 67890),
  (4, 'Emily', 'Davis', 'emily.davis@example.com', 4445556666, '1997-12-05', '101 Pine St', 45678),
  (5, 'Alex', 'Martin', 'alex.martin@example.com', 7778889999, '1992-06-18', '202 Oak Ave', 23456),
  (6, 'Grace', 'Wilson', 'grace.wilson@example.com', 3332221111, '1994-09-30', '303 Elm St', 78901),
  (7, 'Michael', 'Clark', 'michael.clark@example.com', 5554443333, '1988-11-20', '404 Birch Ave', 12389),
  (8, 'Olivia', 'Jones', 'olivia.jones@example.com', 9998887777, '1996-02-14', '505 Cedar St', 56743),
  (9, 'Henry', 'Anderson', 'henry.anderson@example.com', 1112223333, '1993-07-25', '606 Maple Ave', 90876),
  (10, 'Sophia', 'Moore', 'sophia.moore@example.com', 6667778888, '1991-04-08', '707 Pine St', 23457),
  (11, 'Liam', 'Taylor', 'liam.taylor@example.com', 1231231234, '1995-09-17', '808 Elm St', 67890),
  (12, 'Ava', 'Miller', 'ava.miller@example.com', 4567890123, '1998-01-03', '909 Birch Ave', 12345),
  (13, 'Noah', 'Brown', 'noah.brown@example.com', 7890123456, '1990-06-26', '110 Cedar St', 54321),
  (14, 'Emma', 'Wilson', 'emma.wilson@example.com', 2345678901, '1997-03-14', '211 Pine St', 67890),
  (15, 'Ethan', 'Thomas', 'ethan.thomas@example.com', 5678901234, '1992-08-09', '322 Oak Ave', 45678),
  (16, 'Isabella', 'Jones', 'isabella.jones@example.com', 8901234567, '1994-11-22', '433 Maple Ave', 23456),
  (17, 'Mason', 'Clark', 'mason.clark@example.com', 1234567890, '1989-04-01', '544 Elm St', 78901),
  (18, 'Sophia', 'Evans', 'sophia.evans@example.com', 3456789012, '1996-07-13', '655 Birch Ave', 12389),
  (19, 'Jackson', 'Smith', 'jackson.smith@example.com', 6789012345, '1993-02-18', '766 Cedar St', 56743),
  (20, 'Olivia', 'Thomas', 'olivia.thomas@example.com', 9012345678, '1991-05-07', '877 Pine St', 23457);

select * from STUDENT;

INSERT INTO ACCOUNT (Account_ID, Username, Student_ID, Last_Login, Account_Status, Account_Type, Date_Of_Creation)
VALUES
  (1001, 'user1', 1, '2023-01-01 08:00:00', 'Active', 'S', '2022-01-01'),
  (1002, 'user2', 2, '2023-02-01 10:30:00', 'Active', 'S', '2022-02-01'),
  (1003, 'user3', 3, '2023-03-01 12:45:00', 'Inactive', 'SA', '2022-03-01'),
  (1004, 'user4', 4, '2023-04-01 15:20:00', 'Active', 'S', '2022-04-01'),
  (1005, 'user5', 5, '2023-05-01 17:10:00', 'Active', 'S', '2022-05-01'),
  (1006, 'user6', 6, '2023-06-01 19:30:00', 'Inactive', 'SA', '2022-06-01'),
  (1007, 'user7', 7, '2023-07-01 21:15:00', 'Active', 'S', '2022-07-01'),
  (1008, 'user8', 8, '2023-08-01 23:40:00', 'Active', 'S', '2022-08-01'),
  (1009, 'user9', 9, '2023-09-01 01:55:00', 'Inactive', 'A', '2022-09-01'),
  (1010, 'user10', 10, '2023-10-01 03:25:00', 'Active', 'S', '2022-10-01'),
  (1011, 'user11', 11, '2023-11-01 05:45:00', 'Active', 'S', '2022-11-01'),
  (1012, 'user12', 12, '2023-12-01 07:10:00', 'Inactive', 'A', '2022-12-01'),
  (1013, 'user13', 13, NULL, 'Active', 'S', '2023-01-01'),
  (1014, 'user14', 14, NULL, 'Active', 'S', '2023-02-01'),
  (1015, 'user15', 15, NULL, 'Inactive', 'A', '2023-03-01'),
  (1016, 'user16', 16, NULL, 'Active', 'S', '2023-04-01'),
  (1017, 'user17', 17, NULL, 'Active', 'S', '2023-05-01'),
  (1018, 'user18', 18, NULL, 'Inactive', 'SA', '2023-06-01'),
  (1019, 'user19', 19, NULL, 'Active', 'S', '2023-07-01'),
  (1020, 'user20', 20, NULL, 'Active', 'S', '2023-08-01');

  select * from ACCOUNT;

  INSERT INTO [ADMIN] (Account_ID, Admin_ID, Permissions, Date_Registered) VALUES
  (1003, 501, 'Limited Access', '2022-03-01'),
  (1006, 502, 'Limited Access', '2022-06-01'),
  (1009, 503, 'Limited Access', '2022-09-01'),
  (1010, 504, 'Full Access', '2022-10-01'),
  (1011, 505, 'Read-Only', '2022-11-01'),
  (1012, 506, 'Limited Access', '2022-12-01'),
  (1015, 507, 'Limited Access', '2023-03-01'),
  (1018, 508, 'Limited Access', '2023-06-01');

  select * from ADMIN;

-- Insert data into the [USER] table
INSERT INTO [USER] (Account_ID, User_ID, Payment_Info, Shipping_Address)
VALUES
  (1001, 101, 'Credit Card: 1234-5678-9012-3456', '123 Main St'),
  (1002, 102, 'PayPal: user2@example.com', '456 Oak St'),
  (1003, 103, 'Debit Card: 9876-5432-1098-7654', '789 Maple Ave'),
  (1004, 104, 'Credit Card: 1111-2222-3333-4444', '101 Pine St'),
  (1005, 105, 'PayPal: user5@example.com', '202 Maple Ave'),
  (1006, 106, 'Debit Card: 5555-6666-7777-8888', '303 Elm St'),
  (1007, 107, 'Credit Card: 9999-8888-7777-6666','404 Birch Ave'),
  (1008, 108, 'PayPal: user8@example.com', '505 Cedar St'),
  (1010, 109, 'Debit Card: 4444-3333-2222-1111', '606 Maple Ave'),
  (1011, 110, 'Credit Card: 7777-6666-5555-4444', '707 Pine St'),
  (1013, 111, 'PayPal: user11@example.com','808 Elm St'),
  (1014, 112, 'Debit Card: 3333-2222-1111-0000', '909 Birch Ave'),
  (1016, 113, 'Credit Card: 1212-3434-5656-7878', '110 Cedar St'),
  (1017, 114, 'PayPal: user14@example.com', '211 Pine St'),
  (1018, 115, 'Debit Card: 9898-7654-3210-1234', '322 Oak Ave'),
  (1019, 116, 'Credit Card: 5432-1098-7654-3210', '433 Maple Ave'),
  (1020, 117, 'PayPal: user17@example.com', '544 Elm St');

select * FROM [USER];

-- Insert data into the CATEGORY table
INSERT INTO CATEGORY (Category_ID, Category_Name, Parent_Category_ID, Created_Date)
VALUES
  (1, 'Electronics', NULL, '2022-01-01'),
  (2, 'Clothing', NULL, '2022-02-01'),
  (3, 'Smartphones', 1, '2022-03-01'),
  (4, 'Laptops', 1, '2022-04-01'),
  (5, 'Men''s Apparel', 2, '2022-05-01'),
  (6, 'Women''s Apparel', 2, '2022-06-01'),
  (7, 'Accessories', NULL, '2022-07-01'),
  (8, 'Headphones', 7, '2022-08-01'),
  (9, 'Bags', 7, '2022-09-01'),
  (10, 'Mobile Accessories', 3, '2022-10-01'),
  (11, 'Desktops', 1, '2022-11-01'),
  (12, 'Footwear', 2, '2022-12-01'),
  (13, 'Shirts', 5, '2023-01-01'),
  (14, 'Dresses', 6, '2023-02-01'),
  (15, 'Watches', 7, '2023-03-01'),
  (16, 'Speakers', 7, '2023-04-01'),
  (17, 'Tablets', 1, '2023-05-01'),
  (18, 'Backpacks', 9, '2023-06-01'),
  (19, 'Jeans', 5, '2023-07-01'),
  (20, 'Sneakers', 12, '2023-08-01'),
  (21, 'Cameras', 1, '2023-09-01'),
  (22, 'T-Shirts', 5, '2023-10-01'),
  (23, 'Hats', 7, '2023-11-01'),
  (24, 'Gaming Laptops', 4, '2023-12-01'),
  (25, 'Jackets', 6, '2024-01-01'),
  (26, 'Fitness Trackers', 7, '2024-02-01'),
  (27, 'Keyboards', 11, '2024-03-01'),
  (28, 'Running Shoes', 12, '2024-04-01'),
  (29, 'Outdoor Gear', NULL, '2024-05-01'),
  (30, 'Wired Headphones', 8, '2024-06-01'),
  (31, 'Wireless Headphones', 8, '2024-07-01'),
  (32, 'Denim Jackets', 18, '2024-08-01'),
  (33, 'Shorts', 5, '2024-09-01'),
  (34, 'Home Appliances', 1, '2024-10-01'),
  (35, 'Smartwatches', 15, '2024-11-01'),
  (36, 'Duffel Bags', 9, '2024-12-01'),
  (37, 'Gaming Consoles', 17, '2025-01-01'),
  (38, 'Formal Shoes', 12, '2025-02-01'),
  (39, 'Wallets', 9, '2025-03-01'),
  (40, 'Graphic T-Shirts', 22, '2025-04-01'),
  (41, 'Printers', 11, '2025-05-01'),
  (42, 'Swimwear', 6, '2025-06-01'),
  (43, 'Bluetooth Speakers', 16, '2025-07-01'),
  (44, 'Camping Gear', 29, '2025-08-01'),
  (45, 'Office Chairs', 34, '2025-09-01'),
  (46, 'Smart Home Devices', 34, '2025-10-01'),
  (47, 'Travel Backpacks', 18, '2025-11-01'),
  (48, 'Power Banks', 10, '2025-12-01'),
  (49, 'Smart Glasses', 7, '2026-01-01'),
  (50, 'Portable Chargers', 10, '2026-02-01');


  -- Insert data into the ITEM table
INSERT INTO ITEM (Item_ID, Seller_User_ID, Item_Name, Item_Desc, Item_Category, Item_Price, Item_Cond, Mfg_Date)
VALUES
  ('A01', 101, 'Smartphone X', 'High-end smartphone with advanced features', 3, 800, 'New', '2022-01-15'),
  ('B02', 102, 'Designer Jeans', 'Premium denim jeans with a stylish design', 19, 45, 'Like-New', '2022-02-20'),
  ('C03', 103, 'Gaming Laptop Pro', 'Powerful gaming laptop for immersive gaming experience', 4, 1500, 'Refurbished', '2022-03-10'),
  ('D04', 104, 'Wireless Headphones', 'High-quality wireless headphones for crystal-clear audio', 8, 80, 'Good', '2022-04-05'),
  ('E05', 105, 'Men Running Shoes', 'Comfortable and stylish running shoes for men', 20, 55, 'Acceptable', '2022-05-12'),
  ('F06', 106, 'Designer Dress', 'Elegant dress designed for special occasions', 14, 70, 'New', '2022-06-18'),
  ('G07', 107, 'Smartwatch Elite', 'Advanced smartwatch with fitness tracking and notifications', 15, 90, 'Like-New', '2022-07-22'),
  ('H08', 108, 'Office Backpack', 'Durable backpack for professionals with multiple compartments', 9, 40, 'Refurbished', '2022-08-30'),
  ('I09', 109, 'Vintage Camera', 'Classic camera with a vintage appeal for photography enthusiasts', 21, 700, 'Good', '2022-09-07'),
  ('J10', 110, 'Graphic T Shirt Collection', 'Set of stylish graphic t-shirts for a trendy look', 22, 30, 'Acceptable', '2022-10-15'),
  ('K11', 111, 'Desktop Workstation', 'Powerful desktop computer for multitasking and productivity', 1, 1000, 'New', '2022-11-25'),
  ('L12', 112, 'Leather Formal Shoes', 'Premium leather shoes for a sophisticated and formal look', 12, 60, 'Like-New', '2022-12-01'),
  ('M13', 113, 'Outdoor Adventure Gear', 'Essential gear for outdoor enthusiasts and adventurers', 29, 2000, 'New', '2022-11-25'),
  ('N14', 114, 'Bluetooth Speaker Set', 'High-fidelity Bluetooth speakers for immersive audio experience', 7, 120, 'New', '2023-02-18'),
  ('O15', 115, 'Printed Swimwear', 'Fashionable swimwear with vibrant prints for the beach', 42, 70, 'Refurbished', '2023-03-25'),
  ('P16', 116, 'Camping Equipment Bundle', 'Complete set of camping gear for outdoor adventures', 44, 200, 'Good', '2023-04-03'),
  ('Q17', 117, 'Home Office Chair', 'Ergonomic chair for a comfortable and productive home office setup', 45, 120, 'Acceptable', '2023-05-12'),
  ('A18', 101, 'Smart Home Starter Kit', 'Intelligent devices for a connected and smart home', 46, 300, 'New', '2023-06-20'),
  ('B19', 102, 'Travel Backpack', 'Spacious and durable backpack for travelers', 47, 50, 'Like-New', '2023-07-28'),
  ('C20', 102, 'Power Bank Essentials', 'Portable chargers for keeping devices charged on the go', 48, 25, 'Refurbished', '2023-08-05'),
  ('D21', 106, 'Fashionable Glasses', 'Stylish smart glasses with advanced features', 49, 150, 'Good', '2023-09-15'),
  ('E22', 106, 'Portable Chargers Set', 'Convenient set of portable chargers for various devices', 50, 40, 'Acceptable', '2023-10-23'),
  ('F23', 109, 'Wireless Gaming Consoles', 'Gaming consoles with wireless controllers for a seamless experience', 37, 350, 'New', '2023-11-30'),
  ('G24', 110, 'Formal Wallet Collection', 'Classy collection of formal wallets for men', 39, 30, 'Like-New', '2023-12-10'),
  ('H25', 111, 'Smartphone Accessories Kit', 'Essential accessories for enhancing the functionality of your smartphone', 10, 15, 'Refurbished', '2024-01-18');

select * from ITEM;

INSERT INTO SUPERVISOR (Supervisor_ID, Supervisor_Name, Date_of_Employment)
VALUES
  (1, 'John Smith', '2022-01-15'),
  (2, 'Alice Johnson', '2022-02-20'),
  (3, 'Michael Brown', '2022-03-10'),
  (4, 'Emily Davis', '2022-04-05'),
  (5, 'Daniel Wilson', '2022-05-12'),
  (6, 'Olivia Moore', '2022-06-18'),
  (7, 'William Turner', '2022-07-22'),
  (8, 'Sophia Taylor', '2022-08-30'),
  (9, 'Matthew Anderson', '2022-09-07'),
  (10, 'Ava Martinez', '2022-10-15');

  select * from SUPERVISOR;

INSERT INTO LISTING (Listing_ID, Listing_Seller_ID, Date_Posted, Location, IsLive, Title)
VALUES
  ('A01', 101, '2022-01-20', 'Boston', 'TRUE', 'Smartphone X Listing'),
  ('B02', 102, '2022-02-25', 'Cambridge', 'TRUE', 'Designer Jeans Listing'),
  ('C03', 103, '2022-03-15', 'Lowell', 'TRUE', 'Gaming Laptop Pro Listing'),
  ('D04', 104, '2022-04-10', 'Lowell', 'TRUE', 'Wireless Headphones Listing'),
  ('E05', 105, '2022-05-17', 'Lowell', 'TRUE', 'Men Running Shoes Listing'),
  ('F06', 106, '2022-06-23', 'Quincy', 'TRUE', 'Designer Dress Listing'),
  ('G07', 107, '2022-07-27', 'Lowell', 'TRUE', 'Smartwatch Elite Listing'),
  ('H08', 108, '2022-08-05', 'Lowell', 'TRUE', 'Office Backpack Listing'),
  ('I09', 109, '2022-09-12', 'Boston', 'TRUE', 'Vintage Camera Listing'),
  ('J10', 110, '2022-10-20', 'Lowell', 'TRUE', 'Graphic T Shirt Collection Listing'),
  ('K11', 111, '2022-11-30', 'Lowell', 'TRUE', 'Desktop Workstation Listing'),
  ('L12', 112, '2022-12-07', 'Lowell', 'TRUE', 'Leather Formal Shoes Listing'),
  ('M13', 113, '2023-01-10', 'Cambridge', 'TRUE', 'Outdoor Adventure Gear Listing'),
  ('N14', 114, '2023-02-25', 'Cambridge', 'TRUE', 'Bluetooth Speaker Set Listing'),
  ('O15', 115, '2023-03-30', 'Cambridge', 'TRUE', 'Printed Swimwear Listing'),
  ('P16', 116, '2023-04-07', 'Lowell', 'TRUE', 'Camping Equipment Bundle Listing'),
  ('Q17', 117, '2023-05-17', 'Lowell', 'TRUE', 'Home Office Chair Listing'),
  ('A18', 101, '2023-06-25', 'Quincy', 'TRUE', 'Smart Home Starter Kit Listing'),
  ('B19', 102, '2023-07-30', 'Lowell', 'TRUE', 'Travel Backpack Listing'),
  ('C20', 102, '2023-08-07', 'Boston', 'TRUE', 'Power Bank Essentials Listing'),
  ('D21', 106, '2023-09-20', 'Lowell', 'TRUE', 'Fashionable Glasses Listing'),
  ('E22', 106, '2023-10-28', 'Boston', 'TRUE', 'Portable Chargers Set Listing'),
  ('F23', 109, '2023-11-30', 'Lowell', 'TRUE', 'Wireless Gaming Consoles Listing'),
  ('G24', 110, '2023-12-15', 'Lowell', 'TRUE', 'Formal Wallet Collection Listing'),
  ('H25', 111, '2024-01-25', 'Lowell', 'TRUE', 'Smartphone Accessories Kit Listing');


select * FROM LISTING;

INSERT INTO [TRANSACTION] (Transaction_ID, Transaction_Date, Listing_ID, Transaction_Mode, User_ID, Supervisor_ID)
VALUES
  (1, '2022-01-25', 'A01', 'CREDIT', 101, 1),
  (2, '2022-02-28', 'B02', 'DEBIT', 102, 2),
  (3, '2022-03-18', 'C03', 'CREDIT', 103, 3),
  (4, '2022-04-15', 'D04', 'DEBIT', 104, 4),
  (5, '2022-05-22', 'E05', 'CREDIT', 105, 5),
  (6, '2022-06-28', 'F06', 'DEBIT', 106, 6),
  (7, '2022-07-30', 'G07', 'CREDIT', 107, 7),
  (8, '2022-08-10', 'H08', 'DEBIT', 108, 8),
  (9, '2022-09-17', 'I09', 'CREDIT', 109, 9),
  (10, '2022-10-25', 'J10', 'DEBIT', 110, 10),
  (11, '2022-11-30', 'K11', 'CREDIT', 111, 1),
  (12, '2022-12-07', 'L12', 'DEBIT', 112, 2),
  (13, '2023-01-15', 'M13', 'CREDIT', 113, 3),
  (14, '2023-02-28', 'N14', 'DEBIT', 114, 4),
  (15, '2023-03-30', 'O15', 'CREDIT', 115, 5),
  (16, '2023-04-10', 'P16', 'DEBIT', 116, 6),
  (17, '2023-05-22', 'Q17', 'CREDIT', 117, 7),
  (18, '2023-06-30', 'A18', 'DEBIT', 101, 8),
  (19, '2023-07-30', 'B19', 'CREDIT', 102, 9),
  (20, '2023-08-10', 'C20', 'DEBIT', 102, 10),
  (21, '2023-09-22', 'D21', 'CREDIT', 106, 1),
  (22, '2023-10-30', 'E22', 'DEBIT', 106, 2),
  (23, '2023-11-30', 'F23', 'CREDIT', 109, 3),
  (24, '2023-12-15', 'G24', 'DEBIT', 110, 4),
  (25, '2024-01-30', 'H25', 'CREDIT', 111, 5);

select * from [TRANSACTION];

INSERT INTO SAVED_ITEM (Student_ID, Item_ID, Is_Favourite, Saved_Date)
VALUES
  (1, 'A01', 'Y', '2022-01-20'),
  (2, 'B02', 'N', '2022-02-25'),
  (3, 'C03', 'Y', '2022-03-15'),
  (4, 'D04', 'N', '2022-04-10'),
  (5, 'E05', 'Y', '2022-05-17'),
  (6, 'F06', 'N', '2022-06-23'),
  (7, 'G07', 'Y', '2022-07-27'),
  (8, 'H08', 'N', '2022-08-05'),
  (9, 'I09', 'Y', '2022-09-12'),
  (10, 'J10', 'N', '2022-10-20'),
  (11, 'K11', 'Y', '2022-11-30'),
  (12, 'L12', 'N', '2022-12-07'),
  (13, 'M13', 'Y', '2023-01-10'),
  (14, 'N14', 'N', '2023-02-25'),
  (15, 'O15', 'Y', '2023-03-30'),
  (16, 'P16', 'N', '2023-04-07'),
  (17, 'Q17', 'Y', '2023-05-17'),
  (1, 'A18', 'N', '2023-06-25'),
  (2, 'B19', 'Y', '2023-07-30'),
  (2, 'C20', 'N', '2023-08-07'),
  (6, 'D21', 'Y', '2023-09-20'),
  (6, 'E22', 'N', '2023-10-28'),
  (9, 'F23', 'Y', '2023-11-30'),
  (10, 'G24', 'N', '2023-12-15'),
  (11, 'H25', 'Y', '2024-01-25');

  select * from SAVED_ITEM ;

-- Sample data for the MESSAGE table
-- Sample data for the MESSAGE table
INSERT INTO MESSAGE (Sender_Student_ID, Receiver_Student_ID, Listing_ID, Content, Date_Received)
VALUES
  (1, 2, 'A01', 'Hi Jane, I''m interested in buying your Smartphone X.', '2022-01-21 08:30:00'),
  (2, 1, 'B02', 'Hello John, thanks for your interest! The Designer Jeans are still available.', '2022-02-26 10:45:00'),
  (3, 4, 'C03', 'Hi Emily, I saw your Gaming Laptop Pro listing. Can you provide more details?', '2022-03-16 15:20:00'),
  (4, 3, 'D04', 'Hello Bob, I''m interested in the Wireless Headphones. Are they still available?', '2022-04-11 12:10:00'),
  (5, 6, 'E05', 'Hi Grace, I love the Men Running Shoes you listed. When can I pick them up?', '2022-05-18 09:05:00'),
  (6, 5, 'F06', 'Hello Alex, the Designer Dress is gorgeous! Is it available for immediate purchase?', '2022-06-24 14:30:00'),
  (7, 8, 'G07', 'Hi Olivia, I''m interested in the Smartwatch Elite. Does it come with all accessories?', '2022-07-28 11:15:00'),
  (8, 7, 'H08', 'Hello Michael, I''m looking for a durable Office Backpack. Is yours still for sale?', '2022-08-06 13:45:00'),
  (9, 10, 'I09', 'Hi Sophia, the Vintage Camera looks amazing! Can you share more photos?', '2022-09-13 16:50:00'),
  (10, 9, 'J10', 'Hello Henry, I''m interested in your Graphic T Shirt Collection. Are they new?', '2022-10-21 17:30:00'),
  (11, 12, 'K11', 'Hi Ava, the Desktop Workstation would be perfect for my work. Is it still available?', '2022-12-01 09:00:00'),
  (12, 11, 'L12', 'Hello Liam, I love the Leather Formal Shoes! Can you provide sizing information?', '2022-12-08 10:20:00'),
  (13, 14, 'M13', 'Hi Emma, the Outdoor Adventure Gear is exactly what I need. Can we arrange a meetup?', '2023-01-11 14:15:00'),
  (14, 13, 'N14', 'Hello Noah, I''m interested in the Bluetooth Speaker Set. Does it have good sound quality?', '2023-02-26 16:40:00'),
  (15, 16, 'O15', 'Hi Ethan, the Printed Swimwear looks fantastic! Is it still available?', '2023-03-31 12:55:00'),
  (16, 15, 'P16', 'Hello Isabella, the Camping Equipment Bundle is exactly what I need. Can we negotiate the price?', '2023-04-08 11:10:00'),
  (17, 18, 'Q17', 'Hi Sophia, the Home Office Chair looks comfortable. Is it still for sale?', '2023-05-18 14:30:00'),
  (1, 2, 'A18', 'Hello Jane, I''m interested in the Smart Home Starter Kit. Is it compatible with Alexa?', '2023-06-26 08:45:00'),
  (2, 1, 'B19', 'Hi John, the Travel Backpack is perfect for my upcoming trip. Is it still available?', '2023-07-31 10:20:00'),
  (2, 6, 'C20', 'Hello Grace, I need the Power Bank Essentials. Can you confirm its capacity?', '2023-08-08 15:30:00'),
  (6, 5, 'D21', 'Hi Alex, the Fashionable Glasses caught my eye. Can we arrange a viewing?', '2023-09-21 09:55:00'),
  (6, 9, 'E22', 'Hello Henry, I need the Portable Chargers Set. Are they in good condition?', '2023-10-29 11:40:00'),
  (9, 10, 'F23', 'Hi Sophia, the Wireless Gaming Consoles are what I''ve been looking for. Are they still available?', '2023-12-01 14:20:00'),
  (10, 11, 'G24', 'Hello Liam, the Formal Wallet Collection is stylish. Is it still for sale?', '2023-12-16 16:10:00'),
  (11, 12, 'H25', 'Hi Ava, the Smartphone Accessories Kit is what I need. Can we discuss the price?', '2024-01-26 10:30:00');

select * from MESSAGE;

INSERT INTO REVIEW (Review_ID, Listing_ID, Student_ID, Rating, Comment, Helpful_Count, Reported_Count)
VALUES
  (1, 'A01', 1, 8, 'Excellent smartphone! Working perfectly.', 10, 2),
  (2, 'B02', 2, 7, 'Nice pair of jeans. Good quality.', 8, 0),
  (3, 'C03', 3, 9, 'Gaming laptop is excellent. No issues.', 15, 1),
  (4, 'D04', 4, 6, 'Decent headphones. Working well.', 5, 0),
  (5, 'E05', 5, 10, 'Love these running shoes! Excellent choice.', 12, 3),
  (6, 'F06', 6, 8, 'Beautiful dress! Good design.', 7, 0),
  (7, 'G07', 7, 9, 'Smartwatch is awesome. Working perfectly.', 9, 1),
  (8, 'H08', 8, 7, 'Good backpack for office. Recommended.', 3, 0),
  (9, 'I09', 9, 10, 'Vintage camera is a gem. Excellent condition.', 20, 2),
  (10, 'J10', 10, 6, 'Graphic tees are okay. Average quality.', 2, 0),
  (11, 'K11', 11, 9, 'Powerful desktop workstation. Working well.', 18, 1),
  (12, 'L12', 12, 1, 'Horrible', 10, 0),
  (13, 'M13', 13, 7, 'Outdoor gear is great. Excellent for adventures.', 6, 0),
  (14, 'N14', 14, 9, 'Excellent Bluetooth speakers. Working flawlessly.', 15, 2),
  (15, 'O15', 15, 6, 'Swimwear with cool prints. Good quality.', 4, 0),
  (16, 'P16', 16, 10, 'Complete camping bundle. Excellent for outdoor trips.', 25, 3),
  (17, 'Q17', 17, 8, 'Comfortable home office chair. Good for long hours.', 11, 1),
  (18, 'A18', 1, 9, 'Smart home kit is amazing. Excellent features.', 13, 0),
  (19, 'B19', 2, 7, 'Good travel backpack. Spacious and durable.', 5, 0),
  (20, 'C20', 2, 10, 'Essential power bank set. Working great.', 14, 2),
  (21, 'D21', 6, 4, 'Not working', 7, 1),
  (22, 'E22', 6, 6, 'Portable chargers are average. Not working sometimes.', 3, 0),
  (23, 'F23', 9, 9, 'Wireless gaming consoles are fantastic. Working perfectly.', 20, 1),
  (24, 'G24', 10, 8, 'Formal wallets are stylish. Good quality material.', 9, 0),
  (25, 'H25', 11, 7, 'Not satisfied with the smartphone accessories kit. Some items not working.', 6, 0);


select * from REVIEW;


INSERT INTO REPORT (Report_ID, Reporter_Student_ID, Admin_ID, Report_Description, Report_Type, Report_Date, Report_Status)
VALUES  
  (1, 1, NULL, 'Inappropriate behavior by another student.', 'M', '2022-01-20', 'Pending'),
  (2, 2, NULL, 'Report about a review. Inappropriate content.', 'R', '2022-02-25', 'Reviewed'),
  (3, 3, NULL, 'Complaint about a listing.', 'L', '2022-03-15', 'Pending'),
  (4, 4, 504, 'Harassment issue. Urgent attention needed.', 'R', '2022-04-10', 'In Progress'),
  (5, 5, 505, 'System access request for a specific feature.', 'M', '2022-05-17', 'Reviewed'),
  (6, 6, NULL, 'Fraudulent activity report.', 'R', '2022-06-23', 'Pending'),
  (7, 7, NULL, 'Reporting inappropriate content.', 'R', '2022-07-27', 'Pending'),
  (8, 8, NULL, 'Bug in the messaging system.', 'M', '2022-08-05', 'Reviewed'),
  (9, 9, NULL, 'Issue with a transaction on the platform.', 'L', '2022-09-12', 'Pending'),
  (10, 10, NULL, 'Feedback on a listing description.', 'L', '2022-10-20', 'Pending'),
  (11, 11, 505, 'Security concern about user data.', 'M', '2022-11-30', 'In Progress'),
  (12, 12, NULL, 'Complaint about a seller.', 'L', '2022-12-07', 'Pending'),
  (13, 13, NULL, 'Report of suspicious activity.', 'R', '2023-01-10', 'Pending'),
  (14, 14, NULL, 'Request for assistance with account recovery.', 'M', '2023-02-25', 'Reviewed'),
  (15, 15, NULL, 'Issue with a purchased item.', 'L', '2023-03-30', 'Pending'),
  (16, 16, NULL, 'Reporting a fraudulent listing.', 'R', '2023-04-07', 'Pending'),
  (17, 17, NULL, 'Feedback on a seller. Possible violation of policies.', 'M', '2023-05-17', 'Pending'),
  (18, 1, NULL, 'Reporting inappropriate content in a message.', 'M', '2023-06-25', 'Pending'),
  (19, 2, NULL, 'Issue with a travel booking.', 'R', '2023-07-30', 'Pending'),
  (20, 2, NULL, 'Bug in the payment processing system.', 'M', '2023-08-07', 'Reviewed'),
  (21, 6, NULL, 'Complaint about a product received.', 'L', '2023-09-20', 'Pending'),
  (22, 6, NULL, 'Reporting a seller for false advertising.', 'R', '2023-10-28', 'Pending'),
  (23, 9, NULL, 'Feedback on a purchased gaming console.', 'M', '2023-11-30', 'Reviewed'),
  (24, 10, NULL, 'Reporting a seller for deceptive practices.', 'L', '2023-12-15', 'Pending'),
  (25, 11, NULL, 'Issue with a smartphone accessories kit.', 'R', '2024-01-25', 'Pending'),
  (26, 1, NULL, 'Report about a review. Inappropriate content.', 'R', '2024-02-10', 'Pending'),
  (27, 2, NULL, 'Reporting a message. Harassment issue.', 'M', '2024-03-15', 'Pending'),
  (28, 3, NULL, 'Report about a listing. Violation of policies.', 'L', '2024-04-20', 'Pending');


select * from REPORT;

INSERT INTO REVIEW_REPORT (Review_Report_ID,Report_ID)
VALUES
  (1,2),
  (2,4),
  (3,6),
  (4,7),
  (5,13),
  (6,16),
  (7,2),
  (8,6),
  (9,11),
  (10,1);


INSERT INTO REVIEW_REPORT (Review_Report_ID, Report_ID, Reported_Review_ID)
VALUES
  (1, 2, 1),
  (2, 4, 2),
  (3, 6, 3),
  (4, 7, 4),
  (5, 13, 5),
  (6, 16, 6),
  (7, 2, 7),
  (8, 6, 8),
  (9, 11, 9),
  (10, 1, 10);

  select * from REVIEW_REPORT;

INSERT INTO MESSAGE_REPORT (Message_Report_ID,Report_ID,Message_ID)
VALUES
  (1,1,2),
  (2,5,3),
  (3,8,5),
  (4,11,7),
  (5,14,9),
  (6,17,11),
  (7,18,13),
  (8,20,15),
  (9,23,17),
  (10,27,19);

select * from MESSAGE_REPORT;

-- Insert data into LISTING_REPORT table
INSERT INTO LISTING_REPORT (Listing_Report_ID, Report_ID, Reported_Listing_ID)
VALUES
  (1, 2, 'A01'),   -- Listing A01 reported in Report 2
  (2, 4, 'B02'),   -- Listing B02 reported in Report 4
  (3, 6, 'C03'),   -- Listing C03 reported in Report 6
  (4, 7, 'D04'),   -- Listing D04 reported in Report 7
  (5, 13, 'M13'),  -- Listing M13 reported in Report 13
  (6, 16, 'P16'),  -- Listing P16 reported in Report 16
  (7, 2, 'B02'),   -- Listing B02 reported in Report 2
  (8, 6, 'C03'),   -- Listing C03 reported in Report 6
  (9, 11, 'K11'),  -- Listing K11 reported in Report 11
  (10, 1, 'A01');  -- Listing A01 reported in Report 1


  select * from LISTING_REPORT;

INSERT INTO MEETUP (Meeting_ID, Buyer_ID, Seller_ID, Description, Date_Time, Location, Type)
VALUES
  (1, 101, 102, 'Discussing product details', '2022-01-20 15:00:00', 'Coffee Shop A', 'Business'),
  (2, 103, 104, 'Finalizing transaction', '2022-02-25 14:30:00', 'Restaurant B', 'Casual'),
  (3, 105, 106, 'Inspecting item before purchase', '2022-03-15 16:45:00', 'Park C', 'Casual'),
  (4, 107, 108, 'Negotiating price', '2022-04-10 12:00:00', 'Mall D', 'Business'),
  (5, 109, 110, 'Exchange of purchased items', '2022-05-17 17:30:00', 'Coffee Shop E', 'Casual'),
  (6, 111, 112, 'Discussing custom order', '2022-06-23 13:15:00', 'Park F', 'Business'),
  (7, 113, 114, 'Meeting for product demonstration', '2022-07-27 15:45:00', 'Restaurant G', 'Business'),
  (8, 115, 116, 'Finalizing details for delivery', '2022-08-05 14:00:00', 'Mall H', 'Casual'),
  (9, 117, 101, 'Inspecting item before purchase', '2022-09-12 16:30:00', 'Coffee Shop A', 'Casual'),
  (10, 102, 103, 'Negotiating price', '2022-10-20 12:45:00', 'Park B', 'Business'),
  (11, 104, 105, 'Exchange of purchased items', '2022-11-30 17:15:00', 'Mall C', 'Casual'),
  (12, 106, 107, 'Discussing custom order', '2022-12-07 13:30:00', 'Restaurant D', 'Business'),
  (13, 108, 109, 'Meeting for product demonstration', '2023-01-10 15:00:00', 'Coffee Shop E', 'Business'),
  (14, 110, 111, 'Finalizing details for delivery', '2023-02-25 14:15:00', 'Park F', 'Casual'),
  (15, 112, 113, 'Inspecting item before purchase', '2023-03-30 16:45:00', 'Mall G', 'Casual'),
  (16, 114, 115, 'Negotiating price', '2023-04-07 12:30:00', 'Restaurant H', 'Business'),
  (17, 116, 117, 'Exchange of purchased items', '2023-05-17 17:00:00', 'Coffee Shop A', 'Casual'),
  (18, 101, 102, 'Discussing custom order', '2023-06-25 13:45:00', 'Park B', 'Business'),
  (19, 103, 104, 'Meeting for product demonstration', '2023-07-30 15:15:00', 'Mall C', 'Business'),
  (20, 105, 106, 'Finalizing details for delivery', '2023-08-07 14:30:00', 'Restaurant D', 'Casual'),
  (21, 107, 108, 'Inspecting item before purchase', '2023-09-20 16:00:00', 'Coffee Shop E', 'Casual'),
  (22, 109, 110, 'Negotiating price', '2023-10-28 12:15:00', 'Park F', 'Business'),
  (23, 111, 112, 'Exchange of purchased items', '2023-11-30 17:30:00', 'Mall G', 'Casual'),
  (24, 113, 114, 'Discussing custom order', '2023-12-15 13:00:00', 'Restaurant H', 'Business'),
  (25, 115, 116, 'Meeting for product demonstration', '2024-01-25 15:30:00', 'Coffee Shop A', 'Business');


select * from MEETUP;






