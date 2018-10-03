devtools::source_url('https://github.com/mcanouil/DEV/raw/master/Rfunctions/ggmanhattan.R')

load(file = "/disks/DATATMP/DESIR_longitudinal/ArticleR/MetaboChip_T2D.annot.Rdata")
ggdta.T2D <- results.annot[, c("chr", "position", "RSID", "term", "alpha.p.value", "gamma.p.value", "GeneSymbol", "Left_Gene", "Gene", "Right_Gene")]
ggdta.T2D <- tidyr::gather(ggdta.T2D, "parameter", "pvalue", c(5, 6))
ggdta.T2D[, "log.pvalue"] <- ifelse(ggdta.T2D[, "parameter"] == "alpha.p.value", log10(ggdta.T2D[, "pvalue"]), -log10(ggdta.T2D[, "pvalue"]))
ggdta.T2D[, "Closest.GeneSymbol"] <- apply(results.annot[, c("Left_Gene", "Gene", "Right_Gene")], 1, function(irow) {
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


genesRed <- c(
  c("MVK", "MYO1H"),
  head(names(sort(table(subset(ggdta.T2D[order(ggdta.T2D[, "pvalue"]), ], parameter == "gamma.p.value" & pvalue < 5e-5, Closest.GeneSymbol)), decreasing = TRUE)), 10)
)
    
plotlist <- lapply(c("gamma.p.value", "alpha.p.value"), function(ipar) {
  if (ipar == "gamma.p.value") {
    chrcol <- rep(viridis_pal()(2), 11)
  } else {
    chrcol <- rep(rev(viridis_pal()(2)), 11)
  }
  
  pManhattan <- ggmanhattan(
    data = subset(ggdta.T2D, parameter == ipar), 
    x_chr = "chr", 
    x_pos = "position", 
    y_pval = "pvalue"
  )

  pManhattan$data[, "parameter"] <- gsub(".p.value", "", as.character(pManhattan$data[, "parameter"]))
  gdta.manhattan <- subset(pManhattan$data, Closest.GeneSymbol %in% genesRed)
  gdta.manhattan[, "label"] <- gdta.manhattan[, "Closest.GeneSymbol"]
  gdta.manhattan[, "label"] <- gsub("^ABCB11$", "G6PC2 / ABCB11", gdta.manhattan[, "label"])
  gdta.manhattan[, "label"] <- gsub("^G6PC2$", "G6PC2 / ABCB11", gdta.manhattan[, "label"])
  gdta.manhattan[, "label"] <- gsub("YKT6", "GCK", gdta.manhattan[, "label"])
  gdta.manhattan[, "label"] <- gsub("C2orf16", "GCKR", gdta.manhattan[, "label"])
  gdta.manhattan[, "label"] <- gsub("NRBP1", "GCKR", gdta.manhattan[, "label"])
  gdta.manhattan[, "label"] <- gsub("IFT172", "GCKR", gdta.manhattan[, "label"])
  gdta.manhattan[, "label"] <- gsub("LOC105369431", "MTNR1B", gdta.manhattan[, "label"])
  gdta.manhattan[, "label"] <- gsub("MYO1H", "KCTD10", gdta.manhattan[, "label"])
  gdta.manhattan <- do.call("rbind", by(gdta.manhattan, gdta.manhattan[, "label"], function(idta) {
    idta[-which.min(idta[, "pvalue"]), "label"] <- NA
    return(idta)
  }))
  gdta.manhattan[gdta.manhattan[, "label"] %in% c("KCTD10", "MVK"), "label"] <- NA
  gdta.manhattan[, "parameter"] <- gsub(".p.value", "", as.character(gdta.manhattan[, "parameter"]))
  pManhattan$data <- gdta.manhattan

  pManhattan <- pManhattan +
    scale_colour_manual(values = chrcol) +
    theme(legend.position = "none") +
    geom_point(colour = viridis_pal(begin = 0.1)(1), size = 1.5, shape = 1) +
    geom_label_repel(
      mapping = aes(label = label), 
      colour = viridis_pal(begin = 0.1)(1), 
      segment.colour = viridis_pal(begin = 0.1)(1), 
      min.segment.length = unit(0, "lines")
    ) +
    theme(
      panel.grid.minor.y = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      panel.spacing.y = unit(0, "in"),
      strip.text.y = element_text(colour = "black", angle = 0, size = rel(2))
    ) +
    theme(plot.margin = unit(c(5.5, 5.5, -2, 5.5), "pt"))
  
  if (ipar == "gamma.p.value") {
    pManhattan <- pManhattan +
      scale_y_continuous(breaks = c(10 ^ 0, 10 ^ -5, 10 ^ -10, 10 ^ -15, 10 ^ -20, 10 ^ -25)[-1], trans = pval_trans(), expand = c(0, 0)) +
      expand_limits(y = c(10 ^ 0, 10 ^ -25)) +
      theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
      theme(axis.title.y = element_blank())
  } else {
    pManhattan <- pManhattan +
      scale_y_continuous(breaks = rev(c(10 ^ 0, 10 ^ -5, 10 ^ -10, 10 ^ -15, 10 ^ -20, 10 ^ -25)), labels = rev(c(0, 10 ^ -5, 10 ^ -10, 10 ^ -15, 10 ^ -20, 10 ^ -25)), trans = log10_trans(), expand = c(0, 0)) +
      expand_limits(y = rev(c(10 ^ 0, 10 ^ -25))) +
      theme(plot.margin = unit(c(-2, 5.5, 5.5, 5.5), "pt")) +
      labs(y = bquote(-log[10](pvalue)), title = NULL) +
      theme(axis.title.y = element_text(hjust = 1.30))
  }

  pManhattan <- pManhattan +
    facet_grid(parameter~., labeller = label_parsed) +
    theme(strip.background = element_rect(fill = NA))
  return(pManhattan)
})

align.ggplot <- function(plotlist) {
  pl <- lapply(plotlist, function(iplot) {
    ggplot_gtable(ggplot_build(iplot))
  })
  plunit <- lapply(pl, function(ipl) {
    ipl$widths[c(2:3, 5)]
  })
  maxWidth <- eval(parse(text = paste0("unit.pmax(", paste(paste0("plunit[[", seq_along(plunit), "]]"), collapse = ", "), ")")))
  return(lapply(pl, function(ipl) {
    ipl$widths[c(2:3, 5)] <- maxWidth
    return(ipl)
  }))
}

p.ManhattanJM <- plot_grid(plotlist = align.ggplot(plotlist), nrow = 2)
