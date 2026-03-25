# Proyecto SQL: Analisis Estrategico de Ventas y Cadena de Suministro

## Resumen (Overview)
La compañia de operaciones de **DataCo Global** busca optimizar su eficiencia logística y mejorar la precisión en la planificación de la demanda, donde la empresa enfrentó retos significativos en la variabilidad de la demanda y retrasos críticos en el despacho en regiones específicas.

Mi objetivo dentro de **SQL Server Management Studio (SSMS)** es normalizar y transformar datos transaccionales brutos en KPIs estratégicos y analisis de sus ventas a través de técnicas avanzadas como **CTEs** y **Window Functions**, proporcionando una visualizacion técnica al departamento para mejorar la retención de clientes, clasificar inventarios (ABC) y proyectar cargas de trabajo mediante horizontes de tiempo.



## Estructura del Proyecto

- [Sobre los Datos](#sobre-los-datos)
- [Habilidades SQL Aplicadas](#habilidades-sql-aplicadas)
- [Tareas](#tareas-tasks)
- [Preparación de Datos y Modelado](#preparación-de-datos-y-modelado)
- [Análisis Exploratorio de Datos e Insights (EDA)](#análisis-exploratorio-de-datos-e-insights-eda)
- [Conclusiones Generales](#conclusiones-generales)



## Sobre los Datos

El conjunto de datos captura información detallada sobre:
* **Órdenes de compra:** Cantidades, precios, beneficios y fechas.
* **Geografía:** Ubicación precisa de clientes por ciudad, estado y país.
* **Logística:** Métodos de envío, días de despacho reales vs. programados y tipos de pago.
* **Catálogo:** Jerarquía de productos por categorías y departamentos.

Para mayor información de la fuente de datos originales se puede encontrar en este [Link](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis?select=DataCoSupplyChainDataset.csv).

El modelo cuenta con una tabla de hechos principal (`Fact_Orders`) y múltiples dimensiones para un análisis granular.

![image](https://github.com/joscineydavidmoralescuri-afk/SQL-Poject-SupplyChain-Analytics/blob/6b5b73e26a266dc348cb9979fc957fc663e66d24/Picture/Diagrama-Relacional.PNG)

*Nota: Diagrama Relacional de los datos.*

---

## Habilidades SQL Aplicadas

Se implementaron soluciones que garantizan cálculos precisos y escalables:

* **Joins Complejos:** Consolidación de multiples tablas de dimensiones 
* **CTEs (Common Table Expressions):** Estructuración de consultas modulares para procesos de cálculo multi-etapa.
* **Window Functions (`OVER`, `PARTITION BY`):** Determinación de rankings de clientes, participaciones acumuladas y métricas de crecimiento.
* **Personalización de Ventanas (Frame Clauses):** Implementación para el cálculo de promedios móviles (suavizado de demanda) y horizontes de carga proyectada.
* **Lógica Condicional (CASE):** Segmentación de mercados, alertas de cumplimiento de hitos financieros y clasificación ABC de inventario.
* **Agregaciones Estadísticas:** Uso de `STDEV`, `AVG` y `SUM` para medir la variabilidad y el riesgo de la demanda.

## Tareas (Tasks)

En este análisis, complemento al departamento a responder lo siguiente, dividido en tres bloques:

### BLOQUE A: Fundamentos Rentabilidad y KPIs de Operación

1. **Termómetro de Rentabilidad por Categoría:** ¿Cuál es el margen neto porcentual y el beneficio total por categoría de producto para identificar el rendimiento financiero del catálogo?
2. **Radar de Segmentación VIP:** ¿Cuál es el ticket promedio y el volumen de pedidos por segmento de cliente para priorizar las estrategias de fidelización?
3. **Auditoría de Cumplimiento Logístico:** ¿Cuál es la desviación en días entre el envío real y el programado según el modo de entrega para calificar la eficiencia del transporte?
4. **Ranking de Mercados Estratégicos:** ¿Cuáles son los 3 mercados principales que lideran la facturación global y el volumen de pedidos de la compañía?
5. **Contribución Acumulada de Productos (Pareto):** ¿Cuál es el porcentaje de participación acumulada de cada producto sobre la venta global para identificar los artículos críticos del inventario?

### BLOQUE B: Inteligencia de Negocio y Tendencias Estratégicas

6. **Estacionalidad y Planificación Operativa:** ¿Cuál es el volumen de ventas por año y trimestre, y qué periodos superan los 10,000 pedidos marcando picos de demanda operativa?
7. **Elasticidad y Análisis de Descuentos:** ¿Cómo impactan los rangos de descuento (0% a >20%) en el beneficio promedio y qué categorías presentan pérdidas en los niveles de descuento más altos?
8. **Estabilidad de la Demanda (Coeficiente de Variación):** ¿Qué categorías de productos muestran mayor volatilidad en sus ventas mensuales y representan un riesgo para la gestión de stock?
9. **Oportunidades de Venta Cruzada (Cross-selling):** ¿Cuál es el promedio de categorías distintas adquiridas por cliente según su segmento para identificar el potencial de diversificación de compra?
10. **Evolución y Crecimiento Mensual (MoM):** ¿Cuál es la tasa de crecimiento porcentual de las ventas mes a mes y en qué periodos se detectan las mayores aceleraciones o caídas financieras?

### BLOQUE C: Inteligencia Predictiva y Flujo de Inventarios

11. **Monitor de Ventas Acumuladas (Running Total):** ¿Cuál es la evolución mensual de la venta acumulada por mercado y en qué momento exacto se alcanza el hito crítico del primer millón en ventas netas?
12. **Suavizado de Demanda (Promedio Móvil):** ¿Cuál es el promedio móvil de los últimos 3 meses por categoría y cómo se utiliza esta métrica para mitigar el "Efecto Látigo" en la planeación de stock?
13. **Clasificación ABC de Inventario:** ¿Qué categorías de productos se definen como "Clase A" al representar el primer 80% de la ganancia global mediante el análisis de Pareto acumulado?
14. **Auditoría de Brecha de Servicio Geográfica:** ¿Cuál es la ineficiencia logística en días de cada ciudad respecto al estándar de su propio país y qué métodos de pago impactan más en el retraso?
15. **Proyección de Carga de Trabajo (Workload):** ¿Cuál es la carga de unidades proyectada para el trimestre móvil por mercado utilizando horizontes de tiempo para anticipar la presión operativa?

## Preparación de Datos y Modelado

El conjunto de datos original consistía en un archivo CSV plano con 53 columnas, el proceso de preparación fue tedioso para poder transformar estos datos en un modelo relacional eficiente.

### 1. Importe y Cambio de Datos
Debido a la complejidad de los tipos de datos originales y las restricciones de importación en **SQL Server (SSMS)**, se optó por una via tediosa como estrategia de carga:
* Se importó el archivo mediante el asistente *Import Flat File*, configurando inicialmente las columnas como `VARCHAR` para evitar pérdida de precisión en decimales y fechas.
* **Cambio de Tipos:** Mediante scripts SQL, se transformaron manualmente las columnas a sus formatos correctos (`FLOAT`, `INT`, `DATETIME`,`NUMERIC`), garantizando el manejo de datos posteriores.

```sql
-- Fragmentos del proceso del cambio de datos

select
    -- 1. Identificadores (A INT)
	TRY_CAST([Days_for_shipping_real] AS INT) AS Days_for_shipping_real,
	TRY_CAST([Days_for_shipment_scheduled] AS INT) AS Days_for_shipment_scheduled,
	
        -- 2. Dinero y Decimales (A FLOAT para manejar los puntos del CSV)
    TRY_CAST([Benefit_per_order] AS NUMERIC(10,2)) AS Benefit_per_order,
	TRY_CAST([Sales_per_customer] AS NUMERIC(10,2)) AS Sales_per_customer,

     -- 3. Coordenadas (A FLOAT)
    TRY_CAST([Latitude] AS FLOAT) AS Latitude,
    TRY_CAST([Longitude] AS FLOAT) AS Longitude,

     -- 4. Fechas (A DATETIME)
    TRY_CAST([order_date_DateOrders] AS DATETIME) AS Order_Date,
    TRY_CAST([shipping_date_DateOrders] AS DATETIME) AS Shipping_Date;

```

### 2. Normalizacion de Datos (Snowflake Schema)
Para optimizar las consultas, se realizó una **Normalización**, separando el archivo plano en un **Esquema de Copo de Nieve (Snowflake Schema)**:
* **Tabla de Hechos:** `Fact_Orders` 
* **Tablas de Dimensiones:** `Dim_Product`, `Dim_Order_Location`, `Dim_Customer`, `Dim_Shipping`, `Dim_Category` y `Dim_Department`

```sql
-- Fragmento del proceso de normalización (Se aplicó la misma lógica para cada tabla)

CREATE TABLE Dim_Department (
    Department_Id INT PRIMARY KEY,
    Department_Name NVARCHAR(255)
);

-- 1.1 Insertar los datos únicos
INSERT INTO Dim_Department (Department_Id, Department_Name)
SELECT DISTINCT 
    Department_Id, 
    Department_Name
FROM DataCo_Clean
WHERE Department_Id IS NOT NULL;
```

### 3. Limpieza y Verficacion de Datos
A pesar de la calidad general del dataset, se ejecutaron scripts para asegurar el análisis óptimo:
* **Verificacion:** Se identificaron y trataron columnas con valores ausentes en dimensiones geográficas.
* **Eliminación de Redundancias:** Se descartaron columnas y filas con información no necesaria o duplicada que no aportaban valor al análisis.

```sql
-- Fragmento del proceso de verificación (Se aplicó la misma lógica para cada tabla)
 
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

```

## Análisis Exploratorio de Datos e Insights (EDA)

En este apartado, se plantearon 15 casuísticas agrupadas por bloques, planteando una solución e interpretación para cada caso.

### BLOQUE A
### Pregunta #1: ¿Cuál es el margen neto porcentual y el beneficio total por categoría de producto para identificar el rendimiento financiero del catálogo?

Para determinar qué categorías están impulsando la rentabilidad utilicé funciones de agregación como `SUM` y operaciones aritméticas para calcular el Margen Neto Porcentual uniendo la tabla de hechos con las dimensiones de Producto y Categoría mediante `INNER JOIN` para obtener una visión clara.

```sql
SELECT 
    DC.Category_Name AS Nombre_Categoria,
    ROUND(SUM(FO.Order_Item_Total), 2) AS Ventas_Netas_Total,
    ROUND(SUM(FO.Benefit_per_order), 2) AS Beneficio_Total,
    ROUND((SUM(FO.Benefit_per_order) / SUM(FO.Order_Item_Total)) * 100, 2) AS Margen_Neto_Porcentaje
FROM fact_orders AS FO
    INNER JOIN Dim_Product DP ON DP.Product_Card_Id = FO.Product_Card_Id
    INNER JOIN Dim_Category DC ON DC.Category_Id = DP.Category_Id
GROUP BY DC.Category_Name
ORDER BY Margen_Neto_Porcentaje DESC;
```
![Pregunta 1](Picture\P1.PNG)
*Resultado Obtenido.*

Identifiqué que existen categorías que operan con un Margen Neto del 19.25%, actuando como los pilares de rentabilidad de la compañía, por otro lado se detectaron categorías con un margen crítico del 0.68%, lo cual representa un riesgo operativo; por lo que se sugiere realizar una revisión profunda de los costos operativos y la política de descuentos aplicados con el objetivo de ajustar la estructura de costos para elevar progresivamente estos porcentajes y asegurar que cada línea de producto contribuya positivamente al negocio

### Pregunta #2: ¿Cuál es el ticket promedio y el volumen de pedidos por segmento de cliente para priorizar las estrategias de fidelización?

Para este análisis, busqué identificar el comportamiento de compra según el perfil del cliente lo que utilicé la métrica de **Ticket Promedio**, calculada mediante la división de la venta neta total entre el recuento de órdenes únicas (`COUNT DISTINCT`), garantizando que cada pedido se contabilizara una sola vez independientemente del número de artículos incluidos.

```sql
SELECT 
    DCO.Customer_Segment AS Segmento, 
    COUNT(DISTINCT FO.Order_Id) AS Volumen_Pedidos,
    ROUND(SUM(FO.Order_Item_Total), 2) AS Venta_Total_Neta,
    ROUND(SUM(FO.Order_Item_Total) / COUNT(DISTINCT(FO.Order_Id)), 2) AS Ticket_Promedio
FROM Fact_Orders FO
    INNER JOIN Dim_Customer DCO ON DCO.Customer_Id = FO.Customer_Id
GROUP BY DCO.Customer_Segment
ORDER BY Ticket_Promedio DESC;
```
![Pregunta 2](Picture\P2.PNG)
*Resultado Obtenido.*

El segmento Corporate destaca con el Ticket Promedio más alto, a pesar de tener un menor volumen de pedidos en comparación con los demás, por otro lado, el segmento Consumer se posiciona como el pilar fundamental de los ingresos netos, registrando el mayor volumen de transacciones operativas; lo que se sugiere implementar campañas de fidelización diferenciadas: para el sector Corporate, el enfoque debe ser la retención personalizada para evitar perdidas de cuentas de alto valor y el sector Consumer, la prioridad es asegurar un flujo constante

### Pregunta #3: ¿Cuál es la desviación en días entre el envío real y el programado según el modo de entrega para calificar la eficiencia del transporte?

En este caso desarrollé una consulta utilizando una **CTE (Common Table Expression)** para promediar los tiempos de envío reales frente a los programados, luego apliqué una estructura lógica `CASE` para categorizar cada modo de envío en estados de **Eficiencia, Puntualidad o Retraso**, permitiendo identificar fallas según el tipo de servicio.

```sql
WITH Resumen AS
(
    SELECT DS.Shipping_Mode AS Modo_Envio,
           AVG(FO.Days_for_shipping_real) AS Promedio_Real,
           AVG(FO.Days_for_shipment_scheduled) AS Promedio_Programado
    FROM Fact_Orders FO
        INNER JOIN Dim_Shipping DS ON DS.Shipping_Id = FO.Shipping_Id
    GROUP BY DS.Shipping_Mode
)
SELECT *,
       Promedio_Real - Promedio_Programado AS Desviacion_Dias,
       CASE 
           WHEN Promedio_Real - Promedio_Programado > 0 THEN 'RETRASO'
           WHEN Promedio_Real - Promedio_Programado < 0 THEN 'EFICIENTE'
           ELSE 'PUNTUAL'
       END AS Estado_Logistico_Envio
FROM Resumen;
```
![Pregunta 3](Picture\P3.PNG)
*Resultado Obtenido.*

El análisis revela que el modo de envío influye directamente en el cumplimiento de la entrega, el modo Standard Class destaca como el más eficiente, operando dentro o por debajo de los tiempos programados, sin embargo, los servicios First Class y Second Class presentan desviaciones positivas, lo que indica retrasos en estas modalidades; lo que se recomienda optimizar los procesos de despacho y las rutas logísticas para las órdenes prioritarias ya que es fundamental para garantizar que los clientes que pagan por servicios más rápidos reciban una experiencia satisfactoria evitando así posibles reclamos o pérdida de lealtad.

### Pregunta #4: ¿Cuáles son los 3 mercados principales que lideran la facturación global y el volumen de pedidos de la compañía?

Para identificar las regiones con mayor impacto en los ingresos, implementé una **CTE** junto con la función de ventana `DENSE_RANK()` lo cual me permitió clasificar los mercados basándome en su facturación total, incluso si existieran empates en los valores; además, integré un conteo único de órdenes para evaluar la relación entre el volumen operativo y el valor monetario de cada región.

```sql
WITH Ranking AS
(
    SELECT 
        DOL.Market AS Mercado,
        ROUND(SUM(FO.Order_Item_Total), 2) AS Total_Venta_Neta,
        COUNT(DISTINCT FO.Order_Id) AS Volumen_Pedidos,
        DENSE_RANK() OVER(ORDER BY SUM(FO.Order_Item_Total) DESC) AS Puesto
    FROM Fact_Orders FO
        INNER JOIN Dim_Order_Location DOL ON DOL.Order_Location_Id = FO.Order_Location_Id
    GROUP BY DOL.Market
)
SELECT *
FROM Ranking 
WHERE Puesto <= 3;
```
![Pregunta 4](Picture\P4.PNG)
*Resultado Obtenido.*

Los resultados confirman que Europe, LATAM y Pacific Asia son los tres pilares comerciales de la compañía, Europe lidera indiscutiblemente tanto en ventas como en volumen, LATAM demuestra una alta eficiencia monetaria, ya que genera mayores ingresos netos que Pacific Asia a pesar de tener un volumen de pedidos ligeramente inferior; se sugiere mantener el liderazgo en Europe mediante la optimización de sus procesos, LATAM, se debe ser potenciar su rentabilidad por pedido y Pacific Asia debe aumentar el valor a sus paquetes de productos provechando su alta capacidad operativa de volumen de pedidos.

### Pregunta #5: ¿Cuál es el porcentaje de participación acumulada de cada producto sobre la venta global para identificar los artículos críticos del inventario?

Para este análisis, apliqué el **Principio de Pareto** con el fin de clasificar los productos según su impacto económico, utilicé dos **CTEs** y funciones de ventana (`SUM OVER`) para calcular tanto la venta acumulada como la venta total global de forma dinámica, esto permitió determinar con precisión el peso porcentual de cada artículo sobre el ingreso total de la compañía, facilitando la identificación de los productos que sostienen el negocio.

```sql
WITH Ventas_Producto AS
(
    SELECT DP.Product_Name AS Nombre_Producto,
           ROUND(SUM(FO.Order_Item_Total), 2) AS Ventas_Neta
    FROM Fact_Orders FO
        INNER JOIN Dim_Product DP ON DP.Product_Card_Id = FO.Product_Card_Id
    GROUP BY DP.Product_Name
),
Pareto AS
(
    SELECT *,
           SUM(Ventas_Neta) OVER(ORDER BY Ventas_Neta DESC) AS Venta_Acumulada,
           SUM(Ventas_Neta) OVER() AS Venta_Total_Global
    FROM Ventas_Producto
)
SELECT *,
       ROUND((Venta_Acumulada / Venta_Total_Global) * 100, 2) AS Porcentaje_Acumulado
FROM Pareto;
```
![Pregunta 5](Picture\P5.PNG)
*Resultado Obtenido.*

El análisis revela una alta concentración de ingresos: solo los primeros 7 productos generan casi el 77% de las ventas netas totales, esta dependencia significa que cualquier interrupción tendría un impacto crítico en la empresa, se sugiere establecer un Stock de Seguridad más amplio para este grupo selecto de productos, y negociar contratos de prioridad con estos artículos.

### BLOQUE B
### Pregunta #6: ¿Cuál es el volumen de ventas por año y trimestre, y qué periodos superan los 10,000 pedidos marcando picos de demanda operativa?

Realicé un análisis temporal desglosado por año y trimestre, donde utilicé funciones de fecha como `YEAR()` y `DATEPART(QUARTER)`, junto con una cláusula `HAVING` para filtrar únicamente aquellos periodos de alta demanda (más de 10,000 pedidos); además, implementé `DENSE_RANK()` para jerarquizar los periodos con mayor carga operativa histórica.

```sql
-- Estacionalidad y Planificación Operativa
SELECT 
    YEAR(Order_Date) AS Año,
    DATEPART(QUARTER, Order_Date) AS Trimestre,
    ROUND(SUM(Order_Item_Total), 2) AS Ventas_Netas,
    COUNT(DISTINCT Order_Item_Id) AS Total_Pedidos,
    DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT Order_Item_Id) DESC) AS Top_Operativo
FROM Fact_Orders
GROUP BY YEAR(Order_Date), DATEPART(QUARTER, Order_Date)
HAVING COUNT(DISTINCT Order_Item_Id) > 10000;
```
![Pregunta 6](Picture\P6.PNG)
*Resultado Obtenido.*

Se evidencia que el cuarto trimestre (Q4) representó el mayor volumen operativo durante los años 2015 y 2016, sin embargo, un hallazgo en el tercer trimestre (Q3) del año 2017, se alcanzó el valor máximo histórico en ventas netas, superando todos los picos de años anteriores y marcando un nuevo estándar de crecimiento para la compañía; se recomienda realizar un seguimiento progresivo y detallado para asegurar estos incrementos de demanda, y de replicar qué factores impulsaron el éxito del Q3 en 2017 para mantener la trayectoria de crecimiento en los siguientes periodos.

### Pregunta #7: ¿Cómo impactan los rangos de descuento (0% a >20%) en el beneficio promedio y qué categorías presentan pérdidas en los niveles de descuento más altos?

Desarrollé un análisis de **Rangos de Descuento** utilizando una **CTE** y lógica condicional `CASE`, lo cual el objetivo fue identificar en qué punto los descuentos aplicados dejan de incentivar la venta y comienzan a destruir el valor del negocio, específicamente enfocándome en el comportamiento del beneficio promedio por categoría cuando el descuento supera el 20%.

```sql
-- Elasticidad y Análisis de Riesgo por Descuento
WITH Analisis AS 
(
    SELECT DC.Category_Name AS Categoria,
        FO.Order_Profit_Per_Order AS Beneficio,
        ROUND(((FO.Sales - FO.Order_Item_Total) / FO.Sales), 2) AS Tasa_Descuento,
        CASE 
            WHEN ROUND(((FO.Sales - FO.Order_Item_Total) / FO.Sales), 2) = 0 THEN 'Sin Descuento'
            WHEN ROUND(((FO.Sales - FO.Order_Item_Total) / FO.Sales), 2) <= 0.10 THEN 'Bajo (1-10%)'
            WHEN ROUND(((FO.Sales - FO.Order_Item_Total) / FO.Sales), 2) <= 0.20 THEN 'Medio (11-20%)'
            ELSE 'Alto (>20%)'
        END AS Rango
    FROM Fact_Orders FO
    INNER JOIN Dim_Product DP ON DP.Product_Card_Id = FO.Product_Card_Id
    INNER JOIN Dim_Category DC ON DC.Category_Id = DP.Category_Id
)
SELECT Categoria,
    Rango,
    ROUND(AVG(Beneficio), 2) AS Beneficio_Promedio
FROM Analisis
WHERE Rango = 'Alto (>20%)'
GROUP BY Categoria, Rango
ORDER BY Beneficio_Promedio ASC;
```
![Pregunta 7](Picture\P7.PNG)
*Resultado Obtenido.*

Se identificaron 4 categorías críticas que presentan un beneficio promedio negativo, el caso más alarmante es la categoría de Computers, la cual registra una pérdida de valor media de 50.09 por orden cuando se aplican estos niveles de promoción; se recomienda implementar un ajuste en la politica de descuentos, equilibrando el volumen de ventas con la rentabilidad necesaria para la sostenibilidad de la empresa.

### Pregunta #8: ¿Qué categorías de productos muestran mayor volatilidad en sus ventas mensuales y representan un riesgo para la gestión de stock?

Realicé un análisis de **Estabilidad de la Demanda**, utilicé una **CTE** para agrupar las ventas de forma mensual por categoría y luego apliqué funciones estadísticas (`STDEV` y `AVG`) para calcular el **Coeficiente de Variación (CV)**, lo que esta métrica es fundamental, ya que permite distinguir entre productos de demanda estable y aquellos con comportamiento errático o altamente estacional.

```sql
WITH Ventas_Mensuales AS 
(
    SELECT DC.Category_Name,
        YEAR(FO.Order_Date) AS Año,
        MONTH(FO.Order_Date) AS Mes,
        SUM(FO.Order_Item_Total) AS Ventas_Netas
    FROM Fact_Orders FO
    INNER JOIN Dim_Product DP ON DP.Product_Card_Id = FO.Product_Card_Id
    INNER JOIN Dim_Category DC ON DC.Category_Id = DP.Category_Id
    GROUP BY DC.Category_Name, YEAR(FO.Order_Date), MONTH(FO.Order_Date)
)
SELECT Category_Name,
    ROUND(AVG(Ventas_Netas), 2) AS Promedio_Venta_Mensual,
    ROUND(STDEV(Ventas_Netas), 2) AS Desviacion_Estandar,
    ROUND(STDEV(Ventas_Netas) / AVG(Ventas_Netas), 4) AS Coeficiente_Variacion
FROM Ventas_Mensuales
GROUP BY Category_Name
ORDER BY Coeficiente_Variacion DESC;
```
![Pregunta 8](Picture\P8.PNG)
*Resultado Obtenido.*

El análisis revela categorías como Cameras y Strength Training que presentan una variabilidad superior al 120% respecto a su promedio mensual, esto indica una demanda altamente impredecible o estacional, mientras que categorías con 18% inferior muestran una estabilidad notable; se recomienda implementar un Stock de Seguridad significativamente más amplio para las categorías de alta volatilidad para minimizar riesgo de quiebres de stock, mientras que categorías estables se sugiere adoptar un modelo de stocks ciclicos.

### Pregunta #9: ¿Cuál es el promedio de categorías distintas adquiridas por cliente según su segmento para identificar el potencial de diversificación de compra?

Desarrollé un análisis que cuantifica cuántas categorías únicas explora cada cliente, utilicé una **CTE** para agrupar las transacciones por cliente y segmento, aplicando un `COUNT(DISTINCT)` sobre los IDs de categoría, y finalmente, calculé métricas de tendencia central (`AVG`) y valores extremos (`MAX`) para identificar oportunidades en la expansión del portafolio por consumidor.

```sql
WITH Conteo_Categorias AS 
(
    SELECT FO.Customer_Id,
        DCU.Customer_Segment AS Segmento,
        COUNT(DISTINCT DP.Category_Id) AS Total_Categorias_Compradas
    FROM Fact_Orders FO
    INNER JOIN Dim_Customer DCU ON FO.Customer_Id = DCU.Customer_Id
    INNER JOIN Dim_Product DP ON FO.Product_Card_Id = DP.Product_Card_Id
    GROUP BY FO.Customer_Id, DCU.Customer_Segment
)
SELECT Segmento,
    COUNT(*) AS Numero_de_Clientes,
    ROUND(AVG(CAST(Total_Categorias_Compradas AS FLOAT)), 2) AS Promedio_Categorias_por_Cliente,
    MAX(Total_Categorias_Compradas) AS Record_Categorias_un_Solo_Cliente
FROM Conteo_Categorias
GROUP BY Segmento
ORDER BY Promedio_Categorias_por_Cliente DESC;
```
![Pregunta 9](Picture\P9.PNG)
*Resultado Obtenido.*

Los datos muestran una consistencia notable entre segmentos, con un promedio de 4.8 categorías por cliente, esto indica que los consumidores ya satisfacen múltiples necesidades dentro de la plataforma, sin embargo la existencia de clientes con registros de hasta 15 o 16 categorías distintas revela un potencial de crecimiento significativo; se recomienda implementar campañas personalizadas que sugieran productos de categorías aún no exploradas por el cliente.

### Pregunta #10: ¿Cuál es la tasa de crecimiento porcentual de las ventas mes a mes y en qué periodos se detectan las mayores aceleraciones o caídas financieras?

Utilicé una serie de **CTEs** para consolidar las ventas mensuales y apliqué la función de ventana `LAG()` para acceder a los datos del periodo anterior , este cálculo es vital para identificar patrones de estacionalidad y detectar anomalías en la trayectoria de ingresos de la compañía.

```sql
WITH Ventas_Mensuales AS (
    SELECT 
        YEAR(Order_Date) AS Año,
        MONTH(Order_Date) AS Mes,
        SUM(Order_Item_Total) AS Venta_Neta
    FROM Fact_Orders
    GROUP BY YEAR(Order_Date), MONTH(Order_Date)
),
Venta_Anterior AS (
    SELECT 
        Año,
        Mes,
        Venta_Neta,
        LAG(Venta_Neta) OVER (ORDER BY Año, Mes) AS Venta_Mes_Anterior
    FROM Ventas_Mensuales
)
SELECT 
    Año,
    Mes,
    ROUND(Venta_Neta, 2) AS Ventas_Totales,
    ROUND(Venta_Mes_Anterior, 2) AS Ventas_Anteriores,
    ROUND(((Venta_Neta - Venta_Mes_Anterior) / (Venta_Mes_Anterior)) * 100, 2) AS Tasa_Crecimiento_MoM
FROM Venta_Anterior;
```
![Pregunta 10](Picture\P10.PNG)
*Resultado Obtenido.*

Se observa una trayectoria operativa generalmente estable, se destaca marzo de 2015 con un incremento del 13.3%, el mayor registrado en la serie, sin embargo, se detectó una señal de alerta crítica a partir de noviembre de 2017 se inició una caída drástica del -41.68%, tendencia decreciente que se mantuvo hasta enero de 2018, poniendo en riesgo la continuidad operativa; se recomienda determinar si la caída se debió a factores externos, pérdida de clientes clave o problemas de suministro y actuar de inmediato.

### BLOQUE C
### Pregunta #11: ¿Cuál es la evolución mensual de la venta acumulada por mercado y en qué momento exacto se alcanza el hito crítico del primer millón de dólares?

Implementé un análisis de **Venta Acumulada**, donde utilicé dos **CTEs** para consolidar las ventas mensuales y aplicar una función de ventana con el marco `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`, lo que permite sumar los ingresos de forma incremental mes a mes, y finalmente, incluí una lógica de verificación con `CASE` para señalar el cumplimiento de la meta de un millón de dólares por mercado.

```sql
WITH Ventas_Mensuales AS 
(
    SELECT DOL.Market,
        YEAR(FO.Order_Date) AS Año,
        MONTH(FO.Order_Date) AS Mes,
        ROUND(SUM(FO.Order_Item_Total), 2) AS Venta_Mes
    FROM Fact_Orders FO
    INNER JOIN Dim_Order_Location DOL ON FO.Order_Location_Id = DOL.Order_Location_Id
    GROUP BY DOL.Market, YEAR(FO.Order_Date), MONTH(FO.Order_Date)
),
Acumulado AS
(
    SELECT Market,
        Año,
        Mes,
        Venta_Mes,
        ROUND(SUM(Venta_Mes) OVER (PARTITION BY Market, Año ORDER BY Año, Mes
                                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS Venta_Acumulada_Anual
    FROM Ventas_Mensuales
)
SELECT Market,
        Año,
        Mes,
        Venta_Mes,
        Venta_Acumulada_Anual,
        CASE 
            WHEN Venta_Acumulada_Anual >= 1000000 THEN 'ALCANZADO'
        ELSE 'EN PROCESO'
    END AS Verificacion
FROM Acumulado;
```
![Pregunta 11](Picture\P11.PNG)
*Resultado Obtenido.*

Se evidencia que el mercado de LATAM destaca por su rapidez, superando el millón de dólares apenas en su segundo mes registrado tanto en 2015 como en 2017, de manera similar, USCA alcanzó este hito en mayo de 2016, por el contrario, Africa muestra un crecimiento más pausado logrando la meta recién en noviembre de 2016; se recomienda para los mercados considerados "rápidos" (LATAM y USCA), priorizar un stock disponible inmediato y de alta rotación para no frenar su velocidad de venta, mientras en los mercados con crecimiento más lento como África, la estrategia debe centrarse en un stock disponible optimizado y enfocado en los productos de mayor demanda para evitar el exceso de inventario inmovilizado.

### Pregunta #12: ¿Cuál es el promedio móvil de los últimos 3 meses por categoría y cómo se utiliza esta métrica para mitigar el "Efecto Látigo" en la planeación de stock?

Implementé un cálculo de **Promedio Móvil de 3 meses** donde utilicé funciones de ventana con el marco `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW` para suavizar las fluctuaciones mensuales, y adicionalmente, calculé el **Porcentaje de Desviación** para medir qué tan lejos se encuentra la venta real respecto a la tendencia proyectada, permitiendo una toma de decisiones basada en datos históricos recientes.

```sql
WITH Ventas_Categorias AS 
(
    SELECT DC.Category_Name AS Nombre_Categoria,
        YEAR(FO.Order_Date) AS Año,
        MONTH(FO.Order_Date) AS Mes,
        SUM(FO.Order_Item_Total) AS Venta_Real
    FROM Fact_Orders FO
    INNER JOIN Dim_Product DP ON DP.Product_Card_Id = FO.Product_Card_Id
    INNER JOIN Dim_Category DC ON DC.Category_Id = DP.Category_Id
    GROUP BY DC.Category_Name, YEAR(FO.Order_Date), MONTH(FO.Order_Date)
),
Calculo_Movil AS 
(
    SELECT Nombre_Categoria,
        Año,
        Mes,
        Venta_Real,
        ROUND(AVG(Venta_Real) OVER (PARTITION BY Nombre_Categoria ORDER BY Año, Mes 
                                    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS Promedio_Movil_3M
    FROM Ventas_Categorias
)
SELECT 
    *,
    ROUND((Venta_Real - Promedio_Movil_3M) / (Promedio_Movil_3M) * 100, 2) AS Porcentaje_Desviacion
FROM Calculo_Movil;
```
![Pregunta 12](Picture\P12.PNG)
*Resultado Obtenido.*

El promedio móvil actúa como un pronóstico dinámico que permite evaluar desviaciones críticas, se identificó que desviaciones positivas superiores al 30% suelen representar eventos aislados; reaccionar exageradamente a estos picos puede generar un sobrestock innecesario el mes siguiente, por el contrario desviaciones negativas menores al -30% alertan sobre dos escenarios posibles: un quiebre de stock o una pérdida de interés real en la categoría; se recomienda, basar la planeación para estabilizar los pedidos, y es fundamental mantener un stock de seguridad para cubrir las desviaciones positivas moderadas, pero evitando compras impulsivas ante picos extremos, y ante caídas bruscas verificar la disponibilidad de producto.

### Pregunta #13: ¿Qué categorías de productos se definen como "Clase A" al representar el primer 80% de la ganancia global mediante el análisis de Pareto acumulado?

Realicé una **Clasificación ABC** basada en la rentabilidad, donde utilicé **Window Functions** para calcular la ganancia acumulada y el total global, permitiendo segmentar el catálogo en tres niveles de criticidad: Clase A (el 80% de la ganancia), Clase B (el siguiente 15%) y Clase C (el 5% restante), este enfoque permite separar lo "vital" de lo "trivial" en la operación financiera de la compañía.

```sql
WITH Ganancia_Por_Categoria AS 
(
    SELECT DC.Category_Name AS Nombre_Categoria,
        ROUND(SUM(FO.Order_Profit_Per_Order), 2) AS Ganancia_Total
    FROM Fact_Orders FO
    INNER JOIN Dim_Product DP ON FO.Product_Card_Id = DP.Product_Card_Id
    INNER JOIN Dim_Category DC ON DP.Category_Id = DC.Category_Id
    GROUP BY DC.Category_Name
),
Pareto_Calculo AS (
    SELECT 
        Nombre_Categoria,
        Ganancia_Total,
        SUM(Ganancia_Total) OVER (ORDER BY Ganancia_Total DESC 
                                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Ganancia_Acumulada,
        SUM(Ganancia_Total) OVER() AS Ganancia_Global
    FROM Ganancia_Por_Categoria
)
SELECT Nombre_Categoria,
    Ganancia_Total,
    ROUND((Ganancia_Acumulada / Ganancia_Global) * 100, 2) AS Porcentaje_Acumulado,
    CASE 
        WHEN (Ganancia_Acumulada / Ganancia_Global) <= 0.80 THEN 'Clase A'
        WHEN (Ganancia_Acumulada / Ganancia_Global) <= 0.95 THEN 'Clase B'
        ELSE 'Clase C'
    END AS Clasificacion_ABC
FROM Pareto_Calculo;
```
![Pregunta 13](Picture\P13.PNG)
*Resultado Obtenido.*

Los resultados evidencian solo 7 categorías (Clase A) generan el 77% de la ganancia total, esto significa que apenas el 14% de las líneas de productos sostienen casi el 80% de la rentabilidad corporativa, las categorías de Clase B aportan un 18% adicional, mientras que los artículos de Clase C representan una larga cola que solo contribuye con el 5% final de la utilidad; se recomienda, priorizar la gestión de los artículos Clase A asegurando un stock de seguridad amplio y ciclico, para la Clase B, se sugiere un seguimiento periódico mensual, y para la Clase C, se recomienda aplicar políticas de stock mínimo, reduciendo el capital inmovilizado en productos de baja rotación.

### Pregunta #14: ¿Cuál es la ineficiencia logística en días de cada ciudad respecto al estándar de su propio país y qué métodos de pago impactan más en el retraso?

Desarrollé una métrica de **Brecha de Despacho** donde utilicé una **Window Function** para calcular el promedio nacional de días de envío y lo comparé, fila a fila, con el promedio específico de cada ciudad y método de pago, este enfoque permite aislar ineficiencias locales que quedan ocultas en los promedios globales, identificando exactamente dónde se rompe la promesa de servicio.

```sql
WITH Metricas AS 
(
    SELECT DOL.Order_Country AS Pais,
        DOL.Order_City AS Ciudad,
        DS.Type AS Metodo_Pago,
        ROUND(AVG(CAST(FO.Days_for_shipping_real AS FLOAT)), 2) AS Dias_Despacho,
        AVG(CAST(FO.Days_for_shipping_real AS FLOAT)) OVER(PARTITION BY DOL.Order_Country) AS Promedio_Nacional
    FROM Fact_Orders FO
        INNER JOIN Dim_Order_Location DOL ON FO.Order_Location_Id = DOL.Order_Location_Id
        INNER JOIN Dim_Shipping DS ON FO.Shipping_Id = DS.Shipping_Id
    GROUP BY DOL.Order_Country, DOL.Order_City, DS.Type, FO.Days_for_shipping_real
)
SELECT Pais,
    Ciudad,
    Metodo_Pago,
    Dias_Despacho,
    ROUND(Promedio_Nacional, 2) AS Estandar_Pais,
    ROUND(Dias_Despacho - Promedio_Nacional, 2) AS Brecha_Dias
FROM Metricas
WHERE (Dias_Despacho - Promedio_Nacional) > 0 
ORDER BY Brecha_Dias DESC;
```
![Pregunta 14](Picture\P14.PNG)
*Resultado Obtenido.*

Se detectó que el país de Líbano presenta la mayor brecha de días respecto a su estándar nacional, afectando especialmente a las transacciones con métodos de pago CASH y DEBIT, dado que la anomalía se concentra en la ciudad de Beirut, es altamente probable que el cuello de botella sea físico, ya sea infraestructura del centro de distribución o sus rutas, y no administrativo por el procesamiento del pago; se recomienda optimizar las rutas de transporte y despacho, lo cual es vital uniformar el nivel de servicio a nivel nacional y reducir las reclamaciones por parte del cliente.

### Pregunta #15: ¿Cuál es la carga de unidades proyectada para el trimestre móvil por mercado utilizando horizontes de tiempo para anticipar la presión operativa?

Desarrollé una métrica de **Carga de Despacho Proyectada**, donde utilicé funciones de ventana con el marco `ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING` para calcular el volumen total de unidades que el almacén deberá procesar en los próximos tres meses (trimestre móvil), esta herramienta es vital para la planeación de la capacidad instalada y la gestión de turnos del personal operativo según la demanda futura estimada.

```sql
WITH Carga_Historica AS 
(
    SELECT DOL.Market,
        YEAR(FO.Order_Date) AS Año,
        MONTH(FO.Order_Date) AS Mes,
        SUM(FO.Order_Item_Quantity) AS Unidades_Mes
    FROM Fact_Orders FO
    INNER JOIN Dim_Order_Location DOL ON FO.Order_Location_Id = DOL.Order_Location_Id
    GROUP BY DOL.Market, YEAR(FO.Order_Date), MONTH(FO.Order_Date)
)
SELECT 
    Market,
    Año,
    Mes,
    Unidades_Mes AS Carga_Actual,
    SUM(Unidades_Mes) OVER (PARTITION BY Market ORDER BY Año, Mes 
                            ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS Carga_Proyectada_Trimestre
FROM Carga_Historica
ORDER BY Market;
```
![Pregunta 15](Picture\P15.PNG)
*Resultado Obtenido.*

Se identificaron picos de presión operativa, en Europe registró su mayor presión de despacho en julio de 2015, mientras que LATAM y Pacific Asia enfrentaron sus máximos de carga en marzo y noviembre de 2015, respectivamente, estos periodos exigieron una capacidad de respuesta logística significativamente superior al promedio, contrastando con mercados de menor carga respectiva como Africa; se sugiere, en los meses donde la carga proyectada sea mucho mayor, se debe considerar la contratación de personal temporal o la implementación de turnos rotativos adicionales.

## Conclusiones Generales

* Este análisis integral, desarrollado sobre la base de datos de **DataCo SMART SUPPLY CHAIN**, permitió transformar registros transaccionales en de decisión estratégica para la gerencia de operaciones y finanzas.

* La implementación de consultas en SQL, como el uso de *CTEs* (Common Table Expressions) permitió estructurar análisis multicapa de forma legible y eficiente, mientras que las *Window Functions* y el manejo preciso de *Frames* fueron fundamentales para calcular métricas dinámicas.

* El valor agregado mediante el **Análisis de Pareto y la Clasificación ABC**, el uso del **Coeficiente de Variación y el Promedio Móvil**, como tambien el análisis de **Brecha de Despacho y la Tasa de Crecimiento MoM**, permitieron dar resultados analitícos con presicion y ser interpretadas respectivamente para realizar una ejecucion mediante estrategias personalizadas.

* Para asegurar la sostenibilidad del negocio, la empresa debe adoptar una postura proactiva en la planificación, apoyándose en las proyecciones para monitorear en tiempo real la cadena de suministro, garantizando que la promesa de servicio al cliente se cumpla con la máxima rentabilidad posible.
