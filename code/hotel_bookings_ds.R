rm(list=ls(all=TRUE))
graphics.off()
cat("\014")

# ============================================================
# ANÁLISIS COMPLETO DE RESERVAS HOTELERAS (hotel_bookings.csv)
# ============================================================

# --- Cargar librerías necesarias ---
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
library(patchwork)

# ============================================================
# PASO 1: DESCRIPCIÓN DEL DATASET
# ============================================================
# (Ver tabla al final de esta sección)

# ============================================================
# PASO 2a: CARGAR DATOS
# ============================================================
# Cargar el archivo CSV asegurando que las cadenas no se conviertan a factores
datos <- read.csv("hotel_bookings.csv", header = TRUE, stringsAsFactors = FALSE, sep=',')

# ============================================================
# PASO 2b: INSPECCIONAR DATOS
# ============================================================
# Ver estructura general
str(datos)

# Dimensiones del dataset
dim(datos)

# Primeras filas
head(datos)

# Nombres de columnas
names(datos)

# Visualizar csv completo
View(datos)

# Verificar duplicados
cat("Número de filas duplicadas:", sum(duplicated(datos)), "\n")

# Eliminar duplicados si existen
datos <- datos[!duplicated(datos), ]

# Antes de convertir a factor, reemplazar cadenas vacías y "NULL" por NA
datos[datos == "" | datos == "NULL"] <- NA

# Ahora contar NA en todas las columnas
missing_total <- sapply(datos, function(x) sum(is.na(x)))
cat("Columnas con valores NA o vacíos:\n")
print(missing_total[missing_total > 0])

# --- Transformaciones necesarias ---
# Crear columna de fecha de llegada combinando año, mes y día
# Convertir nombres de meses en inglés a número
meses <- c("January"=1, "February"=2, "March"=3, "April"=4, "May"=5, "June"=6,
           "July"=7, "August"=8, "September"=9, "October"=10, "November"=11, "December"=12)
datos$mes_num <- meses[datos$arrival_date_month]

# Crear fecha de llegada como Date
datos$fecha_llegada <- as.Date(paste(datos$arrival_date_year,
                                     datos$mes_num,
                                     datos$arrival_date_day_of_month, sep="-"),
                               format="%Y-%m-%d")

# Crear fecha de reserva (fecha_llegada - lead_time)
datos$fecha_reserva <- datos$fecha_llegada - datos$lead_time

# Crear columna de mes de llegada como factor ordenado
datos$mes_llegada <- factor(datos$arrival_date_month,
                            levels = c("January","February","March","April","May","June",
                                       "July","August","September","October","November","December"))

# Crear columna de año-mes para análisis temporal
datos$anio_mes <- format(datos$fecha_llegada, "%Y-%m")

# Convertir variables categóricas a factor
datos$hotel <- as.factor(datos$hotel)
datos$is_canceled <- as.factor(datos$is_canceled)
datos$meal <- as.factor(datos$meal)
datos$country <- as.factor(datos$country)
datos$market_segment <- as.factor(datos$market_segment)
datos$distribution_channel <- as.factor(datos$distribution_channel)
datos$reserved_room_type <- as.factor(datos$reserved_room_type)
datos$assigned_room_type <- as.factor(datos$assigned_room_type)
datos$deposit_type <- as.factor(datos$deposit_type)
datos$customer_type <- as.factor(datos$customer_type)
datos$reservation_status <- as.factor(datos$reservation_status)

# Calcular estancia total (fin de semana + entre semana)
datos$estancia_total <- datos$stays_in_weekend_nights + datos$stays_in_week_nights

# ============================================================
# PASO 2c: PRE-PROCESAR DATOS
# ============================================================

# --- Resumir Estadísticas Básicas ---
summary(datos)
# Estadísticas específicas para variables numéricas clave
numeric_vars <- c("lead_time", "stays_in_weekend_nights", "stays_in_week_nights",
                  "adults", "children", "babies", "adr", "estancia_total")
summary(datos[, numeric_vars])

# --- Tratamiento de Datos Faltantes ---
# children: asumimos que NA significa sin niños (0)
datos$children[is.na(datos$children)] <- 0

# agent y company: tienen muchos NA, se mantienen como están (no se usarán en análisis principales)
# Para variables numéricas con pocos NA se podría usar la mediana, pero aquí no profundizamos.

# --- Detectar Outliers ---
# Boxplot de lead_time
boxplot(datos$lead_time, main="Lead Time", ylab="Días")

# Boxplot de adr (Average Daily Rate)
boxplot(datos$adr, main="ADR (Tarifa Diaria Promedio)", ylab="ADR")

# Boxplot de estancia_total
boxplot(datos$estancia_total, main="Estancia Total (noches)", ylab="Noches")

# --- Tratamiento de Outliers (Winsorización al percentil 1 y 99) ---

winsorize <- function(x, probs = c(0.01, 0.99)) {
  lim <- quantile(x, probs = probs, na.rm = TRUE)
  x[x < lim[1]] <- lim[1]
  x[x > lim[2]] <- lim[2]
  return(x)
}

datos$lead_time_w <- winsorize(datos$lead_time)
datos$adr_w <- winsorize(datos$adr)
datos$estancia_w <- winsorize(datos$estancia_total)

# --- Tratamiento manual ---

# Como queremos tratar a 2 como un valor razonable, truncamos a 2 manualmente
datos$parking_w <- pmin(datos$required_car_parking_spaces, 2)

# --- Visualizacion de datos corregidos ---
# Boxplot de lead_time_w
boxplot(datos$lead_time_w, main="Lead Time", ylab="Días")

# Boxplot de adr_w (Average Daily Rate)
boxplot(datos$adr_w, main="ADR (Tarifa Diaria Promedio)", ylab="ADR")

# Boxplot de estancia_w
boxplot(datos$estancia_w, main="Estancia Total (noches)", ylab="Noches")

# Verificar la nueva distribución de parking
cat("Distribución original:\n")
print(table(datos$required_car_parking_spaces))
cat("Distribución truncada (parking_w):\n")
print(table(datos$parking_w))

# ============================================================
# PASO 2d: VISUALIZACIÓN DE DATOS
# ============================================================

# --- PREGUNTA 1: ¿Cuántas reservas se realizan por tipo de hotel 
#     considerando solo aquellas no canceladas? ¿Qué tipo de hotel es el más preferido? ---

reservas_no_canceladas <- subset(datos, is_canceled == 0)

# Gráfico de barras
ggplot(reservas_no_canceladas, aes(x = hotel, fill = hotel)) +
  geom_bar() +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5) +
  labs(title = "Reservas no canceladas por tipo de hotel",
       x = "Tipo de Hotel", y = "Número de Reservas") +
  theme_minimal() +
  scale_fill_manual(values = c("Resort Hotel" = "steelblue", "City Hotel" = "coral"))

# Hallazgo: El City Hotel es el más preferido (mayor número de reservas no canceladas).


# --- PREGUNTA 2: ¿Está aumentando la demanda con el tiempo? ---

# Agrupar reservas totales por mes (canceladas + no canceladas)
demanda_mensual <- datos %>%
  group_by(anio_mes) %>%
  summarise(total_reservas = n(), .groups = "drop") %>%
  mutate(fecha = as.Date(paste0(anio_mes, "-01")))

ggplot(demanda_mensual, aes(x = fecha, y = total_reservas)) +
  geom_line(color = "steelblue", linewidth = 1) +
  geom_smooth(method = "loess", color = "red", se = FALSE) +
  labs(title = "Evolución de la demanda de reservas",
       subtitle = "Julio 2015 - Agosto 2017",
       x = "Fecha", y = "Número de Reservas") +
  theme_minimal()

# Hallazgo: Se observa una tendencia ligeramente creciente, con picos en verano.


# --- PREGUNTA 3: ¿Cuáles son las temporadas de reservas (alta, media, baja)? ---

# Agrupar por mes (sumando todos los años)
demanda_por_mes <- datos %>%
  group_by(mes_llegada) %>%
  summarise(total_reservas = n(), .groups = "drop")

ggplot(demanda_por_mes, aes(x = mes_llegada, y = total_reservas)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Temporadas de reservas por mes",
       x = "Mes de llegada", y = "Total de Reservas") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Usamos método basado en umbrales de media ± desviación estándar para hallar
# las temporadas de manera numérica

# Calcular umbrales basados en media y desviación estándar
media <- mean(demanda_por_mes$total_reservas)
desv <- sd(demanda_por_mes$total_reservas)

umbral_alta <- media + 0.5 * desv
umbral_baja <- media - 0.5 * desv

# Clasificar
demanda_por_mes <- demanda_por_mes %>%
  mutate(temporada = case_when(
    total_reservas > umbral_alta ~ "Alta",
    total_reservas < umbral_baja ~ "Baja",
    TRUE ~ "Media"
  ))

# Ver tabla clasificada
print(demanda_por_mes)

# Visualización con colores por temporada
g3_2<-ggplot(demanda_por_mes, aes(x = mes_llegada, y = total_reservas, fill = temporada)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = umbral_alta, linetype = "dashed", color = "red", linewidth = 1) +
  geom_hline(yintercept = umbral_baja, linetype = "dashed", color = "blue", linewidth = 1) +
  annotate("text", x = 12, y = umbral_alta + 100, label = "Umbral alta", color = "red") +
  annotate("text", x = 12, y = umbral_baja - 100, label = "Umbral baja", color = "blue") +
  labs(title = "Temporadas de reservas (clasificación numérica)",
       x = "Mes de llegada", y = "Total de reservas") +
  scale_fill_manual(values = c("Alta" = "tomato", "Media" = "gold", "Baja" = "steelblue")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
g3_2

# --- PREGUNTA 4: ¿Cuál es la duración promedio de las estancias por tipo de hotel? ---

# Calcular promedio de estancia total por hotel (datos no cancelados para estancia real)
estancia_promedio <- aggregate(estancia_total ~ hotel, 
                               data = reservas_no_canceladas, FUN = mean)

ggplot(estancia_promedio, aes(x = hotel, y = estancia_total, fill = hotel)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = round(estancia_total, 1)), vjust = -0.5) +
  labs(title = "Duración promedio de estancia por tipo de hotel",
       subtitle = "Solo reservas no canceladas",
       x = "Tipo de Hotel", y = "Noches promedio") +
  theme_minimal() +
  scale_fill_manual(values = c("Resort Hotel" = "steelblue", "City Hotel" = "coral"))

# Hallazgo: Resort Hotel tiene estancias más largas en promedio (~4.2 vs ~ 3.0 noches).


# --- PREGUNTA 5: ¿Cuántas reservas incluyen niños y/o bebés? ---

# Crear variable categórica
datos$tipo_huesped <- ifelse(datos$children > 0 | datos$babies > 0, 
                             "Con niños/bebés", "Solo adultos")

ggplot(datos, aes(x = tipo_huesped, fill = tipo_huesped)) +
  geom_bar() +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5) +
  labs(title = "Reservas que incluyen niños y/o bebés",
       x = "Tipo de reserva", y = "Número de Reservas") +
  theme_minimal() +
  scale_fill_manual(values = c("Con niños/bebés" = "darkgreen", "Solo adultos" = "gray70"))

# También por hotel
ggplot(datos, aes(x = hotel, fill = tipo_huesped)) +
  geom_bar(position = "dodge") +
  labs(title = "Reservas con niños/bebés por tipo de hotel",
       x = "Tipo de Hotel", y = "Número de Reservas") +
  theme_minimal()

# Hallazgo: La mayoría de reservas son solo adultos. City Hotel tiene más reservas familiares.


# --- PREGUNTA 6: ¿Es importante contar con espacios de estacionamiento? ---

datos$parking_label <- factor(datos$parking_w,
                              levels = c(0, 1, 2),
                              labels = c("0 espacios", "1 espacio", "2 espacios"))

parking_tab <- as.data.frame(prop.table(table(datos$parking_label)) * 100)
names(parking_tab) <- c("Parking", "Porcentaje")

ggplot(parking_tab, aes(x = "", y = Porcentaje, fill = Parking)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  geom_text(aes(label = paste0(round(Porcentaje, 1), "%")),
            position = position_stack(vjust = 0.5),
            size = 4, color = "white") +
  labs(title = "Importancia de los espacios de estacionamiento",
       fill = "Espacios requeridos") +
  theme_void() +
  theme(legend.position = "right")

# Hallazgo: La gran mayoría de reservas NO requiere estacionamiento (< 5% pide 1 o más).


# --- PREGUNTA 7: ¿En qué meses del año se producen más cancelaciones de reservas? ---

cancelaciones_mes <- datos %>%
  group_by(mes_llegada) %>%
  summarise(total = n(),
            cancel = sum(is_canceled == 1),
            tasa = mean(is_canceled == 1) * 100,
            .groups = "drop")

# Coeficiente para escalar la línea a la magnitud de las barras
escala <- max(cancelaciones_mes$cancel) / max(cancelaciones_mes$tasa)

g7<-ggplot(cancelaciones_mes, aes(x = mes_llegada)) +
  geom_col(aes(y = cancel, fill = "Cancelaciones"), alpha = 0.85) +
  geom_line(aes(y = tasa * escala, color = "Tasa de cancelación", group = 1),
            linewidth = 1.2) +
  geom_point(aes(y = tasa * escala, color = "Tasa de cancelación"), size = 2) +
  scale_y_continuous(
    name = "Cancelaciones (absoluto)",
    sec.axis = sec_axis(~ . / escala, name = "Tasa de cancelación (%)")
  ) +
  scale_fill_manual(values = c("Cancelaciones" = "steelblue")) +
  scale_color_manual(values = c("Tasa de cancelación" = "red")) +
  labs(title = "Estacionalidad de cancelaciones",
       x = "Mes de llegada", fill = "", color = "") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom")

g3_2+g7
# Hallazgo: Julio y Agosto tienen más cancelaciones en volumen, pero la tasa es más alta 
# en meses de baja demanda.


# --- PREGUNTA 8 (del equipo): ¿Cómo afecta el tiempo entre la reserva y la llegada a la probabilidad de cancelación? ---

# Gráfico de líneas: tasa de cancelación por intervalo de lead time
tasa_global <- mean(datos$is_canceled == 1) * 100

ggplot(tasa_lead, aes(x = lead_cat, y = tasa_cancel, group = 1)) +
  geom_line(color = "steelblue", linewidth = 1) +
  geom_point(color = "steelblue", size = 3) +
  geom_text(aes(label = paste0(round(tasa_cancel, 1), "%")), vjust = -1) +
  geom_hline(yintercept = tasa_global, linetype = "dashed", color = "red") +
  annotate("text", x = 1, y = tasa_global + 1.5, 
           label = paste0("Tasa global: ", round(tasa_global,1), "%"), 
           color = "red") +
  labs(title = "Probabilidad de cancelación según anticipación de reserva",
       x = "Tiempo entre reserva y llegada", y = "Tasa de cancelación (%)") +
  theme_minimal()

# Hallazgo: Las reservas canceladas tienen un lead_time significativamente mayor. 
# Reservar con mucha anticipación aumenta el riesgo de cancelación.

# ============================================================
# TABLA DE DESCRIPCIÓN DE VARIABLES
# ============================================================

descripcion_variables <- data.frame(
  Variable = c("hotel", "is_canceled", "lead_time", "arrival_date_year",
               "arrival_date_month", "arrival_date_week_number", 
               "arrival_date_day_of_month", "stays_in_weekend_nights",
               "stays_in_week_nights", "adults", "children", "babies", "meal",
               "country", "market_segment", "distribution_channel",
               "is_repeated_guest", "previous_cancellations",
               "previous_bookings_not_canceled", "reserved_room_type",
               "assigned_room_type", "booking_changes", "deposit_type",
               "agent", "company", "days_in_waiting_list", "customer_type",
               "adr", "required_car_parking_spaces", "total_of_special_requests",
               "reservation_status", "reservation_status_date"),
  Tipo = c("Categórico", "Categórico (0/1)", "Numérico", "Numérico", 
           "Categórico", "Numérico", "Numérico", "Numérico", "Numérico",
           "Numérico", "Numérico", "Numérico", "Categórico", "Categórico",
           "Categórico", "Categórico", "Categórico (0/1)", "Numérico",
           "Numérico", "Categórico", "Categórico", "Numérico", "Categórico",
           "Categórico", "Categórico", "Numérico", "Categórico", "Numérico",
           "Numérico", "Numérico", "Categórico", "Fecha"),
  Descripción = c("Tipo de hotel (Resort Hotel, City Hotel)",
                  "Si la reserva fue cancelada (1) o no (0)",
                  "Días entre la reserva y la llegada",
                  "Año de llegada", "Mes de llegada", "Número de semana del año",
                  "Día del mes de llegada", "Noches de fin de semana",
                  "Noches entre semana", "Número de adultos", "Número de niños",
                  "Número de bebés", "Tipo de comida (BB, HB, FB, SC)",
                  "País de origen", "Segmento de mercado",
                  "Canal de distribución", "Es huésped recurrente (1) o no (0)",
                  "Cancelaciones previas", "Reservas previas no canceladas",
                  "Tipo de habitación reservada", "Tipo de habitación asignada",
                  "Cambios en la reserva", "Tipo de depósito",
                  "ID de agencia de viajes", "ID de empresa",
                  "Días en lista de espera", "Tipo de cliente",
                  "Tarifa diaria promedio (ADR)", "Espacios de parking requeridos",
                  "Solicitudes especiales", "Estado de la reserva",
                  "Fecha del último estado de reserva")
)

View(descripcion_variables)

write.csv(datos, "hotel_bookings_despues.csv", row.names = FALSE)
write.csv(descripcion_variables, "variable.csv", row.names = FALSE)
