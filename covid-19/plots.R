library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(grid)
library(ggrepel)

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

datatyle <- list(theme_light(), geom_line(size = 1), 
                  scale_x_date(date_breaks = "1 day", date_minor_breaks = "1 day",
                               date_labels = "%d/%m"),
                  theme(axis.text.x = element_text(angle = 45, hjust = 1)),
                  theme(plot.title = element_text(hjust = 0.5)),
                  labs(x = "Data", y = "Número de Casos"))

################################
# Ministério da saúde
# http://plataforma.saude.gov.br/novocoronavirus/

calc_new <- function(x) {
  new <- x - lag(x)
  new[is.na(new)] <- 0
  new
}

estados <- read_excel("Brasil.xlsx", sheet = "Confirmados") %>%
  mutate(Data = as.Date(Data))

write_excel_csv(estados, path = "data/casosconfirmados.csv")

mortes <- read_excel("Brasil.xlsx", sheet = "Mortes") %>%
  mutate(Data = as.Date(Data))

write_excel_csv(mortes, path = "data/mortes.csv")

estados_new <- estados %>%
  mutate_if(is.numeric, calc_new)

ufs <- colnames(estados)[-1]

for (uf in ufs) {
  ts <- estados[[uf]]
  tot_range <- seq(min(ts), max(ts))
  uf_s <- sym(uf)
  p1 <- ggplot(estados, aes(x = Data, y = !!uf_s)) + datatyle +
    scale_y_continuous(breaks = pretty(tot_range), 
                       limits = c(min(tot_range), max(tot_range) * 1.05)) + 
    ggtitle(paste("Casos Confirmados -", uf)) + 
    annotate("text", x = estados$Data[1], y = max(estados[[uf]]) * 1.01, 
             label = "Fonte: Ministério da Saúde", hjust = 0, vjust = 0) +
    annotation_custom(
      grob = textGrob(label = "www.alanmol.com.br/covid-19", 
                      hjust = 1, gp = gpar(cex = 0.8), vjust = 1),
      xmin = max(estados$Data),
      ymax = -(0.35 * max(estados[[uf]]))) +
    coord_cartesian(clip = "off")
  
  new_cases <- estados_new[[uf]]
  new_range <- seq(min(new_cases), max(new_cases))
  
  p2 <- ggplot(estados_new, aes(x = Data, y = !!uf_s)) + datatyle +
    scale_y_continuous(breaks = pretty(new_range),
                       limits = c(min(new_range), max(new_range) * 1.05)) +
    ggtitle(paste("Novos Casos Confirmados -", uf)) + 
    annotate("text", x = estados$Data[1], y = max(new_cases) * 1.01, 
             label = "Fonte: Ministério da Saúde", hjust = 0, vjust = 0) +
    annotation_custom(
      grob = textGrob(label = "www.alanmol.com.br/covid-19", 
                      hjust = 1, gp = gpar(cex = 0.8), vjust = 1),
      xmin = max(estados$Data) ,
      ymax = -(0.35 * max(new_cases))) +
        coord_cartesian(clip = "off")
  
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

distplot <- tail(estados, 1) %>% select(-Brasil, -Data) %>% 
  pivot_longer(everything(), names_to = "Estado", values_to = "Casos") %>%
  ggplot(aes(x = reorder(Estado, -Casos), y = Casos)) + geom_bar(stat = "identity") +
  geom_text(aes(label = Casos), position = position_dodge(width = 0.9), 
            vjust = -0.2, size = 3) +
  theme_light() + labs(x = "Estado") + ggtitle("Distribuição dos casos") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text", x = ncol(estados) - 2, y = max(estados$`São Paulo`), 
           label = "Fonte: Ministério da Saúde", hjust = 1, vjust = 1) +
  annotation_custom(
    grob = textGrob(label = "www.alanmol.com.br/covid-19", 
                    hjust = 1, gp = gpar(cex = 0.8), vjust = 0.5),
    xmin = ncol(estados) - 2,
    ymax = -(1.1 * max(estados$`São Paulo`))) +
  coord_cartesian(clip = "off")

distplot

ggsave(paste0("data/Distribuição.png"), plot = distplot,
       device = png(),
       width = 20,
       height = 10,
       units = "cm",
       dpi = 100)
dev.off()

pop <- read_excel("Brasil.xlsx", sheet = "Populacao")

pop_vec <- pop$População %>% setNames(pop$UF)
pop_vec["Brasil"] <- sum(pop_vec)
pop_vec <- pop_vec[order(names(pop_vec))]

casos_confirmados <- unlist(tail(estados[,-1], 1))[order(colnames(estados[,-1]))]

casos_por_hab <- tibble(Estado = names(pop_vec),
                        Casos = casos_confirmados / (pop_vec / 100000))

cph_plot <- casos_por_hab %>% ggplot(aes(x = reorder(Estado, -Casos), y = Casos)) + geom_bar(stat = "identity") +
  geom_text(aes(label = round(Casos, 2)), position = position_dodge(width = 0.9), 
            vjust = -0.2, size = 3) +
  theme_light() + labs(x = "Estado") + ggtitle("Casos por 100 mi habitantes") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text", x = 25, y = max(casos_por_hab$Casos), 
           label = "Fontes: Ministério da Saúde\nIBGE", hjust = 1, vjust = 1) +
  annotation_custom(
    grob = textGrob(label = "www.alanmol.com.br/covid-19", 
                    hjust = 1, gp = gpar(cex = 0.8), vjust = 0.5),
    xmin = 25,
    ymax = -(0.85 * max(casos_por_hab$Casos))) +
  coord_cartesian(clip = "off")

cph_plot


#########

# Our World in Data
# https://ourworldindata.org/coronavirus-source-data

full_data <- read_csv("https://covid.ourworldindata.org/data/ecdc/full_data.csv") %>% 
  mutate(date = as.Date(date))

full_data %>% filter(location == "Brazil") %>% tail

br_ms <- estados[c("Data","Brasil")] %>%
  mutate(location = "Brasil") %>%
  rename(date = Data, total_cases = Brasil) %>%
  mutate(date = date + 1) 

br_ms_m <- mortes[c("Data","Brasil")] %>%
  mutate(location = "Brasil") %>%
  rename(date = Data, total_deaths = Brasil) %>%
  mutate(date = date + 1) 

full_data <- full_join(full_data, left_join(br_ms, br_ms_m))

compare <- c("Brasil", "Italy", "United States", "Spain", "France", "Argentina",
             "Iran", "South Korea", "Portugal", "Germany", "United Kingdom")
maxday <- 15
mincases <- 100
pot10 <- function(x) {10 ^ x}

full_data_style <- list(theme_light(),
                        geom_line(aes(group = location, colour = location), size = 1),
                        geom_label_repel(aes(label = label), nudge_x = 1, na.rm = TRUE),
                        labs(x = "Dia", y = "Número de Casos", colour = "País"),
                        ggtitle(paste("Casos confirmados após o", mincases, "º caso")),
                        theme(plot.title = element_text(hjust = 0.5)),
                        scale_x_continuous(breaks = 1:100, minor_breaks = 1:100))
  

lin_data <- full_data %>% filter(location %in% compare) %>%
  filter(total_cases >= mincases ) %>% group_by(location) %>%
  mutate(day = 1:n()) %>% filter(day <= maxday) %>%
  mutate(label = if_else(day == max(day), location, NA_character_))

lin_plot <- ggplot(lin_data, aes(day, total_cases)) + 
  full_data_style +
  annotate("text", x = 1, y = max(lin_data$total_cases), 
           label = "Fontes: https://ourworldindata.org/coronavirus\nMinistério da Saúde do Brasil",
           hjust = 0, vjust = 0.5) +
  annotation_custom(
    grob = textGrob(label = "www.alanmol.com.br/covid-19", 
                    hjust = 0.5, gp = gpar(cex = 0.8), vjust = 1),
    xmin = maxday,
    ymax = -(0.18 * max(lin_data$total_cases))) +
  coord_cartesian(clip = "off")

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

log_plot <- ggplot(log_data, aes(day, total_cases)) + full_data_style +
  labs(y = "Número de Casos (log10)") +
  scale_y_continuous(breaks = 1:4, minor_breaks = NULL, labels = pot10) +
  annotate("text", x = 1, y = max(log_data$total_cases), 
           label = "Fontes: https://ourworldindata.org/coronavirus\nMinistério da Saúde do Brasil",
           hjust = 0, vjust = 0.5) +
  annotation_custom(
    grob = textGrob(label = "www.alanmol.com.br/covid-19", 
                    hjust = 0.5, gp = gpar(cex = 0.8), vjust = 1),
    xmin = maxday,
    ymax = (0.65 * diff(range(log_data$total_cases)))) +
  coord_cartesian(clip = "off")

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
  scale_y_continuous(breaks = 1:4, minor_breaks = NULL, labels = pot10) +
  annotate("text", x = 1, y = max(log_data$total_cases), 
           label = "Fontes: https://ourworldindata.org/coronavirus\nMinistério da Saúde do Brasil",
           hjust = 0, vjust = 0.5) +
  annotation_custom(
    grob = textGrob(label = "www.alanmol.com.br/covid-19", 
                    hjust = 0.5, gp = gpar(cex = 0.8), vjust = 1),
    xmin = maxday,
    ymax = (0.65 * diff(range(log_data$total_cases)))) +
  coord_cartesian(clip = "off")

comp_plot


### Mortes

death_plot <- tail(mortes, 1) %>% select(-Brasil, -Data) %>% 
  pivot_longer(everything(), names_to = "Estado", values_to = "Casos") %>%
  ggplot(aes(x = reorder(Estado, -Casos), y = Casos)) + geom_bar(stat = "identity") +
  geom_text(aes(label = Casos), position = position_dodge(width = 0.9), 
            vjust = -0.2, size = 3) +
  theme_light() + labs(x = "Estado") + ggtitle("Distribuição dos casos") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text", x = ncol(estados) - 2, y = max(estados$`São Paulo`), 
           label = "Fonte: Ministério da Saúde", hjust = 1, vjust = 1) +
  annotation_custom(
    grob = textGrob(label = "www.alanmol.com.br/covid-19", 
                    hjust = 1, gp = gpar(cex = 0.8), vjust = 0.5),
    xmin = ncol(estados) - 2,
    ymax = -(1.1 * max(estados$`São Paulo`))) +
  coord_cartesian(clip = "off")

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
  theme_light() + labs(x = "País", y = "Mortalidade") + ggtitle("Mortalidade") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text", x = nrow(death_comp), y = avg_death,
           label = paste("Mortalidade média (n >= 20):", avg_death * 100, "%"), 
           hjust = 1, vjust = -0.25) +
  annotate("text", x = nrow(death_comp), y = 0.09, 
           label = "Fontes: https://ourworldindata.org/coronavirus\nMinistério da Saúde do Brasil", 
           hjust = 1, vjust = 1) +
  annotation_custom(
    grob = textGrob(label = "www.alanmol.com.br/covid-19", 
                    hjust = 1, gp = gpar(cex = 0.8), vjust = 0.5),
    xmin = nrow(death_comp) - 1,
    ymax = -0.075) +
  coord_cartesian(clip = "off") 

death_comp_plot

ggsave(paste0("data/Mortalidade.png"), plot = death_comp_plot,
       device = png(),
       width = 20,
       height = 10,
       units = "cm",
       dpi = 100)
dev.off()
