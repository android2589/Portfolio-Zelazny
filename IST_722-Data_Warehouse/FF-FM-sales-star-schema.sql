/****** Object:  Database ist722_hhkhan_ob4_dw    Script Date: 3/21/2020 6:46:52 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE ist722_hhkhan_ob4_dw
GO
CREATE DATABASE ist722_hhkhan_ob4_dw
GO
ALTER DATABASE ist722_hhkhan_ob4_dw
SET RECOVERY SIMPLE
GO
*/
USE ist722_hhkhan_ob4_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;





-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
--GO
--CREATE SCHEMA FF_FM
--GO


/*
DROP TABLE FF_FM.FactSales;
DROP TABLE FF_FM.DimProducts;
DROP TABLE FF_FM.DimCustomers;
DROP TABLE FF_FM.DimDate;
*/

/* Drop table FF_FM.FactSales */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FF_FM.FactSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE FF_FM.FactSales 
;


/* Drop table FF_FM.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FF_FM.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE FF_FM.DimDate 
;

/* Create table FF_FM.DimDate */
CREATE TABLE FF_FM.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  datetime   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  smallint   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  smallint   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_FF_FM.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;



INSERT INTO FF_FM.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[FF_FM].[Date]'))
DROP VIEW [FF_FM].[Date]
GO
CREATE VIEW [FF_FM].[Date] AS 
SELECT [DateKey] AS [DateKey]
, [Date] AS [Date]
, [FullDateUSA] AS [FullDateUSA]
, [DayOfWeek] AS [DayOfWeek]
, [DayName] AS [DayName]
, [DayOfMonth] AS [DayOfMonth]
, [DayOfYear] AS [DayOfYear]
, [WeekOfYear] AS [WeekOfYear]
, [MonthName] AS [MonthName]
, [MonthOfYear] AS [MonthOfYear]
, [Quarter] AS [Quarter]
, [QuarterName] AS [QuarterName]
, [Year] AS [Year]
, [IsWeekday] AS [IsWeekday]
FROM FF_FM.DimDate
GO







/* Drop table FF_FM.DimCustomers */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FF_FM.DimCustomers') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE FF_FM.DimCustomers 
;

/* Create table FF_FM.DimCustomers */
CREATE TABLE FF_FM.DimCustomers (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [customer_id]  int   NOT NULL
,  [customer_email]  varchar(100)   NOT NULL
,  [customer_firstname]  varchar(50)   NOT NULL
,  [customer_lastname]  varchar(50)   NOT NULL
,  [customer_address]  varchar(1000)   NOT NULL
,  [customer_city]  varchar(50)   NULL
,  [customer_state]  char(2)   NULL
,  [customer_zip]  varchar(20)   NOT NULL
,  [customer_phone]  varchar(30)   NULL
,  [customer_fax]  varchar(30)   NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_FF_FM.DimCustomers] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT FF_FM.DimCustomers ON
;
INSERT INTO FF_FM.DimCustomers (CustomerKey, customer_id, customer_email, customer_firstname, customer_lastname, customer_address, customer_city, customer_state, customer_zip, customer_phone, customer_fax, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', 'None', 'None', 'None', 'NA', 'None', 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT FF_FM.DimCustomers OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[FF_FM].[Customers]'))
DROP VIEW [FF_FM].[Customers]
GO
CREATE VIEW [FF_FM].[Customers] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [customer_id] AS [customer_id]
, [customer_email] AS [customer_email]
, [customer_firstname] AS [customer_firstname]
, [customer_lastname] AS [customer_lastname]
, [customer_address] AS [customer_address]
, [customer_city] AS [customer_city]
, [customer_state] AS [customer_state]
, [customer_zip] AS [customer_zip]
, [customer_phone] AS [customer_phone]
, [customer_fax] AS [customer_fax]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM FF_FM.DimCustomers
GO







/* Drop table FF_FM.DimProducts */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FF_FM.DimProducts') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE FF_FM.DimProducts 
;

/* Create table FF_FM.DimProducts */
CREATE TABLE FF_FM.DimProducts (
   [ProductKey]  int IDENTITY  NOT NULL
,  [product_id]  int   NOT NULL
,  [product_name]  varchar(200)   NOT NULL
,  [product_retail_price]  money   NULL
,  [product_wholesale_price]  money   NULL
,  [product_is_active]  bit   NOT NULL
,  [product_add_date]  datetime  DEFAULT 'N' NOT NULL
,  [product_vendor_id]  int   NOT NULL
,  [product_description]  varchar(1000)   NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_FF_FM.DimProducts] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT FF_FM.DimProducts ON
;
INSERT INTO FF_FM.DimProducts (ProductKey, product_id, product_name, product_retail_price, product_wholesale_price, product_is_active, product_add_date, product_vendor_id, product_description, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, '-1', 'None', '', '', 0, '12/31/1899', '', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT FF_FM.DimProducts OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[FF_FM].[Products]'))
DROP VIEW [FF_FM].[Products]
GO
CREATE VIEW [FF_FM].[Products] AS 
SELECT [ProductKey] AS [ProductKey]
, [product_id] AS [product_id]
, [product_name] AS [product_name]
, [product_retail_price] AS [product_retail_price]
, [product_wholesale_price] AS [product_wholesale_price]
, [product_is_active] AS [product_is_active]
, [product_add_date] AS [product_add_date]
, [product_vendor_id] AS [product_vendor_id]
, [product_description] AS [product_description]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM FF_FM.DimProducts
GO







/* Drop table FF_FM.FactSales */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FF_FM.FactSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE FF_FM.FactSales 
;

/* Create table FF_FM.FactSales */
CREATE TABLE FF_FM.FactSales (
   [ProductKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [OrderQuantity]  int   NOT NULL
,  [BilledAmount]  money   NOT NULL
, CONSTRAINT [PK_FF_FM.FactSales] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID] )
) ON [PRIMARY]
;



-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[FF_FM].[Sales]'))
DROP VIEW [FF_FM].[Sales]
GO
CREATE VIEW [FF_FM].[Sales] AS 
SELECT [ProductKey] AS [ProductKey]
, [CustomerKey] AS [CustomerKey]
, [OrderDateKey] AS [OrderDateKey]
, [OrderID] AS [OrderID]
, [OrderQuantity] AS [Quantity]
, [BilledAmount] AS [BilledAmount]
FROM FF_FM.FactSales
GO


ALTER TABLE FF_FM.FactSales ADD CONSTRAINT
   FK_FF_FM_FactSales_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES FF_FM.DimProducts
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE FF_FM.FactSales ADD CONSTRAINT
   FK_FF_FM_FactSales_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES FF_FM.DimCustomers
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE FF_FM.FactSales ADD CONSTRAINT
   FK_FF_FM_FactSales_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES FF_FM.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
