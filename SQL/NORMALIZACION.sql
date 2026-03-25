-----------------------------------------------------------------------------------------------------------
--------------------------------TABLAS DE DIMENSIONES------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
USE DataCoDB;

-- 1. Crear la tabla Dim_Department
CREATE TABLE Dim_Department (
    Department_Id INT PRIMARY KEY,
    Department_Name NVARCHAR(255)
);

-- 1.1 Insertar los datos unicos
INSERT INTO Dim_Department (Department_Id, Department_Name)
SELECT DISTINCT 
    Department_Id, 
    Department_Name
FROM DataCoSupplyChainDataset
WHERE Department_Id IS NOT NULL;

-- Verificacion de los datos completos de la tabla
SELECT *
FROM Dim_Department

-- Verificar valores faltantes en la tabla
SELECT COUNT(*) AS Valores_Faltantes
FROM Dim_Department
WHERE Department_Id IS NULL;

-- Verificar valores duplicados en la tabla
SELECT Department_Id, COUNT(*) AS Contador
FROM Dim_Department
GROUP BY Department_Id
HAVING COUNT(*) > 1

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- 2. Crear la tabla Dim_Category
CREATE TABLE Dim_Category (
    Category_Id INT PRIMARY KEY,
    Category_Name NVARCHAR(255),
    Department_Id INT
);

-- 2.1 Establecer la relacion 
ALTER TABLE Dim_Category 
ADD CONSTRAINT FK_Category_Department 
FOREIGN KEY (Department_Id) REFERENCES Dim_Department(Department_Id);

-- 2.2 Insertar los datos unicos
INSERT INTO Dim_Category (Category_Id, Category_Name, Department_Id)
SELECT DISTINCT 
    Category_Id, 
    Category_Name, 
    Department_Id
FROM DataCoSupplyChainDataset
WHERE Category_Id IS NOT NULL;

-- Verificacion de los datos completos de la tabla
SELECT *
FROM Dim_Category

-- Verificar valores faltantes en la tabla
SELECT COUNT(*) AS Valores_Faltantes
FROM Dim_Category
WHERE Category_Id IS NULL;

-- Verificar valores duplicados en la tabla
SELECT Category_Id, COUNT(*) AS Contador
FROM Dim_Category
GROUP BY Category_Id
HAVING COUNT(*) > 1

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- 3. Crear la tabla Dim_Product
CREATE TABLE Dim_Product (
    Product_Card_Id INT PRIMARY KEY,
    Product_Name NVARCHAR(255),
    Product_Image NVARCHAR(255), 
    Product_Status INT,
    Product_Price FLOAT,         
    Category_Id INT              
);

-- 3.1 Establecer la relacion 
ALTER TABLE Dim_Product
ADD CONSTRAINT FK_Product_Category 
FOREIGN KEY (Category_Id) REFERENCES Dim_Category(Category_Id);

-- 3.2 Insertar los datos unicos 
INSERT INTO Dim_Product (Product_Card_Id, Product_Name, Product_Image, Product_Status, Product_Price, Category_Id)
SELECT DISTINCT 
    Product_Card_Id,            
    product_name, 
    product_image, 
    product_status, 
    product_price, 
    category_id
FROM DataCoSupplyChainDataset
WHERE Product_Card_Id IS NOT NULL;

-- Verificacion de los datos completos de la tabla
SELECT *
FROM Dim_Product

-- Verificar valores faltantes en la tabla
SELECT COUNT(*) AS Valores_Faltantes
FROM Dim_Product
WHERE Product_Card_Id IS NULL;

-- Verificar valores duplicados en la tabla
SELECT Product_Card_Id, COUNT(*) AS Contador
FROM Dim_Product
GROUP BY Product_Card_Id
HAVING COUNT(*) > 1

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- 4. Crear la tabla Dim_Customer
CREATE TABLE Dim_Customer (
    Customer_Id INT PRIMARY KEY,
    Customer_Fname NVARCHAR(255),
    Customer_Lname NVARCHAR(255),
    Customer_Segment NVARCHAR(100),
    Customer_Street NVARCHAR(255),
    Customer_Zipcode INT,
    Customer_City NVARCHAR(150),
    Customer_State NVARCHAR(100),
    Customer_Country NVARCHAR(100)
);

-- 4.1 Insertar los datos unicos
INSERT INTO Dim_Customer (
    Customer_Id, 
    Customer_Fname, 
    Customer_Lname, 
    Customer_Segment, 
    Customer_Street, 
    Customer_Zipcode, 
    Customer_City, 
    Customer_State, 
    Customer_Country
)
SELECT DISTINCT 
    Customer_Id, 
    customer_fname, 
    customer_lname, 
    customer_segment, 
    customer_street, 
    customer_zipcode, 
    customer_city, 
    customer_state, 
    customer_country
FROM DataCoSupplyChainDataset
WHERE Customer_Id IS NOT NULL;

-- Verificacion de los datos completos de la tabla
SELECT *
FROM Dim_Customer

-- Verificar valores faltantes en la tabla
SELECT COUNT(*) AS Valores_Faltantes
FROM Dim_Customer
WHERE Customer_Id IS NULL;

-- Verificar valores duplicados en la tabla
SELECT Customer_Id, COUNT(*) AS Contador
FROM Dim_Customer
GROUP BY Customer_Id
HAVING COUNT(*) > 1

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- 5. Crear la tabla Dim_Order_Location
CREATE TABLE Dim_Order_Location (
    Order_Location_Id INT IDENTITY(1,1) PRIMARY KEY, 
    Market NVARCHAR(100),
    Order_Region NVARCHAR(100),
    Order_Country NVARCHAR(100),
    Order_State NVARCHAR(100),
    Order_City NVARCHAR(150),
    Order_Zipcode INT,
    Latitude FLOAT,
    Longitude FLOAT
);

-- 5.1 Insertar los datos unicos de destino
INSERT INTO Dim_Order_Location (
    Market, 
    Order_Region, 
    Order_Country, 
    Order_State, 
    Order_City, 
    Order_Zipcode, 
    Latitude, 
    Longitude
)
SELECT DISTINCT 
    market, 
    order_region, 
    order_country, 
    order_state, 
    order_city, 
    order_zipcode, 
    latitude, 
    longitude
FROM DataCoSupplyChainDataset;

-- Verificacion de los datos completos de la tabla
SELECT *
FROM Dim_Order_Location

-- Verificar valores faltantes en la tabla
SELECT COUNT(*) AS Valores_Faltantes
FROM Dim_Order_Location
WHERE Order_Location_Id IS NULL;

-- Verificar valores duplicados en la tabla
SELECT Order_Location_Id, COUNT(*) AS Contador
FROM Dim_Order_Location
GROUP BY Order_Location_Id
HAVING COUNT(*) > 1

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- 6. Crear la tabla de Logistica y Envio
CREATE TABLE Dim_Shipping (
    Shipping_Id INT IDENTITY(1,1) PRIMARY KEY, 
    Shipping_Mode NVARCHAR(100),
    Delivery_Status NVARCHAR(100),
    Type NVARCHAR(100),          
    Late_delivery_risk INT      
);

-- 6.1 Insertar las combinaciones unicas
INSERT INTO Dim_Shipping (
    Shipping_Mode, 
    Delivery_Status, 
    Type, 
    Late_delivery_risk
)
SELECT DISTINCT 
    shipping_mode, 
    delivery_status, 
    type, 
    late_delivery_risk
FROM DataCoSupplyChainDataset;

-- Verificacion de los datos completos de la tabla
SELECT *
FROM Dim_Shipping

-- Verificar valores faltantes en la tabla
SELECT COUNT(*) AS Valores_Faltantes
FROM Dim_Shipping
WHERE Shipping_Id IS NULL;

-- Verificar valores duplicados en la tabla
SELECT Shipping_Id, COUNT(*) AS Contador
FROM Dim_Shipping
GROUP BY Shipping_Id
HAVING COUNT(*) > 1

-----------------------------------------------------------------------------------------------------------
--------------------------------TABLAS DE HECHOS-----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- 7. Crear la tabla Fact_Orders
CREATE TABLE Fact_Orders (
    Order_Item_Id INT PRIMARY KEY,
    Order_Id INT,
    Customer_Id INT,
    Product_Card_Id INT,
    Order_Location_Id INT,
    Shipping_Id INT,
    
    -- Tiempos y Fechas
    Order_Date DATETIME,
    Shipping_Date DATETIME,
    Days_for_shipping_real INT,
    Days_for_shipment_scheduled INT,
    
    -- Metricas 
    Sales FLOAT,
    Order_Item_Quantity INT,
    Order_Item_Total FLOAT, 
    Order_Item_Discount FLOAT,
    Order_Profit_Per_Order FLOAT,
    Benefit_per_order FLOAT,
    
    -- Estado de la Orden 
    Order_Status NVARCHAR(100)
);

-- 7.1 Insertar los datos relacionando todas las dimensiones
INSERT INTO Fact_Orders
SELECT DISTINCT
    dcc.Order_Item_Id,

	MAX(dcc.Order_Id), 
    MAX(dc.Customer_Id),
    MAX(dp.Product_Card_Id),
    MAX(ol.Order_Location_Id),
    MAX(ds.Shipping_Id),
    
    -- Fechas
    MAX(dcc.Order_Date),
    MAX(dcc.Shipping_Date),
    MAX(dcc.Days_for_shipping_real),
    MAX(dcc.Days_for_shipment_scheduled),
    
    -- Metricas
    MAX(dcc.Sales),
    MAX(dcc.Order_Item_Quantity),
    MAX(dcc.Order_Item_Total),
    MAX(dcc.Order_Item_Discount),
    MAX(dcc.Order_Profit_Per_Order),
    MAX(dcc.Benefit_per_order),
    MAX(dcc.Order_Status)

FROM DataCoSupplyChainDataset AS dcc

-- Unimos con cada dimension

INNER JOIN Dim_Customer dc ON dcc.Customer_Id = dc.Customer_Id
INNER JOIN Dim_Product dp ON dcc.Product_Card_Id = dp.Product_Card_Id
INNER JOIN Dim_Shipping ds ON 
    dcc.shipping_mode = ds.Shipping_Mode AND 
    dcc.delivery_status = ds.Delivery_Status AND 
    dcc.type = ds.Type
INNER JOIN Dim_Order_Location ol ON 
    dcc.market = ol.Market AND 
    dcc.order_region = ol.Order_Region AND 
    dcc.order_city = ol.Order_City AND
    dcc.latitude = ol.Latitude

GROUP BY dcc.Order_Item_Id;

-- 7.2 Establecer la relacion 

ALTER TABLE Fact_Orders 
	ADD CONSTRAINT FK_Fact_Customer 
	FOREIGN KEY (Customer_Id) REFERENCES Dim_Customer(Customer_Id);

ALTER TABLE Fact_Orders 
	ADD CONSTRAINT FK_Fact_Product 
	FOREIGN KEY (Product_Card_Id) REFERENCES Dim_Product(Product_Card_Id);

ALTER TABLE Fact_Orders 
	ADD CONSTRAINT FK_Fact_Location 
	FOREIGN KEY (Order_Location_Id) REFERENCES Dim_Order_Location(Order_Location_Id);

ALTER TABLE Fact_Orders 
	ADD CONSTRAINT FK_Fact_Shipping 
	FOREIGN KEY (Shipping_Id) REFERENCES Dim_Shipping(Shipping_Id);

-- Verificacion de los datos completos de la tabla
SELECT *
FROM Fact_Orders

-- Verificar valores faltantes en la tabla
SELECT COUNT(*) AS Valores_Faltantes
FROM Fact_Orders
WHERE Order_Item_Id IS NULL;

-- Verificar valores duplicados en la tabla
SELECT Order_Item_Id, COUNT(*) AS Contador
FROM Fact_Orders
GROUP BY Order_Item_Id
HAVING COUNT(*) > 1

