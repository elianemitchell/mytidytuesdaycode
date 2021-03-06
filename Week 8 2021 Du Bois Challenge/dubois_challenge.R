# Packages
library(tidyverse)
library(showtext)
showtext_auto()
library(extrafont)
font_import()

# Load in data
tuesdata <- tidytuesdayR::tt_load(2021, week = 8)
freed_slaves <-tuesdata$freed_slaves

# Add groups 
data <- freed_slaves %>%
  group_by(Year) %>%
  mutate(n = sum(Slave, Free)) %>%
  pivot_longer(cols = Slave:Free,
               names_to = "freed_slave") %>%
  mutate(percent = value / n) 

# Make Geom Area chart
plot <- data %>%
  ggplot(aes(x = Year, y = percent,
             fill = freed_slave)) +
  geom_area() +
  scale_fill_manual(values=c("#298355","#121312")) +
  labs(title = "PROPORTION OF FREEMEN AND SLAVES AMONG AMERICAN NEGROES .\n\nPROPORTION DES NÈGRES LIBRES ET DES ESCALVES EN AMÉRIQUE .",
       subtitle = "\nDONE BY ATLANTA UNIVERSITY .") +
  # Theme elements
  theme(panel.background = element_rect("#dbcfbf"), #original: #d7cdc0
        plot.background = element_rect("#dbcfbf"),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        aspect.ratio = 0.95, 
        legend.position = "none",
        plot.title = element_text(hjust = 0.5, family = "teko", size = 10.5),
        plot.subtitle = element_text(hjust=0.5, family = "teko_light", size = 9.5),
        plot.caption = element_text(family = "sports", size = 6)) +
  xlim(1790, 1870) +
  # Text label for year
  geom_text(aes(x = Year, y = 1.02, label = Year),
            family = "teko", fontface = "bold") +
  # Text label for percent
  geom_text(aes(x = Year, y = ifelse(Year == 1870, .92, 1.0-percent + 0.02),
                label = ifelse(freed_slave == "Free", paste0(data$value,"%"), "")),
            family = "teko", size = 4) +
  # Text label for Slaves block
  geom_text(x = 1830, y = .55, label = "SLAVES\nESCLAVES", color = "#d7cdc0",
            family = "teko", size = 7) +
  # Text for Free block
  geom_text(x = 1830, y = .96, label = "FREE - LIBRE", family = "teko", size = 5.5) +
  # Lines down from years
  geom_segment(aes(x = Year, xend = Year, y = 1.0, yend = ifelse(
    freed_slave == "Free", 1.0 - percent + 0.05, 1.0)), size = 0.1) +
  # Green line to hide year 1830 line a little
  geom_segment(aes(x=1830, xend=1830, y=.965, yend=.945), color="#298355") 
  
# Save image
ggsave("Du Bois Image.png")

# All fonts from What the Font
font_add("teko_light", regular = "Teko-Light.ttf")
font_add("teko", regular = "Teko-Regular.ttf")  
font_add("Octin Sports", regular = "Octin Sports rg.ttf")


