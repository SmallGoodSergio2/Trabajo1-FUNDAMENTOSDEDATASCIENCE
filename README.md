# Trabajo1-FUNDAMENTOSDEDATASCIENCE


Estudiantes: 
- u202311021 Saavedra Cervera Sergio Andres
- u          David Angelo Zavala Arteaga
- u          Martin Alonso Del Aguila Arevalo




## **Contenidos**




### **1. CASO DE ESTUDIO**

#### **Origen de los datos**

Los datos que usaremos provienen de una base de datos llamada [Hotel booking demand dataset](https://www.sciencedirect.com/science/article/pii/S2352340918315191) que contiene información relacionada a reservas de hoteles donde nos dan datos cómo la fecha de reserva, la duración de estadía, la cantidad de espacio de estacionamientos posibles, entre otros datos. 

Estos datos fueron escritos por Nuno Antonio, Ana Almeida y Luis Nunes en Febrero del 2019 y recolectaron estos datos de base de datos SQL de hoteles respecto al Sistema de Manejo de Propiedades. (Property Management System).

Para este trabajo se usará una versión modificada de esta base de datos donde se incorporó ruido a los datos lo que provoca que haya datos faltantes  y atípicos.


#### **Casos de uso aplicable**

- ¿Quién podría estar interesado en este análisis?

   Los usuarios que pueden estar interesados en este análisis son dos:
  - Los gerentes de hoteles, los cuales podrán observar el número de clientes que lleguen a tener estos a comparación de los suyos.
  - Usuarios que estén creando una página web que promocione hoteles, los cuales podrán determinar que hoteles son los que tienen más clientes y; a partir de eso, promocionarlos en la página para que más familias vayan ahí. 


- ¿Qué problemas o necesidades responde este análisis



### **2. CONJUNTO DE DATOS(DATASET)**

#### Descripción del dataset

```r

print("hola")

df <- read.csv("hotel_bookings.csv")
head(df)
View(df)

```


# Hotel Bookings Dataset

| hotel | is_canceled | lead_time | arrival_date_year | arrival_date_month | stays_in_weekend_nights | stays_in_week_nights | adults | children | babies | meal | country | market_segment | distribution_channel | is_repeated_guest | previous_cancellations | previous_bookings_not_canceled | reserved_room_type | assigned_room_type | booking_changes | deposit_type | agent | company | days_in_waiting_list | customer_type | adr | required_car_parking_spaces | total_of_special_requests | reservation_status | reservation_status_date |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Resort Hotel | 0 | 342 | 2015 | July | 0 | 0 | 2 | 0 | 0 | BB | PRT | Direct | Direct | 0 | 0 | 0 | C | C | 3 | No Deposit | NULL | NULL | 0 | Transient | 0.0 | 0 | 0 | Check-Out | 2015-07-01 |
| Resort Hotel | 0 | 737 | 2015 | July | 0 | 0 | 2 | 0 | 0 | BB | PRT | Direct | Direct | 0 | 0 | 0 | C | C | 4 | No Deposit | NULL | NULL | 0 | Transient | 0.0 | 0 | 0 | Check-Out | 2015-07-01 |
| Resort Hotel | 0 | 7 | 2015 | July | 0 | 1 | 1 | 0 | 0 | BB | GBR | Direct | Direct | 0 | 0 | 0 | A | C | 0 | No Deposit | NULL | NULL | 0 | Transient | 75.0 | 0 | 0 | Check-Out | 2015-07-02 |
| Resort Hotel | 0 | 13 | 2015 | July | 0 | 1 | 1 | 0 | 0 | BB | GBR | Corporate | Corporate | 0 | 0 | 0 | A | A | 0 | No Deposit | 304 | NULL | 0 | Transient | 75.0 | 0 | 0 | Check-Out | 2015-07-02 |
| Resort Hotel | 0 | 14 | 2015 | July | 0 | 2 | 2 | 0 | 0 | BB | GBR | Online TA | TA/TO | 0 | 0 | 0 | A | A | 0 | No Deposit | 240 | NULL | 0 | Transient | 98.0 | 0 | 1 | Check-Out | 2015-07-03 |




#### Nombre de columnas:

1. hotel
2. is_canceled
3. lead_time
4. arrival_date_year
5. arrival_date_month
6. arrival_date_week_number
7. arrival_date_day_of_month
8. stays_in_weekend_nights
9. stays_in_week_nights
10. adults
11. children
12. babies
13. meal
14. country
15. market_segment
16. distribution_channel
17. is_repeated_guest
18. previous_cancellations
19. previous_bookings_not_canceled
20. reserved_room_type
21. assigned_room_type
22. booking_changes
23. deposit_type
24. agent
25. company
26. days_in_waiting_list
27. customer_type
28. adr
29. required_car_parking_spaces
30. total_of_special_requests
31. reservation_status
32. reservation_status_date

#### Tipo de datos de cada variable:

**hotel**

'character'

**is_canceled**

'integer'

**lead_time**

'integer'

**arrival_date_year**

'integer'

**arrival_date_month**

'character'

**arrival_date_week_number**

'integer'

**arrival_date_day_of_month**

'integer'

**stays_in_weekend_nights**

'integer'

**stays_in_week_nights**

'integer'

**adults**

'integer'

**children**

'integer'

**babies**

'integer'

**meal**

'character'

**country**

'character'

**market_segment**

'character'

**distribution_channel**

'character'

**is_repeated_guest**

'integer'

**previous_cancellations**

'integer'

**previous_bookings_not_canceled**

'integer'

**reserved_room_type**

'character'

**assigned_room_type**

'character'

**booking_changes**

'integer'

**deposit_type**

'character'

**agent**

'character'

**company**

'character'

**days_in_waiting_list**

'integer'

**customer_type**

'character'

**adr**

'numeric'

**required_car_parking_spaces**

'integer'

**total_of_special_requests**

'integer'

**reservation_status**

'character'

**reservation_status_date**

'character'










