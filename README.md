# Trabajo1-FUNDAMENTOSDEDATASCIENCE


Estudiantes: 
- u202311021 Saavedra Cervera Sergio Andres
- u          David Angelo Zavala Arteaga
- u202014659 Martin Alonso Del Aguila Arevalo




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


- ¿Qué problemas o necesidades responde este análisis?

Este análisis responde problemas o necesidades como:
- Cuando se realizan más reservas.
- Que tipo de hotel recibe más clientes.
- Cuáles son los patrones de ocupación, etc.

### **2. CONJUNTO DE DATOS(DATASET)**

#### Descripción del dataset

```r



df <- read.csv("hotel_bookings.csv") # asignando al data frame el contenido del archivo csv

colnames(df) # Ver el nombre de las columnas
sapply(df) # Ver el tipo de cada variable

```

```md
| Variable | Tipo | Descripción |
|---|---|---|
| hotel | character | Tipo de hotel reservado |
| is_canceled | integer | Indica si la reserva fue cancelada (1 = sí, 0 = no) |
| lead_time | integer | Número de días entre la reserva y la llegada |
| arrival_date_year | integer | Año de llegada |
| arrival_date_month | character | Mes de llegada |
| arrival_date_week_number | integer | Número de semana del año de llegada |
| arrival_date_day_of_month | integer | Día del mes de llegada |
| stays_in_weekend_nights | integer | Número de noches de fin de semana |
| stays_in_week_nights | integer | Número de noches entre semana |
| adults | integer | Número de adultos |
| children | integer | Número de niños |
| babies | integer | Número de bebés |
| meal | character | Tipo de comida reservada |
| country | character | País de procedencia del cliente |
| market_segment | character | Segmento de mercado |
| distribution_channel | character | Canal de distribución de la reserva |
| is_repeated_guest | integer | Indica si el cliente es recurrente |
| previous_cancellations | integer | Número de cancelaciones previas |
| previous_bookings_not_canceled | integer | Número de reservas previas no canceladas |
| reserved_room_type | character | Tipo de habitación reservada |
| assigned_room_type | character | Tipo de habitación asignada |
| booking_changes | integer | Número de cambios realizados en la reserva |
| deposit_type | character | Tipo de depósito realizado |
| agent | character | Código del agente de reservas |
| company | character | Código de la empresa asociada |
| days_in_waiting_list | integer | Días en lista de espera |
| customer_type | character | Tipo de cliente |
| adr | numeric | Tarifa diaria promedio |
| required_car_parking_spaces | integer | Espacios de estacionamiento requeridos |
| total_of_special_requests | integer | Número total de solicitudes especiales |
| reservation_status | character | Estado final de la reserva |
| reservation_status_date | character | Fecha del estado final de la reserva |
```






### **3. ANÁLISIS EXPLORATORIO DE DATOS(EDA)**

#### Cargar Datos
```r
library(readr)

df <- read_csv("hotel_bookings.csv") # Versiones modernas de RStudio tienen un comando para leer csv llamado "read_csv" lo cual evita que los datos tipo string no se convieran en tipo factores
head(df) # Observar las 6 primeras filas de la tabla
colnames(df) # Ver el nombre de las columnas del data frame
sapply(df,class) # Ver el tipo de cada variable
str(df) # Ver la estructura del dataset
```
# Hotel Bookings Dataset

| hotel | is_canceled | lead_time | arrival_date_year | arrival_date_month | stays_in_weekend_nights | stays_in_week_nights | adults | children | babies | meal | country | market_segment | distribution_channel | is_repeated_guest | previous_cancellations | previous_bookings_not_canceled | reserved_room_type | assigned_room_type | booking_changes | deposit_type | agent | company | days_in_waiting_list | customer_type | adr | required_car_parking_spaces | total_of_special_requests | reservation_status | reservation_status_date |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Resort Hotel | 0 | 342 | 2015 | July | 0 | 0 | 2 | 0 | 0 | BB | PRT | Direct | Direct | 0 | 0 | 0 | C | C | 3 | No Deposit | NULL | NULL | 0 | Transient | 0.0 | 0 | 0 | Check-Out | 2015-07-01 |
| Resort Hotel | 0 | 737 | 2015 | July | 0 | 0 | 2 | 0 | 0 | BB | PRT | Direct | Direct | 0 | 0 | 0 | C | C | 4 | No Deposit | NULL | NULL | 0 | Transient | 0.0 | 0 | 0 | Check-Out | 2015-07-01 |
| Resort Hotel | 0 | 7 | 2015 | July | 0 | 1 | 1 | 0 | 0 | BB | GBR | Direct | Direct | 0 | 0 | 0 | A | C | 0 | No Deposit | NULL | NULL | 0 | Transient | 75.0 | 0 | 0 | Check-Out | 2015-07-02 |
| Resort Hotel | 0 | 13 | 2015 | July | 0 | 1 | 1 | 0 | 0 | BB | GBR | Corporate | Corporate | 0 | 0 | 0 | A | A | 0 | No Deposit | 304 | NULL | 0 | Transient | 75.0 | 0 | 0 | Check-Out | 2015-07-02 |
| Resort Hotel | 0 | 14 | 2015 | July | 0 | 2 | 2 | 0 | 0 | BB | GBR | Online TA | TA/TO | 0 | 0 | 0 | A | A | 0 | No Deposit | 240 | NULL | 0 | Transient | 98.0 | 0 | 1 | Check-Out | 2015-07-03 |


#### Inspeccionar datos
```r
#Nombre de columnas

 [1] "hotel"                          "is_canceled"                   
 [3] "lead_time"                      "arrival_date_year"             
 [5] "arrival_date_month"             "arrival_date_week_number"      
 [7] "arrival_date_day_of_month"      "stays_in_weekend_nights"       
 [9] "stays_in_week_nights"           "adults"                        
[11] "children"                       "babies"                        
[13] "meal"                           "country"                       
[15] "market_segment"                 "distribution_channel"          
[17] "is_repeated_guest"              "previous_cancellations"        
[19] "previous_bookings_not_canceled" "reserved_room_type"            
[21] "assigned_room_type"             "booking_changes"               
[23] "deposit_type"                   "agent"                         
[25] "company"                        "days_in_waiting_list"          
[27] "customer_type"                  "adr"                           
[29] "required_car_parking_spaces"    "total_of_special_requests"     
[31] "reservation_status"             "reservation_status_date"       


#Tipo de cada variable

                         hotel                    is_canceled                      lead_time 
                   "character"                      "numeric"                      "numeric" 
             arrival_date_year             arrival_date_month       arrival_date_week_number 
                     "numeric"                    "character"                      "numeric" 
     arrival_date_day_of_month        stays_in_weekend_nights           stays_in_week_nights 
                     "numeric"                      "numeric"                      "numeric" 
                        adults                       children                         babies 
                     "numeric"                      "numeric"                      "numeric" 
                          meal                        country                 market_segment 
                   "character"                    "character"                    "character" 
          distribution_channel              is_repeated_guest         previous_cancellations 
                   "character"                      "numeric"                      "numeric" 
previous_bookings_not_canceled             reserved_room_type             assigned_room_type 
                     "numeric"                    "character"                    "character" 
               booking_changes                   deposit_type                          agent 
                     "numeric"                    "character"                    "character" 
                       company           days_in_waiting_list                  customer_type 
                   "character"                      "numeric"                    "character" 
                           adr    required_car_parking_spaces      total_of_special_requests 
                     "numeric"                      "numeric"                      "numeric" 
            reservation_status        reservation_status_date 
                   "character"                         "Date" 

#Estructura del dataset

tibble [119,390 × 35] (S3: tbl_df/tbl/data.frame)
 $ hotel                         : Factor w/ 2 levels "City Hotel","Resort Hotel": 2 2 2 2 2 2 2 2 2 2 ...
 $ is_canceled                   : num [1:119390] 0 0 0 0 0 0 0 0 1 1 ...
 $ lead_time                     : num [1:119390] 342 737 7 13 14 14 0 9 85 75 ...
 $ arrival_date_year             : num [1:119390] 2015 2015 2015 2015 2015 ...
 $ arrival_date_month            : chr [1:119390] "July" "July" "July" "July" ...
 $ arrival_date_week_number      : num [1:119390] 27 27 27 27 27 27 27 27 27 27 ...
 $ arrival_date_day_of_month     : num [1:119390] 1 1 1 1 1 1 1 1 1 1 ...
 $ stays_in_weekend_nights       : num [1:119390] 0 0 0 0 0 0 0 0 0 0 ...
 $ stays_in_week_nights          : num [1:119390] 0 0 1 1 2 2 2 2 3 3 ...
 $ adults                        : num [1:119390] 2 2 1 1 2 2 2 2 2 2 ...
 $ children                      : num [1:119390] 0 0 0 0 0 0 0 0 0 0 ...
 $ babies                        : num [1:119390] 0 0 0 0 0 0 0 0 0 0 ...
 $ meal                          : Factor w/ 5 levels "BB","FB","HB",..: 1 1 1 1 1 1 1 2 1 3 ...
 $ country                       : Factor w/ 178 levels "ABW","AGO","AIA",..: 137 137 60 60 60 60 137 137 137 137 ...
 $ market_segment                : Factor w/ 8 levels "Aviation","Complementary",..: 4 4 4 3 7 7 4 4 7 6 ...
 $ distribution_channel          : Factor w/ 5 levels "Corporate","Direct",..: 2 2 2 1 4 4 2 2 4 4 ...
 $ is_repeated_guest             : num [1:119390] 0 0 0 0 0 0 0 0 0 0 ...
 $ previous_cancellations        : num [1:119390] 0 0 0 0 0 0 0 0 0 0 ...
 $ previous_bookings_not_canceled: num [1:119390] 0 0 0 0 0 0 0 0 0 0 ...
 $ reserved_room_type            : Factor w/ 10 levels "A","B","C","D",..: 3 3 1 1 1 1 3 3 1 4 ...
 $ assigned_room_type            : Factor w/ 12 levels "A","B","C","D",..: 3 3 3 1 1 1 3 3 1 4 ...
 $ booking_changes               : num [1:119390] 3 4 0 0 0 0 0 0 0 0 ...
 $ deposit_type                  : chr [1:119390] "No Deposit" "No Deposit" "No Deposit" "No Deposit" ...
 $ agent                         : Factor w/ 334 levels "1","10","103",..: 334 334 334 157 103 103 334 156 103 40 ...
 $ company                       : Factor w/ 353 levels "10","100","101",..: 353 353 353 353 353 353 353 353 353 353 ...
 $ days_in_waiting_list          : num [1:119390] 0 0 0 0 0 0 0 0 0 0 ...
 $ customer_type                 : Factor w/ 4 levels "Contract","Group",..: 3 3 3 3 3 3 3 3 3 3 ...
 $ adr                           : num [1:119390] 0 0 75 75 98 ...
 $ required_car_parking_spaces   : num [1:119390] 0 0 0 0 0 0 0 0 0 0 ...
 $ total_of_special_requests     : num [1:119390] 0 0 0 0 1 1 0 1 1 0 ...
 $ reservation_status            : Factor w/ 3 levels "Canceled","Check-Out",..: 2 2 2 2 2 2 2 2 1 1 ...
 $ reservation_status_date       : Date[1:119390], format: NA NA NA ...
 $ reservation_status_year       : chr [1:119390] "2015" "2015" "2015" "2015" ...
 $ reservation_status_month      : chr [1:119390] "07" "07" "07" "07" ...
 $ reservation_status_dayofmonth : chr [1:119390] "01" "01" "02" "02" ...




```

Respecto a la información que nos brinda este dataset, ninguna variable puede tener un comportamiento de "dato duplicado"; debido a que, cada valor a pesar de que se repita varias veces no representa un dato único al compararlo con otros valores.


```r
#Buscar valores duplicados


duplicated(df)

sum(duplicated(df))

[1] 31994

df[duplicated(df),]

# A tibble: 31,994 × 35
   hotel        is_canceled lead_time arrival_date_year arrival_date_month arrival_date_week_number
   <fct>              <dbl>     <dbl>             <dbl> <chr>                                 <dbl>
 1 Resort Hotel           0        14              2015 July                                     27
 2 Resort Hotel           0        72              2015 July                                     27
 3 Resort Hotel           0        70              2015 July                                     27
 4 Resort Hotel           1         5              2015 July                                     28
 5 Resort Hotel           0         0              2015 July                                     28
 6 Resort Hotel           1         1              2015 July                                     28
 7 Resort Hotel           0        91              2015 July                                     28
 8 Resort Hotel           0        30              2015 July                                     28
 9 Resort Hotel           0        98              2015 July                                     29
10 Resort Hotel           0        40              2015 July                                     29
# ℹ 31,984 more rows



```


Sin embargo, para optimizar el uso de memoria que hace el dataset, se cambiará todos las variables tipo "caracter" a "factor" esto permitirá a que los datos puedan ser representados en gráficos estadísticos.


```r

# Cambiando tipos de algunas variables


df$reservation_status_date<- as.Date(
  df$reservation_status_date,
  format = "%Y-%m-%d"
) # Primero convertimos en tipo Date a los valores que están en "reservation_status_date"

df$reservation_status_date<- mdy(df$reservation_status_date) # Luego lo pasamos a un formato más adecuado de mes,día,año
df$country <- as.factor(df$country)
df$meal <- as.factor(df$meal)
df$market_segment <- as.factor(df$market_segment)
df$hotel <- as.factor(df$hotel)
df$country <- as.factor(df$country)
df$reserved_room_type <- as.factor(df$reserved_room_type)
df$assigned_room_type <- as.factor(df$assigned_room_type)
df$agent <- as.factor(df$agent)
df$company <- as.factor(df$company)
df$customer_type <- as.factor(df$customer_type)
df$reservation_status <- as.factor(df$reservation_status)
df$distribution_channel <- as.factor(df$distribution_channel)
df$arrival_date_month <- as.factor(df$arrival_date_month)

```

### **4. CONCLUSIONES**


**¿Qué patrones o tendencias se observaron?**

Se encontraron diversas tendencias y patrones como:

- La mayoría de personas que iban a los hoteles eran adultos.
- La mayoría de reservas que se hicieorn NO fueron canceladas.
- Las temporadas con mayores reservas fueron durante julio y agosto.


**¿Qué recomendaciones se pueden extraer a partir de los hallazgos?**

Si bien el número de reservas no canceladas predomina sobre el número de reservas que si fueron canceladas, eso no significa que el número de este sea bajo. Por lo tanto, es importante tomar en cuenta las causas que provocaron que los clientes ya no quieran ir al hotel. También, cabe recalcar que de ser posible, ambientar los hoteles para familias para aumentar el número de niños que van a los hoteles.
