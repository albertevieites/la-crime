library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)

# Load dataset
datos_crimen <- read.csv("../data/cleaned_data-crime.csv", header = TRUE, sep = ",")

# Convertir la columna DATE.OCC a tipo fecha
datos_crimen$DATE.OCC <- as.Date(datos_crimen$DATE.OCC)

# Extraer el mes y el año
datos_crimen$Month <- factor(month(datos_crimen$DATE.OCC, label = TRUE, abbr = TRUE), levels = month.abb)
datos_crimen$Year <- year(datos_crimen$DATE.OCC)

# Contar el número de crímenes por mes para cada área
crimenes_por_mes_y_area <- datos_crimen %>%
  count(AREA.NAME, Month, name = "Number_Crimes")

# Ajustar los puntos para que estén más separados y sean más grandes
crimenes_por_mes_y_area <- crimenes_por_mes_y_area %>%
  rowwise() %>%
  mutate(PointSeq = list(seq(1, Number_Crimes, by = 1000))) %>% # ajustar 'by' para separar los puntos
  unnest(PointSeq)

# Crear un "dot plot" con ggplot2 ajustando el tamaño y la separación de los puntos
ggplot(crimenes_por_mes_y_area, aes(x = Month, y = Number_Crimes, fill = AREA.NAME)) +
  geom_col() +
  facet_wrap(~ AREA.NAME, scales = "free_y") +
  labs(title = "Número de Crímenes por Mes y Área", x = "Mes", y = "Número de Crímenes") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), strip.text.x = element_text(angle = 0)) +
  scale_x_discrete(expand = c(0.02, 0.02))
