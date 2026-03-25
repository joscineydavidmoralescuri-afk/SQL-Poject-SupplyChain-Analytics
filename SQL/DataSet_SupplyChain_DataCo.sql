----------------------
---DATA EXTRACCION ---
----------------------

CREATE DATABASE DataCoDB;
USE DataCoDB;

---------------------------------
--------CARGA-DE-DATOS-----------
---------------------------------

IF OBJECT_ID('DataCoSupplyChainDataset', 'U') IS NOT NULL
    DROP TABLE DataCoSupplyChainDataset;

CREATE TABLE DataCoSupplyChainDataset 
(
    Type VARCHAR(50),
    Days_for_shipping_real INT,
    Days_for_shipment_scheduled INT,
    Benefit_per_order NUMERIC(18,2),
    Sales_per_customer NUMERIC(18,2),
    Delivery_Status VARCHAR(50),
    Late_delivery_risk INT,
    Category_Id INT,
    Category_Name VARCHAR(100),
    Customer_City VARCHAR(100),
    Customer_Country VARCHAR(100),
    Customer_Email VARCHAR(100),
    Customer_Fname VARCHAR(100),
    Customer_Id INT,
    Customer_Lname VARCHAR(100),
    Customer_Password VARCHAR(100),
    Customer_Segment VARCHAR(50),
    Customer_State VARCHAR(50),
    Customer_Street VARCHAR(150),
    Customer_Zipcode VARCHAR(20),
    Department_Id INT,
    Department_Name VARCHAR(100),
    Latitude FLOAT,
    Longitude FLOAT,
    Market VARCHAR(50),
    Order_City VARCHAR(100),
    Order_Country VARCHAR(100),
    Order_Customer_Id INT,
    Order_Date_DateOrders DATETIME,
    Order_Id INT,
    Order_Item_Cardprod_Id INT,
    Order_Item_Discount NUMERIC(18,2),
    Order_Item_Discount_Rate NUMERIC(18,2),
    Order_Item_Id INT,
    Order_Item_Product_Price NUMERIC(18,2),
    Order_Item_Profit_Ratio NUMERIC(18,2),
    Order_Item_Quantity INT,
    Sales NUMERIC(18,2),
    Order_Item_Total NUMERIC(18,2),
    Order_Profit_Per_Order NUMERIC(18,2),
    Order_Region VARCHAR(100),
    Order_State VARCHAR(100),
    Order_Status VARCHAR(50),
    Order_Zipcode VARCHAR(20),
    Product_Card_Id INT,
    Product_Category_Id INT,
    Product_Description VARCHAR(MAX),
    Product_Image VARCHAR(255),
    Product_Name VARCHAR(150),
    Product_Price NUMERIC(18,2),
    Product_Status INT,
    Shipping_Date_DateOrders DATETIME,
    Shipping_Mode VARCHAR(50)
);

BULK INSERT SupplyChain_Data
FROM 'C:\SQL-Poject-SupplyChain-Analytics\DATA\DataCoSupplyChainDataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,           -- Ignora el encabezado del CSV
    FIELDTERMINATOR = ',',  -- Cambia por ';' si tu CSV usa punto y coma
    ROWTERMINATOR = '\n', -- Salto de linea estandar (LF) o '\n'
    --ENCODING = 'UTF-8'      -- Importante si tienes acentos o tildes
    TABLOCK
);

SELECT *
FROM DataCoSupplyChainDataset