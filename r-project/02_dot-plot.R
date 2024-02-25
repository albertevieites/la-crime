# Cargar las bibliotecas necesarias
library(ggplot2)
library(dplyr)
library(tidyr) # Asegúrate de que esta biblioteca esté cargada
library(lubridate)

# Cargar los datos desde el archivo CSV
datos_crimen <- read.csv("../data/cleaned_data-crime.csv", header = TRUE, sep = ",")

# Asegurarse de que DATE.OCC es una fecha
datos_crimen$DATE.OCC <- as.Date(datos_crimen$DATE.OCC)

# Extraer el mes y el año de la fecha de ocurrencia
datos_crimen$Month <- month(datos_crimen$DATE.OCC, label = TRUE, abbr = TRUE)
datos_crimen$Year <- year(datos_crimen$DATE.OCC)

# Contar el número de crímenes por mes
crimenes_por_mes <- datos_crimen %>%
  count(Month, name = "Number_Crimes")

# Asegurarse de que los meses estén en orden
crimenes_por_mes$Month <- factor(crimenes_por_mes$Month, levels = month.abb)

# Crear una secuencia de puntos para cada mes
# Aumentar el valor de 'by' para separar más los puntos
# Aumentar el tamaño de los puntos en geom_point()
crimenes_por_mes <- crimenes_por_mes %>%
  rowwise() %>%
  mutate(PointSeq = list(seq(1, Number_Crimes, by = 2500))) %>%
  unnest(PointSeq)

# Crear un "dot plot" con ggplot2
# Aumentar el 'size' en geom_point()
ggplot(crimenes_por_mes, aes(x = Month, y = PointSeq)) +
  geom_point(size = 7, alpha = 0.6, color='#94350C') +
  labs(title = "Número de Crímenes por Mes", x = "Mes", y = "Número de Crímenes") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_x_discrete(expand = c(0.5, 0.5))

