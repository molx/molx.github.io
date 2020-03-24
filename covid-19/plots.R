library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(tibble)
library(ggplot2)
library(grid)
library(ggrepel)
library(gganimate)

# source <- "Fonte: 2019 Novel Coronavirus COVID-19 (2019-nCoV)\nData Repository by Johns Hopkins CSSE\nhttps://github.com/CSSEGISandData/COVID-19"

# conf_raw <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv"
# deaths_raw <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv"
# confirmed <- read_csv(conf_raw)
# countries <- confirmed$`Country/Region`
# unq_countries <- confirmed$`Country/Region`[is.na(confirmed$`Province/State`)]
# 
# br <- confirmed[confirmed$`Country/Region` == 'Brazil',] %>%
#   select(matches("\\d{1,2}/\\d{1,2}/\\d{2}")) %>%
#   pivot_longer(everything(), names_to = "Date", values_to = "Cases") %>%
#   mutate(Date = as.Date(Date, format = "%m/%d/%y"), New = Cases - lag(Cases)) %>%
#   tail(-29)

datastyle <- list(theme_light(), geom_line(size = 1), 
                  scale_x_date(date_breaks = "1 day", date_minor_breaks = "1 day",
                               date_labels = "%d/%m"),
                  theme(axis.text.x = element_text(angle = 45, hjust = 1)),
                  theme(plot.title = element_text(hjust = 0.5)),
                  labs(x = "Data", y = "Número de Casos"))

################################
# Ministério da saúde
# http://plataforma.saude.gov.br/novocoronavirus/

#Calculating new cases by the difference between day and day - 1
calc_new <- function(x) {
  new <- x - lag(x)
  new[is.na(new)] <- 0
  new
}

# Functio to calculate theoretical exponetial growth
# factor = the amount which grows
# time = the time it takes to grow by factor
# maxx = max time to generate
# e.g.: factor = 2, time = 3, means doubles every 3 units of time
growth_line <- function(factor, time, maxx) {
  x <- 1:maxx
  y <- factor ^ (x / time)
  matrix(c(x, y), ncol = 2)
}

casos <- read_excel("data/Brasil.xlsx", sheet = "Confirmados") %>%
  mutate(Data = as.Date(Data)) %>% rename(date = Data) %>%
  pivot_longer(-date, names_to = "location", values_to = "total_cases") 

mortes <- read_excel("data/Brasil.xlsx", sheet = "Mortes") %>%
  mutate(Data = as.Date(Data)) %>% rename(date = Data) %>%
  pivot_longer(-date, names_to = "location", values_to = "total_deaths")

estados <- full_join(casos, mortes) %>% group_by(location) %>%
  mutate(new_cases = calc_new(total_cases),
         new_deaths = calc_new(total_deaths))

estados %>% filter(location == "São Paulo") %>% tail

write_excel_csv(estados, path = "data/estados.csv")

brasil <- estados %>% group_by(date) %>%
  summarise_if(is.numeric, sum) %>% 
  mutate(location = "Brasil") %>%
  full_join(estados, .) %>% arrange(date, location)

ufs <- unique(brasil$location)

##Brasil (log)

brasil_log_data <- brasil %>% filter(location == "Brasil", total_cases >= 100) %>% 
  mutate(total_cases = log10(total_cases))

tot_range <- seq(min(brasil_log_data$total_cases), max(brasil_log_data$total_cases))  

brasil_log_plot <- ggplot(brasil_log_data, aes(x = date, y = total_cases)) + datastyle +
  ggtitle(paste("Casos Confirmados -", uf)) + 
  annotate("text", x = brasil_log_data$date[1], y = max(brasil_log_data$total_cases) * 1.01, 
           label = "Fonte: Ministério da Saúde", hjust = 0, vjust = 0)

brasil_log_plot

for (uf in ufs) {
  ts <- brasil %>% filter(location == uf)
  if (nrow(ts) <= 1) next
  tot_range <- seq(min(ts$total_cases), max(ts$total_cases))  
  p1 <- ggplot(ts, aes(x = date, y = total_cases)) + datastyle +
    scale_y_continuous(breaks = pretty(tot_range), 
                       limits = c(min(tot_range), max(tot_range) * 1.05)) + 
    ggtitle(paste("Casos Confirmados -", uf)) + 
    annotate("text", x = ts$date[1], y = max(ts$total_cases) * 1.01, 
             label = "Fonte: Ministério da Saúde", hjust = 0, vjust = 0)
  
  
  tot_range_new <- seq(min(ts$new_cases), max(ts$new_cases))  
  p2 <- ggplot(ts, aes(x = date, y = new_cases)) + datastyle +
    scale_y_continuous(breaks = pretty(tot_range_new), 
                       limits = c(min(tot_range_new), max(tot_range_new) * 1.05)) + 
    ggtitle(paste("Novos Casos Confirmados -", uf)) + 
    annotate("text", x = ts$date[1], y = max(ts$new_cases) * 1.01, 
             label = "Fonte: Ministério da Saúde", hjust = 0, vjust = 0)
  
  ggsave(paste0("data/", uf, "-Total.png"), plot = p1,
         device = png(),
         width = 20,
         height = 10,
         units = "cm",
         dpi = 100)
  dev.off()
  ggsave(paste0("data/", uf, "-Novos.png"), plot = p2,
         device = png(),
         width = 20,
         height = 10,
         units = "cm",
         dpi = 100)
  dev.off()
}

distplot <- estados %>% group_by(location) %>% filter(row_number() == n()) %>%
  ggplot(aes(x = reorder(location, -total_cases), y = total_cases)) + geom_bar(stat = "identity") +
  geom_text(aes(label = total_cases), position = position_dodge(width = 0.9), 
            vjust = -0.2, size = 3) +
  theme_light() + labs(x = "UF", y = "Casos confirmados") + ggtitle("Distribuição dos casos") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text", x = 27, y = max(estados$total_cases), 
           label = "Fonte: Ministério da Saúde", hjust = 1, vjust = 1) 

distplot

ggsave(paste0("data/Distribuição.png"), plot = distplot,
       device = png(),
       width = 20,
       height = 10,
       units = "cm",
       dpi = 100)
dev.off()

pop <- read_excel("data/Brasil.xlsx", sheet = "Populacao")

pop_vec <- pop$População %>% setNames(pop$UF)
pop_vec["Brasil"] <- sum(pop_vec)
pop_vec <- pop_vec[order(names(pop_vec))]

casos_confirmados <- brasil %>% group_by(location) %>% filter(row_number() == n()) %>%
  arrange(location) %>% `[[`("total_cases")

casos_por_hab <- tibble(Estado = names(pop_vec),
                        Casos = casos_confirmados / (pop_vec / 100000))

casos_por_hab_br <- casos_por_hab$Casos[casos_por_hab$Estado == "Brasil"]

cph_plot <- casos_por_hab %>% filter(Estado != "Brasil") %>%
  ggplot(aes(x = reorder(Estado, -Casos), y = Casos)) + geom_bar(stat = "identity") +
  geom_text(aes(label = round(Casos, 2)), position = position_dodge(width = 0.9),
            vjust = -0.2, size = 3) +
  theme_light() + labs(x = "UF", y = "Casos/(habitantes/100000)") + ggtitle("Casos por 100 mil habitantes") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text", x = 25, y = max(casos_por_hab$Casos),
           label = "Fontes: Ministério da Saúde\nIBGE", hjust = 1, vjust = 1) +
  geom_hline(yintercept = casos_por_hab_br, linetype = "dashed") +
  annotate("text", x = 27, y = casos_por_hab_br,
           label = paste("Brasil =", round(casos_por_hab_br, 2)),
           hjust = 1, vjust = -0.25)

cph_plot

ggsave(paste0("data/Casos por Habitantes.png"), plot = cph_plot,
       device = png(),
       width = 20,
       height = 10,
       units = "cm",
       dpi = 100)
dev.off()

##### Comparações

get_full_data_style <- function(mincases) {
  list(theme_light(),
       geom_line(aes(group = location, colour = location), size = 1),
       geom_label_repel(aes(label = label), nudge_x = 1, na.rm = TRUE),
       labs(x = "Dia", y = "Número de Casos", colour = "País"),
       ggtitle(paste("Casos confirmados após o", mincases, "º caso")),
       theme(plot.title = element_text(hjust = 0.5)),
       scale_x_continuous(breaks = 1:100, minor_breaks = 1:100))
}

mincases <- 50
full_data_style <- get_full_data_style(mincases)
pot10 <- function(x) {10 ^ x}

estado_comp <- estados %>%
  filter(total_cases >= mincases) %>% group_by(location) %>%
  filter(n() > 1) %>% mutate(day = 1:n()) %>%
  mutate(label = if_else(day == max(day), location, NA_character_),
         total_cases = log10(total_cases))

estado_log_brks <- log10(c(seq(20, 100, 20), seq(200, 500, 100)))
estado_comp_plot <- ggplot(estado_comp, aes(day, total_cases)) + 
  full_data_style +
  labs(y = "Número de Casos (log10)") +
  scale_y_continuous(breaks = estado_log_brks, minor_breaks = NULL, labels = pot10) +
  annotate("text", x = 1, y = max(estado_comp$total_cases), 
         label = "Fonte: Ministério da Saúde ",
         hjust = 0, vjust = 0.5)

estado_comp_plot

ggsave(paste0("data/Comparação Estados.png"), plot = estado_comp_plot,
       device = png(),
       width = 20,
       height = 10,
       units = "cm",
       dpi = 100)
dev.off()

#########

# Our World in Data
# https://ourworldindata.org/coronavirus-source-data

full_data <- read_csv("https://covid.ourworldindata.org/data/ecdc/full_data.csv") %>% 
  mutate(date = as.Date(date))

full_data %>% filter(location == "Brazil") %>% tail

full_data <- full_join(full_data, filter(brasil, location == "Brasil"))

compare <- c("Brasil", "Italy", "United States", "Spain", "France",
             "South Korea", "Portugal", "Germany", "United Kingdom")
maxday <- 20
mincases <- 100
full_data_style <- get_full_data_style(mincases)

lin_data <- full_data %>% filter(location %in% compare) %>%
  filter(total_cases >= mincases ) %>% group_by(location) %>%
  mutate(day = 1:n()) %>% filter(day <= maxday) %>%
  mutate(label = if_else(day == max(day), location, NA_character_))

lin_plot <- ggplot(lin_data, aes(day, total_cases)) + 
  full_data_style +
  annotate("text", x = 1, y = max(lin_data$total_cases), 
           label = "Fontes: https://ourworldindata.org/coronavirus\nMinistério da Saúde do",
           hjust = 0, vjust = 0.5)

lin_plot

ggsave(paste0("data/Comparação - Linear.png"), plot = lin_plot,
       device = png(),
       width = 20,
       height = 10,
       units = "cm",
       dpi = 100)
dev.off()

log_data <- lin_data %>%
  mutate(total_cases = log10(total_cases)) 

world_log_brks <- log10(c(seq(2.5e2, 1e3, 2.5e2), seq(2.5e3, 1e4, 2.5e3), seq(2.5e4, 1e5, 2.5e4)))

log_plot <- ggplot(log_data, aes(day, total_cases)) + full_data_style +
  labs(y = "Número de Casos (log10)") +
  scale_y_continuous(breaks = world_log_brks, minor_breaks = NULL, labels = pot10) +
  annotate("text", x = 1, y = max(log_data$total_cases), 
           label = "Fontes: https://ourworldindata.org/coronavirus\nMinistério da Saúde",
           hjust = 0, vjust = 0.5)

log_plot

ggsave(paste0("data/Comparação - Log.png"), plot = log_plot,
       device = png(),
       width = 20,
       height = 10,
       units = "cm",
       dpi = 100)
dev.off()

comp_data <- full_data %>% filter(location %in% compare) %>%
  filter(total_cases >= mincases ) %>% group_by(location) %>%
  mutate(day = 1:n()) %>% 
  mutate(label = if_else(day == max(day), location, NA_character_)) %>%
  mutate(total_cases = log10(total_cases)) 

comp_plot <- ggplot(comp_data, aes(day, total_cases)) + full_data_style +
  labs(y = "Número de Casos (log10)") +
  scale_y_continuous(breaks = world_log_brks, minor_breaks = NULL, labels = pot10) +
  annotate("text", x = 1, y = max(comp_data$total_cases), 
           label = "Fontes: https://ourworldindata.org/coronavirus\nMinistério da Saúde",
           hjust = 0, vjust = 0.5)

comp_plot


### Mortes

death_plot <- estados %>% group_by(location) %>% filter(row_number() == n()) %>%
  ggplot(aes(x = reorder(location, -total_deaths), y = total_deaths)) + geom_bar(stat = "identity") +
  geom_text(aes(label = total_deaths), position = position_dodge(width = 0.9), 
            vjust = -0.2, size = 3) +
  theme_light() + labs(x = "UF", y = "Casos confirmados") + ggtitle("Distribuição dos casos") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text", x = 27, y = max(estados$total_deaths), 
           label = "Fonte: Ministério da Saúde", hjust = 1, vjust = 1)

death_plot

avg_death <- full_data %>% filter(total_deaths >= 20) %>%
  mutate(death_ratio = total_deaths / total_cases) %>%
  group_by(location) %>% slice(n()) %>%
  `$`("death_ratio") %>% mean %>% round(4)

death_comp <- full_data %>%
  filter(location %in% compare) %>%
  mutate(death_ratio = total_deaths / total_cases) %>%
  group_by(location) %>% slice(n())

death_comp_plot <- death_comp %>%
  ggplot(aes(x = reorder(location, -death_ratio), y = death_ratio)) + geom_bar(stat = "identity") +
  geom_hline(yintercept = avg_death, linetype = "dashed") +
  geom_text(aes(label = paste0(round(death_ratio * 100, 2), "%")) , position = position_dodge(width = 0.9), 
            vjust = -0.2, size = 3) +
  scale_y_continuous(breaks = seq(0, 0.1, 0.025), labels = paste0(seq(0, 10, 2.5), "%")) +
  theme_light() + labs(x = "País", y = "Letalidade") + ggtitle("Letalidade") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text", x = nrow(death_comp) + 0.5, y = avg_death,
           label = paste("Letalidade média (n >= 20):", avg_death * 100, "%"), 
           hjust = 1, vjust = -0.25) +
  annotate("text", x = nrow(death_comp) + 0.5, y = 0.09, 
           label = "Fontes: https://ourworldindata.org/coronavirus\nMinistério da Saúde", 
           hjust = 1, vjust = 1) 

death_comp_plot

ggsave(paste0("data/Letalidade.png"), plot = death_comp_plot,
       device = png(),
       width = 20,
       height = 10,
       units = "cm",
       dpi = 100)
dev.off()

today <- format(Sys.Date(), format = "%d de %B")
rng_dat <- 10 * seq(0, 1, length.out = 11) ^ 10
png("data/Instagram.png", 
    width = 20,
    height = 10,
    units = "cm",
    res = 100)
par(mar = c(3, 3, 3, 3), xpd = TRUE)
plot(0:10, rng_dat, xaxt = "n", yaxt = "n", frame.plot = TRUE,
     type = "b", xlab = NA, ylab = NA, 
     xlim = c(0, 10), ylim = c(0, 10))
text(x = 5, y = 5, labels = paste("Gráficos do dia", today),
     cex = 2.8)
rect(-1, -1, 11, 11, lwd = 3)
dev.off()

#####

#Bar Chart Race

estados_hora <- estados %>% mutate(date = as.POSIXct(date)) %>% group_by(date, location) %>% 
  do({
    dia <- .
    ref_row <- dia %>% slice(n())
    hours_rows <- tibble(date = seq(ref_row$date, by = "hour", length.out = 24),
                         location = ref_row$location,
                         total_cases = round(seq(from = ref_row$total_cases - ref_row$new_cases,
                                           to = ref_row$total_cases,
                                           length.out = 24), 0))
    estados <- hours_rows
  })
  
estados_hora %>% filter(location == "Distrito Federal") %>% tail(50)
  

p <- estados_hora %>% group_by(date) %>%
  arrange(total_cases) %>% mutate(rank = 1:n()) %>%
  ggplot(aes(x = rank, y = total_cases, group = location)) +
  geom_tile(aes(y = total_cases / 2, height = total_cases, fill = location), width = 0.9) +
  geom_text(aes(label = location, y = -10), hjust = "right", colour = "black", fontface = "bold") +
  geom_text(aes(label = scales::comma(total_cases)), hjust = "left", nudge_y = 10, colour = "grey30") +
  coord_flip(clip = "off") +
  #scale_x_discrete("") +
  scale_y_continuous("",labels = scales::comma, 
                     expand = c(0, 0)) +
                     #limits = c(0, max(estados_hora$total_cases) * 1.05)) +
  #hrbrthemes::theme_ipsum(plot_title_size = 32, subtitle_size = 24, caption_size = 20, base_size = 20) +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        legend.position = "none",
        plot.margin = margin(1,1,1,3.5,"cm"),
        axis.text.y = element_blank()) +
  # gganimate code to transition by year:
  transition_time(date) +
  labs(x = "",
       title = "Casos confirmados por UF",
       subtitle = "Casos confirmados em {format(frame_time, format = '%d/%m/%Y')}",
       caption = "Fonte: Ministério da Saúde") +
  scale_fill_manual(name = 'UF', values = rainbow(27)) +
  #ease_aes('cubic-in-out') +
  ease_aes('linear') 

anim <- animate(p, duration = 30, fps = 25, end_pause = 100, 
                width = 787, height = 500)
anim_save("data/EstadosAnim.gif")
