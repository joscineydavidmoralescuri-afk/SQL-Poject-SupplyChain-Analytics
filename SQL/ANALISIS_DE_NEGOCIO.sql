-------------------------------------------------------------------------------------------------------------
--------------------------BLOQUE A: Fundamentos y KPIs de Operacion------------------------------------------
-------------------------------------------------------------------------------------------------------------
USE DataCoDB;

--1.El termometro de la rentabilidad
	--�Cual es el margen neto porcentual y el beneficio total por categoria de producto para identificar el rendimiento financiero del catalogo?

SELECT DC.Category_Name AS Nombre_Categoria,
		ROUND(SUM(FO.Order_Item_Total),2) AS Ventas_Netas_Total,
		ROUND(SUM(FO.Benefit_per_order),2) AS Beneficio_Total,
		ROUND((SUM(FO.Benefit_per_order)/SUM(FO.Order_Item_Total))*100,2) AS Margen_Neto_Porcentaje
FROM fact_orders AS FO
	INNER JOIN Dim_Product DP ON DP.Product_Card_Id=FO.Product_Card_Id
	INNER JOIN Dim_Category DC ON DC.Category_Id=DP.Category_Id
GROUP BY DC.Category_Name
ORDER BY Margen_Neto_Porcentaje DESC

	/*CONCLUSION:
		La categoria que tiene el 19.25% de Margen Neta actua como pilar de rentabilidad
		de la compa�ia y el que tiene 0.68% representa un riesgo, por lo que se recomienda
		revisar sus costos operativos y/o los descuentos aplicados, con el objetivo de crecer
		progresivamente los porcentajes y hacer mas rentable el negocio*/

--2. El radar de clientes VIP
	--�Cual es el ticket promedio y el volumen de pedidos por segmento de cliente para priorizar las estrategias de fidelizacion?

SELECT DCO.Customer_Segment AS Segmento, 
		COUNT(DISTINCT FO.Order_Id ) AS Volumen_Pedidos,
		ROUND(SUM(FO.Order_Item_Total),2) AS Venta_Total_Neta,
		ROUND(SUM(FO.Order_Item_Total)/COUNT(DISTINCT(FO.Order_Id)),2) AS Ticket_Promedio
FROM Fact_Orders FO
	INNER JOIN Dim_Customer DCO ON DCO.Customer_Id=FO.Customer_Id
GROUP BY DCO.Customer_Segment
ORDER BY Ticket_Promedio DESC

	/*CONCLUSION:
		El segmento Corporate presenta el Ticket Promedio mas alto y un menor volumen Pedidos, 
		por lo que se recomienda una campa�a de fidelizacion para evitar perdidas significativas
		mientras que el segmento Consumer es el pilar de los Ingresos Netos y un mayor volumen
		de pedidos, por lo que se debe asegurar el flujo constante y retener dichos clientes*/

--3. Auditoria de Cumplimiento Logistico
	--�Cual es la desviacion en dias entre el envio real y el programado segun el modo de entrega para calificar la eficiencia del transporte?
WITH Resumen AS
(
	SELECT DS.Shipping_Mode AS Modo_Envio,
			AVG(FO.Days_for_shipping_real) AS Promedio_Real,
			AVG(FO.Days_for_shipment_scheduled) AS Promedio_Programado
	FROM Fact_Orders FO
		INNER JOIN Dim_Shipping DS ON DS.Shipping_Id=FO.Shipping_Id
	Group By DS.Shipping_Mode
)

SELECT *,
		Promedio_Real - Promedio_Programado AS Desviacion_Dias,
		CASE 
		WHEN Promedio_Real - Promedio_Programado > 0
			THEN 'RETRASO'
		WHEN Promedio_Real - Promedio_Programado < 0 
			THEN 'EFICIENTE'
			ELSE 'PUNTUAL'
		END AS Estado_Logistico_Envio
FROM Resumen

	/*CONCLUSION:
		Se evidencia que el modo de envio si influye en el cumplimiento, el modo Standard Class es
		el mas eficiente, mientras que First Class y Second Class presentan un retraso, lo que se
		recomienda optmizar el proceso de envio para ordenes prioritarias, para que el cliente 
		quede satisfecho con el servicio */
		

--4. Ranking de Mercados por Ventas
	--�Cuales son los 3 mercados principales que lideran la facturacion global y el volumen de pedidos de la compa�ia?
WITH Ranking AS
(
SELECT DOL.Market AS Mercado,
		ROUND(SUM(FO.Order_Item_Total),2) AS Total_Venta_Neta,
		COUNT(DISTINCT FO.Order_Id ) AS Volumen_Pedidos,
		DENSE_RANK() OVER(ORDER BY SUM(FO.Order_Item_Total) DESC) AS Puesto
FROM Fact_Orders FO
	INNER JOIN Dim_Order_Location DOL ON DOL.Order_Location_Id=FO.Order_Location_Id
GROUP BY DOL.Market
)
SELECT *
FROM Ranking 
WHERE Puesto <= 3

	/*CONCLUSION:
		Se verifica los tres mercados Europe, LATAM y Pacific Asia quienes lideran en ventas netas;
		Europe es el que tiene mayor ventas y volumen de pedidos, LATAM tiene un volumen de pedidos
		ligeramente inferior al de Pacific Asia pero un mayor valor en ventas reflejando eficiencia
		monetaria, mientras que Pacific Asia se recomienda estrategias de agregar valor a sus pedidos
		aprovechando su alta capacidad operativa de volumen de pedidos */


--5. Analisis de "Pareto" de Productos
	--�Cual es el porcentaje de participacion acumulada de cada producto sobre la venta global para identificar los articulos criticos del inventario?

WITH Ventas_Producto AS
(
	SELECT DP.Product_Name AS Nombre_Producto,
			ROUND(SUM(FO.Order_Item_Total),2) AS Ventas_Neta
	FROM Fact_Orders FO
		INNER JOIN Dim_Product DP ON DP.Product_Card_Id=FO.Product_Card_Id
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
		ROUND((Venta_Acumulada/Venta_Total_Global)*100,2) AS Porcentaje_Acumulado
FROM Pareto

	/*CONCLUSION:
		Se evidencia que los primeros 7 productos generan casi un 77% de los ingresos netos,
		si en caso algunos de estos productos se quedan sin stock, la empresa perderia una parte
		critica en ventas, lo que se puede sugerir un stock de seguridad mas alto y negociar 
		contratos de prioridad*/


-------------------------------------------------------------------------------------------------------------
--------------------------BLOQUE B: Inteligencia de Negocio y Tendencias-------------------------------------
-------------------------------------------------------------------------------------------------------------

--6. El Pulso del Tiempo: Estacionalidad y Planificacion
	/*�Cual es el volumen total de ventas y cantidad de pedidos mayores a 10000 desglosado por a�o y trimestre,
	y que trimestre presenta historicamente la mayor demanda operativa?*/

SELECT YEAR(Order_Date) AS A�o,
		DATEPART(QUARTER, Order_Date) AS Trimestre,
		ROUND(SUM(Order_Item_Total),2) AS Ventas_Netas,
		COUNT(DISTINCT Order_Item_Id) AS Total_Pedidos,
		DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT Order_Item_Id) DESC) AS Top_Operativo
FROM Fact_Orders
GROUP BY YEAR(Order_Date), DATEPART(QUARTER, Order_Date)
HAVING COUNT(DISTINCT Order_Item_Id)>10000

	/*CONCLUSION:
		Se evidencia que el cuarto trimestre representa el mayor volumen de pedidos tanto en el a�o
		2015 y 2016, sin embargo, se observa en el tercer trimestre del a�o 2017 se alcanzo el mayor
		valor total en ventas superando los a�os anteriores, por lo que se debe hacer seguimiento 
		progresivo para mantener el crecimiento*/

--7. El Dilema de los Descuentos (Elasticidad de Precio)
	/*�Como varia el beneficio promedio por orden segun el nivel del descuento (0%, 1-10%, 11-20%, >20%),
	y cuales son las categorias  que presentan beneficios negativos en el rango de descuento mas alto?*/

WITH Analisis AS 
(
    SELECT DC.Category_Name AS Categoria,
        FO.Order_Profit_Per_Order AS Beneficio,
        ROUND(((FO.Sales - FO.Order_Item_Total)/FO.Sales),2) AS Tasa_Descuento,
        CASE 
            WHEN ROUND(((FO.Sales - FO.Order_Item_Total)/FO.Sales),2) = 0 THEN 'Sin Descuento'
            WHEN ROUND(((FO.Sales - FO.Order_Item_Total)/FO.Sales),2) <= 0.10 THEN 'Bajo (1-10%)'
            WHEN ROUND(((FO.Sales - FO.Order_Item_Total)/FO.Sales),2) <= 0.20 THEN 'Medio (11-20%)'
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
ORDER BY Beneficio_Promedio ASC

	/*CONCLUSION:
		Se evidencia 4 categorias con beneficio promedio negativo bajo la politica de un descuento
		mayor al 20%, y el caso mas alarmante es Computers, con una perdida media de 50.09 dolares
		por orden, por lo que se sugiere una restriccion o reduccion en el porcentaje de descuento 
		con el objetivo de equilibrar y evitar perdidas en la empresa */

--8. Analisis de Estabilidad de Ventas : Coeficiente de Variacion
	/*�Que categorias de productos presentan la mayor variabilidad en sus ventas mensuales,
	y cual es su Coeficiente de Variacion?*/

WITH Ventas_Mensuales AS 
(
    SELECT DC.Category_Name,
        YEAR(FO.Order_Date) AS A�o,
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
    ROUND(STDEV(Ventas_Netas) /AVG(Ventas_Netas), 4) AS Coeficiente_Variacion
FROM Ventas_Mensuales
GROUP BY Category_Name
ORDER BY Coeficiente_Variacion DESC

	/*CONCLUSION:
		Se evidencia en las categorias como Cameras y Strength Training representan una variabilidad superior
		al 120% respecto a su promedio, lo que indica que su demanda es muy estacional, lo que se sugiere un
		stock de seguridad grande para evitar quiebres; mientras las categorias que tienen menos del 18% 
		permiten un manejo mas equilibrado en los inventarios*/

--9. Analisis de Diversificacion de Compra: "Cross-selling" (Cross-Selling)
	/*�Cual es el promedio de categorias distintas que compra un cliente segun su Segmento,
	y que segmento representa la mayor oportunidad para campa�as de venta cruzada?*/

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
ORDER BY Promedio_Categorias_por_Cliente DESC

	/*CONCLUSION:
		Se evidencia que el promedio de categorias por cliente sea aproximadamente 4.8 en todos
		los segmentos lo que indica que el cliente satisface multiples necesidades con diferentes
		categorias y el hecho que existan clientes con records de 15 o 16 categorias hace que 
		exista la oportunidad de expandir el promedio diversificando mas las categorias; y que el
		segmento Consumer representa la mayor oportunidad debido a su volumen de clientes*/

--10. Evolucion Mensual: Tasa de Crecimiento (MoM)
	/*�Cual es la tasa de crecimiento porcentual mensual (Month-over-Month) de las ventas totales,
	y en que periodos especificos experimentamos las mayores aceleraciones o caidas?*/

WITH Ventas_Mensuales AS (
    SELECT 
        YEAR(Order_Date) AS A�o,
        MONTH(Order_Date) AS Mes,
        SUM(Order_Item_Total) AS Venta_Neta
    FROM Fact_Orders
    GROUP BY YEAR(Order_Date), MONTH(Order_Date)
),
Venta_Anterior AS (
    SELECT 
        A�o,
        Mes,
        Venta_Neta,
        LAG(Venta_Neta) OVER (ORDER BY A�o, Mes) AS Venta_Mes_Anterior
    FROM Ventas_Mensuales
)
SELECT 
    A�o,
    Mes,
    ROUND(Venta_Neta, 2) AS Ventas_Totales,
    ROUND(Venta_Mes_Anterior, 2) AS Ventas_Anteriores,
    ROUND(((Venta_Neta - Venta_Mes_Anterior) / (Venta_Mes_Anterior)) * 100, 2) AS Tasa_Crecimiento_MoM
FROM Venta_Anterior 

	/*CONCLUSION:
		Se evidencia el crecimiento MoM una trayectoria casi estable de manera operativa con diferencias 
		moderadas, un crecimiento del 13.3% en marzo 2015 lo cual fue el mayor de todos comparados con los
		siguientes a�os, y que en cada mes de marzo de cada a�o se evidencia un crecimiento mayor respecto
		al a�o correspondiente demostrando estacionalidad positiva para ese mes; sin embargo, hay una gran caida 
		a partir de noviembre 2017 con un -41.68%, y esta tendencia decreciente se mantiene hasta enero 2018
		lo que representa una se�al de alerta para la continuidad del negocio*/


-------------------------------------------------------------------------------------------------------------
--------------------------BLOQUE C: Inteligencia Predictiva y Flujo de Inventarios---------------------------
-------------------------------------------------------------------------------------------------------------

--11. El Running Total: El Monitor de Ventas Acumuladas
	/*�Cual es la evolucion de la venta acumulada mensual por cada Mercado a lo largo de los a�os,
	y en que mes cada mercado logra superar su primer millon de dolares en ventas netas?*/

WITH Ventas_Mensuales AS 
(
    SELECT DOL.Market,
        YEAR(FO.Order_Date) AS A�o,
        MONTH(FO.Order_Date) AS Mes,
        ROUND(SUM(FO.Order_Item_Total), 2) AS Venta_Mes
    FROM Fact_Orders FO
    INNER JOIN Dim_Order_Location DOL ON FO.Order_Location_Id = DOL.Order_Location_Id
    GROUP BY DOL.Market, YEAR(FO.Order_Date), MONTH(FO.Order_Date)
),
Acumulado AS
(
	SELECT Market,
		A�o,
		Mes,
		Venta_Mes,
		ROUND(SUM(Venta_Mes) OVER (PARTITION BY Market, a�o ORDER BY A�o , Mes
									ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS Venta_Acumulada_Anual
	FROM Ventas_Mensuales
)
SELECT Market,
		A�o,
		Mes,
		Venta_Mes,
		Venta_Acumulada_Anual,
		CASE 
			WHEN Venta_Acumulada_Anual >= 1000000 THEN 'ALCANZADO'
        ELSE 'EN PROCESO'
    END AS Verificacion
FROM Acumulado


	/*CONCLUSION:
		Se evidencia el mercado LATAM en el a�o 2015 y 2017 en su segundo mes (Febrero) respectivo supero el 
		millon en ventas, y de igual manera USCA en su segundo mes registrado (Mayo) 2016, demostrando ambos mercados 
		una rapidez en ventas, mientras que Africa es el mas lento, alcanzo su millon de ventas en Noviembre 2016;
		por lo que, los mercados "rapidos" se debe priorizar un stock disponible inmediato, y los "lentos" un stock
		disponible centrado */


--12. Promedio Movil: El Suavizado de la Demanda
	/*�Cual es el promedio movil de ventas de los ultimos 3 meses para cada categoria,
	y como ayuda esta metrica a reducir el 'Efecto Latigo' (Bullwhip Effect) en la planeacion de inventarios?*/

WITH Ventas_Categorias AS 
(
    SELECT DC.Category_Name AS Nombre_Categoria,
        YEAR(FO.Order_Date) AS A�o,
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
        A�o,
        Mes,
        Venta_Real,
        ROUND(AVG(Venta_Real) OVER (PARTITION BY Nombre_Categoria ORDER BY A�o, Mes 
									ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS Promedio_Movil_3M
    FROM Ventas_Categorias
)
SELECT 
    *,
    ROUND((Venta_Real - Promedio_Movil_3M) / (Promedio_Movil_3M) * 100, 2) AS Porcentaje_Desviacion
FROM Calculo_Movil


	/*CONCLUSION:
		Se evidencia el promedio movil como pronostico de la demanda donde se evalua cada mes su desviacion
		dependiendo de las ventas reales con su promedio junto a sus dos meses anteriores, pronosticando
		sus picos de demanda como sus caidas criticas, si enfrenta un pico (>30%) presenta un evento aislado
		lo que se debe tener cuidado en quedar con sobrestock para el mes siguiente, si enfrenta una caida 
		(<-30%) puede ser dos factores, bien hay un quiebre de stock o la categoria no se esta vendiendo;
		por lo que se recomienda basarse en el promedio movil, teniendo un stock ciclico y de seguridad*/

--13. Analisis de Contribucion: Pareto Acumulado
	/*�Que porcentaje del beneficio total acumulado representa cada categoria de producto al ordenarlas de mayor a menor,
	y cuales son las categorias 'Clase A' que conforman el primer 80% de la ganancia?*/

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
FROM Pareto_Calculo

	/*CONCLUSION:
		Se evidencia las 7 primeras categorias (vitales) generan el 77% de la ganancia total, eso quiere decir que el
		14% del total de las categorias sostienen casi el 80% de la rentabilidad lo que se debe asegurar un stock
		de seguridad mas amplio, los siguientes 10 categorias (importantes) representan el otro 18% de la ganancia
		lo que se debe hacer un seguimiento para controlar de forma periodica, y los demas articulos (triviales) 
		aportan el 5% final, lo que se recomienda aplicar politicas de stock minimo , con el fin de priorizar a 
		los de categoria A*/


--14. Auditoria de Brecha: Servicio por Pais y Metodo de Pago
	/*�Cual es la ineficiencia logistica (brecha en dias) de cada ciudad respecto al estandar de su propio pais,
	y que metodos de pago estan correlacionados con los mayores retrasos en el despacho?*/

WITH Metricas AS 
(
    SELECT DOL.Order_Country AS Pais,
        DOL.Order_City AS Ciudad,
        DS.Type AS Metodo_Pago,
        ROUND(AVG(CAST(FO.Days_for_shipping_real AS FLOAT)),2) AS Dias_Despacho,
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
    ROUND(Promedio_Nacional,2) AS Estandar_Pais,
    ROUND(Dias_Despacho - Promedio_Nacional,2) AS Brecha_Dias
FROM Metricas
WHERE (Dias_Despacho - Promedio_Nacional) > 0 
ORDER BY Brecha_Dias DESC

	/*CONCLUSION:
		Se evidencia que el pais Libano teniendo dos metodos de pago CASH y DEBIT tiene la mayor brecha de dias
		y es posible que el problema no sea el pago, sino el centro de distribucion en Beirut, por lo que se debe 
		verificar la ruta de transporte; y de la misma forma con los siguientes paises y sus respectivas ciudades
		plantear un proceso eficiente para evitar mayores retrasos posibles, siguiendo los procesos de aquellos 
		paises que no tienen retrasos en sus pedidos*/

--15. Proyeccion de Inventario: Cierre de Trimestre
	/*Cual es la carga de trabajo acumulada para el trimestre movil por cada mercado,
	y en que periodos del a�o la infraestructura logistica se ve sometida a la mayor presion de despacho?*/

WITH Carga_Historica AS 
(
    SELECT DOL.Market,
        YEAR(FO.Order_Date) AS A�o,
        MONTH(FO.Order_Date) AS Mes,
        SUM(FO.Order_Item_Quantity) AS Unidades_Mes
    FROM Fact_Orders FO
    INNER JOIN Dim_Order_Location DOL ON FO.Order_Location_Id = DOL.Order_Location_Id
    GROUP BY DOL.Market, YEAR(FO.Order_Date), MONTH(FO.Order_Date)
)
SELECT 
    Market,
    A�o,
    Mes,
    Unidades_Mes AS Carga_Actual,
    SUM(Unidades_Mes) OVER (PARTITION BY Market ORDER BY A�o, Mes 
							ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS Carga_Proyectada_Trimestre
FROM Carga_Historica
ORDER BY Market

	/*CONCLUSION:
		Se evidencia la carga proyectada trimestral en sus meses respectivos de cada mercado, donde mercados como
		Europe en julio 2015 tuvo mayor presion de despacho, en LATAM en marzo 2015 y Pacific Asia en noviembre 2015
		por lo que se exige una mayor planificacion del personal comparada a mercados como Africa*/