# Cargar las bibliotecas necesarias
library(ggplot2)
library(dplyr)
library(maps)

# Cargar los datos desde el archivo CSV
datos_crimen <- read.csv("../data/cleaned_data-crime.csv", header = TRUE, sep = ",")

# Agrupar los datos por AREA.NAME y calcular el promedio de LAT y LON
datos_agrupados <- datos_crimen %>%
  group_by(AREA.NAME) %>%
  summarise(NumeroCrimenes = n(),
            LatPromedio = mean(LAT, na.rm = TRUE),
            LonPromedio = mean(LON, na.rm = TRUE))

# Cargar el mapa base
map_data_la <- map_data("county", "california") %>%
  filter(region == "california", subregion == "los angeles")

# Crear el gráfico
ggplot(data = map_data_la) +
  geom_polygon(aes(x = long, y = lat, group = group), fill = "white", color = "black") +
  geom_point(data = datos_agrupados, aes(x = LonPromedio, y = LatPromedio, size = NumeroCrimenes), color = "red") +
  scale_size(range = c(1, 10), name = "Número de Crímenes") +
  labs(title = "Crimen en el Condado de Los Ángeles", x = "Longitud", y = "Latitud") +
  theme_minimal() +
  coord_fixed(1.3)

