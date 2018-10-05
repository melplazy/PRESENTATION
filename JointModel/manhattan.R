library(tidyverse)
library(viridis)
library(grid)
library(ggrepel)
devtools::source_url('https://github.com/mcanouil/DEV/raw/master/Rfunctions/theme_black.R')
devtools::source_url('https://github.com/mcanouil/DEV/raw/master/Rfunctions/ggmanhattan.R')
theme_set(theme_black(base_size = 14))

load(file = "/disks/DATATMP/DESIR_longitudinal/ArticleR/MetaboChip_T2D.annot.Rdata")
ggdta_T2D <- results.annot %>% 
  select(c(
    "chr", "position", "RSID", 
    "term", "alpha.p.value", "gamma.p.value", 
    "GeneSymbol", "Left_Gene", "Gene", "Right_Gene"
  )) %>% 
  gather(key = "parameter", value = "pvalue", c("alpha.p.value", "gamma.p.value"))%>% 
  mutate(
    Closest.GeneSymbol = pmap(.l = list(Left_Gene, Gene, Right_Gene), .f = function(x, y, z) {
      irow <- c(Left_Gene = x, Gene = y, Right_Gene = z)
      if (irow["Gene"] != "") {
        return(irow["Gene"])
      } else {
        out <- ifelse(
          as.numeric(gsub(".*\\(([0-9]*)\\ kb)", "\\1", irow["Left_Gene"])) < as.numeric(gsub(".*\\(([0-9]*)\\ kb)", "\\1", irow["Right_Gene"])),
          irow["Left_Gene"],
          irow["Right_Gene"]
        )
        return(gsub(" \\(.*", "", out))
      }
    })
  ) %>% 
  mutate(
    parameter = gsub(".p.value", "", parameter)
  ) %>% 
  mutate(
    sign = (parameter != "alpha")*2 - 1
  )

genes_highlight <- c(
  c("MVK", "MYO1H"),
  ggdta_T2D %>% 
    arrange(pvalue) %>% 
    filter(
      parameter == "gamma" & pvalue < 5e-5
    ) %>% 
    select(Closest.GeneSymbol) %>% 
    unlist() %>% 
    unname() %>% 
    table() %>% 
    sort(decreasing = TRUE) %>% 
    names() %>% 
    head(n = 10)
)

ggdta_T2D <- ggdta_T2D %>% 
  mutate(
    label = Closest.GeneSymbol %>% 
      gsub("^ABCB11$", "G6PC2 / ABCB11", .) %>% 
      gsub("^G6PC2$", "G6PC2 / ABCB11", .) %>% 
      gsub("YKT6", "GCK", .) %>% 
      gsub("C2orf16", "GCKR", .) %>% 
      gsub("NRBP1", "GCKR", .) %>% 
      gsub("IFT172", "GCKR", .) %>% 
      gsub("LOC105369431", "MTNR1B", .) %>% 
      gsub("MYO1H", "KCTD10", .),
    label = ifelse(Closest.GeneSymbol%in%genes_highlight, label, NA),
    label_group = label
  ) %>% 
  group_by(label_group) %>% 
  mutate(
    label_repel = ifelse(pvalue==min(pvalue), label, NA)
  ) %>% 
  ungroup() %>% 
  select(-label_group) %>% 
  # mutate(label_repel = ifelse(label_repel%in%c("KCTD10", "MVK"), NA, label_repel)) %>% 
  mutate(y = -log10(pvalue) * sign) %>% 
  mutate(
    colour = factor(x = paste0(parameter, chr), levels = unique(paste0(parameter, chr)))
  )

ggdata_clean <- ggmanhattan(
  data = ggdta_T2D,
  x_chr = "chr", 
  x_pos = "position", 
  y_pval = "y", 
  y_trans = FALSE
)$data %>% 
  filter(!is.na(y_pval))

x_breaks <- ggdata_clean %>% 
  group_by(x_chr) %>% 
  summarise(x_med = median(x_pos)) %>% 
  select(x_chr, x_med) 

ggplot(data = ggdata_clean, aes(x = x_pos, y = y_pval, colour = colour)) +
  geom_point(size = 1.5, shape = 21, na.rm = TRUE, show.legend = FALSE) +
  scale_colour_manual(
    values = c(
      rep(viridis_pal(begin = 1/4, end = 3/4)(2), 11),
      rev(rep(viridis_pal(begin = 1/4, end = 3/4)(2), 11))
    )
  ) +
  scale_x_continuous(
    breaks = x_breaks[["x_med"]],
    labels = x_breaks[["x_chr"]],
    limits = range(ggdata_clean[["x_pos"]]),
    expand = c(0.01, 0)
  ) +
  geom_hline(yintercept = 0, linetype = 1, colour = "white") +
  geom_point(
    data = filter(ggdata_clean, !is.na(label)),
    size = 1.5,
    shape = 21,
    show.legend = FALSE,
    colour = viridis(n = 1, begin = 1, end = 1)
  ) +
  geom_label_repel(
    data = filter(ggdata_clean, parameter=="gamma"),
    mapping = aes(label = label_repel), 
    fill = "grey20",
    colour = viridis(n = 1, begin = 1, end = 1), 
    segment.colour = viridis(n = 1, begin = 1, end = 1),
    min.segment.length = unit(0, "lines"),
    nudge_y = 2,
    na.rm = TRUE
  ) +
  geom_label_repel(
    data = filter(ggdata_clean, parameter=="alpha"),
    mapping = aes(label = label_repel), 
    fill = "grey20",
    colour = viridis(n = 1, begin = 1, end = 1), 
    segment.colour = viridis(n = 1, begin = 1, end = 1),
    min.segment.length = unit(0, "lines"),
    nudge_y = -2,
    na.rm = TRUE
  ) +
  theme(
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.spacing.y = unit(0, "in"),
    strip.text.y = element_text(colour = "white", angle = 0, size = rel(2)), 
    axis.text.x = element_text(angle = 60, hjust = 1),
    legend.position = "none"
  ) +
  labs(x = "Chromosome", y = "P-Value") +
  scale_y_continuous(
    expand = c(0, 0), # expand_scale(add = c(5, 5)), 
    limits = c(-10, 30),
    breaks = c(-10, -5, 0, 5, 10, 15, 20, 25),
    labels = function(x) {
      parse(
        text = ifelse(x==0, "1", paste0("10^", abs(x)))
      )
    }
  ) +
  annotate(
    geom = "label",
    x = rep(max(ggdata_clean$x_pos)*0.99, 2), 
    y = c(min(ggdata_clean$y_pval)-2.5, max(ggdata_clean$y_pval)+2.5), 
    label = c(expression(alpha), expression(gamma)),
    fill = "white",
    colour = "grey20"
  )


