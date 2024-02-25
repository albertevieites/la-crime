library(ggplot2)
library(sf)
library(dplyr)

datos_crimen <- read.csv("../data/cleaned_data-crime.csv", header = TRUE, sep = ",")

df <- data.frame(datos_crimen)
head(df)

# Group and count crimes by location
crime_counts <- df %>%
  group_by(LAT, LON) %>%
  summarise(crime_count = n()) %>%
  ungroup()

# Remove files with invalid values
crime_counts <- crime_counts %>%
  filter(!is.na(LAT), !is.na(LON), LAT != 0 | LON != 0)

# Create an sf object with added data
crime_sf <- st_as_sf(crime_counts, coords = c("LON", "LAT"), crs = 4326)

# Import a geojson or shapefile
city_map <- read_sf("../assets/city/city_boundary.shp")

# Check CRS
print(st_crs(city_map))
print(st_crs(crime_sf))

# Base map
base_map <- ggplot() +
  geom_sf(data = city_map)

# Fix CRS
crime_sf <- st_transform(crime_sf, st_crs(city_map))

# Join data crime with map based on the geomtriy intersections
joined_data <- sf::st_join(city_map, crime_sf, join = sf::st_intersects)
joined_data

# Plot map
map <- base_map +
  geom_sf(data = joined_data, aes(fill = crime_count)) +
  scale_fill_gradient(low = "yellow", high = "red") +
  theme_void() +
  theme(
    legend.position = "bottom"
  )
map

print(crime_counts)

##########################################################
# Muestrear tus datos de crímenes si son demasiados puntos
city_map_simplified <- st_simplify(city_map, preserveTopology = TRUE)

set.seed(123) # Para reproducibilidad
crime_sf_sampled <- crime_sf %>% 
  sample_frac(size = 0.1) # Ajusta el tamaño de la muestra según sea necesario

# Crear el gráfico
map2 <- ggplot() +
  geom_sf(data = city_map_simplified, fill = "white", color = "black") + # Añade color de relleno y borde para las áreas
  geom_sf(data = crime_sf_sampled, aes(fill = crime_count), size = 2, alpha = 0.5) + # Ajusta el tamaño y la transparencia
  scale_fill_gradient(low = "yellow", high = "red") +
  theme_void() +
  theme(legend.position = "bottom")

# Mostrar el mapa
print(map2)
