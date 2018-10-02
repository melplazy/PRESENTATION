library(tidyverse)
library(gganimate)
library(grid)
devtools::source_url('https://github.com/mcanouil/DEV/raw/master/Rfunctions/theme_black.R')
theme_set(theme_black(base_size = 14))

data_arrows <- tribble(
  ~x, ~y, ~xend, ~yend, ~step,
  
  0.15, 1, 0.85, 1, 2,
  0.15, 1, 0.85, 1, 3,
  0.15, 1, 0.85, 1, 4,
  0.15, 1, 0.85, 1, 5,
  0.15, 1, 0.85, 1, 6,
  0.15, 1, 0.85, 1, 7,
  0.15, 1, 0.85, 1, 8,
  
  1.15, 1, 1.85, 0.55, 4,
  1.15, 1, 1.85, 0.55, 8,
  
  1.15, 0, 1.85, 0.45, 5,
  1.15, 0, 1.85, 0.45, 7,
  1.15, 0, 1.85, 0.45, 8,
  
  1, 0.1, 1, 0.9, 6,
  1, 0.1, 1, 0.9, 7,
  1, 0.1, 1, 0.9, 8
)
data_labels <- tribble(
  ~x, ~y, ~label, ~colour, ~step,
  1, 1, "Y(t)", 1, 1,
  2, 0.5, "S", 1, 1,
  1, 0, "Z", 1, 1,
  
  0, 1, "Y(t)", 1, 2,
  1, 1, "X(t)", 1, 2,
  2, 0.5, "T2D", 1, 2,
  1, 0, "SNP", 1, 2,
  0.5, 1.1, "epsilon", 2, 2,
  
  0, 1, "FG[obs]", 1, 3,
  1, 1, "FG[true]", 1, 3,
  2, 0.5, "T2D", 1, 3,
  1, 0, "SNP", 1, 3,
  0.5, 1.1, "epsilon", 2, 3,
  
  0, 1, "FG[obs]", 1, 4,
  1, 1, "FG[true]", 1, 4,
  2, 0.5, "T2D", 1, 4,
  1, 0, "SNP", 1, 4,
  0.5, 1.1, "epsilon", 2, 4,
  1.5, 0.9, "beta", 2, 4,
  
  0, 1, "FG[obs]", 1, 5,
  1, 1, "FG[true]", 1, 5,
  2, 0.5, "T2D", 1, 5,
  1, 0, "SNP", 1, 5,
  0.5, 1.1, "epsilon", 2, 5,
  1.5, 0.10, "alpha", 2, 5,
  
  0, 1, "FG[obs]", 1, 6,
  1, 1, "FG[true]", 1, 6,
  2, 0.5, "T2D", 1, 6,
  1, 0, "SNP", 1, 6,
  0.5, 1.1, "epsilon", 2, 6,
  0.9, 0.5, "gamma", 2, 6,
  
  0, 1, "FG[obs]", 1, 7,
  1, 1, "FG[true]", 1, 7,
  2, 0.5, "T2D", 1, 7,
  1, 0, "SNP", 1, 7,
  0.5, 1.1, "epsilon", 2, 7,
  0.9, 0.5, "gamma", 2, 7,
  1.5, 0.10, "alpha", 2, 7,
  
  0, 1, "FG[obs]", 1, 8,
  1, 1, "FG[true]", 1, 8,
  2, 0.5, "T2D", 1, 8,
  1, 0, "SNP", 1, 8,
  0.5, 1.1, "epsilon", 2, 8,
  1.5, 0.10, "alpha", 2, 8,
  0.9, 0.5, "gamma", 2, 8,
  1.5, 0.9, "beta", 2, 8
)
p <- ggplot() +
  theme(
    panel.grid = element_blank(), 
    axis.title = element_blank(), 
    axis.text = element_blank(), 
    axis.ticks = element_blank(), 
    panel.border = element_blank(),
    legend.position = "none"
  ) +
  geom_segment(
    data = data_arrows,
    mapping = aes(x = x, xend = xend, y = y,  yend = yend),
    colour = "white",
    arrow = arrow(length = unit(8, "point"), type = "closed"),
    lineend = "round",
    linejoin = "round"
  ) +
  geom_text(
    data = data_labels, 
    mapping = aes(x = x, y = y, label = label, colour = factor(colour)), 
    size = 6,
    parse = TRUE
  ) +
  scale_x_continuous(expand = expand_scale(mult = 0.2)) +
  scale_y_continuous(expand = expand_scale(mult = 0.2)) +
  scale_colour_viridis_d()

p + facet_wrap(~step)

p +
  transition_states(
    step,
    transition_length = 0,
    state_length = 5,
      wrap = FALSE
  )


animate(
  plot = p +
    transition_states(
      step,
      transition_length = 0,
      state_length = 7,
      wrap = FALSE
    ), 
  width = 400, 
  height = 225, 
  units = "px", 
  bg = ggplot2::theme_get()$plot.background$colour,
  renderer = gifski_renderer(
    loop = FALSE,
    file = "./images/joint_model.gif"
  )
)




ffmpeg_renderer <- function (
  file = NULL, format = "mp4", ffmpeg = NULL, options = list(pix_fmt = "yuv420p")
) {
  ffmpeg <- ffmpeg %||% "ffmpeg"
  tryCatch(suppressWarnings(system2(ffmpeg, "-version", stdout = FALSE, 
    stderr = FALSE)), error = function(e) {
    stop("The ffmpeg library is not available at the specified location", 
      call. = FALSE)
  })
  if (!is.null(options)) {
    if (is.list(options)) {
      if (is.null(names(options))) {
        stop("options list must be named", call. = FALSE)
      }
      opt_name <- paste0("-", sub("^-", "", names(options)))
      opts <- vapply(options, paste, character(1), collapse = " ")
      options <- paste(paste0(opt_name, " ", opts), collapse = " ")
    }
  } else {
    options = ""
  }
  stopifnot(is.character(options))
  function(frames, fps) {
    if (is.null(file)) {
      output_file <- tempfile(fileext = paste0(".", sub("^\\.", "", format)))
    } else {
      output_file <- file
    }
    frame_loc <- dirname(frames[1])
    file_glob <- sub("^.*(\\..+$)", "%*\\1", basename(frames[1]))
    file_glob <- file.path(frame_loc, file_glob)
    system2(
      ffmpeg, c(
        paste0("-i ", file_glob), 
        "-y", 
        "-loglevel quiet", 
        paste0("-framerate ", 1/fps), 
        "-hide_banner", 
        options, 
        output_file
      )
    )
    print(paste(ffmpeg, paste(c(
        paste0("-i ", file_glob), 
        "-y", 
        "-loglevel quiet", 
        paste0("-framerate ", 1/fps), 
        "-hide_banner", 
        options, 
        output_file
      ), collapse = " ")))
    if (format == "gif") {
      gif_file(output_file)
    } else {
      video_file(output_file)
    }
  }
}

options(gganimate.dev_args = list())
animate(
  plot = p +
    transition_states(
      step,
      transition_length = 0,
      state_length = 25,
      wrap = FALSE
    ), 
  width = 400, 
  height = 225,
  bg = ggplot2::theme_get()$plot.background$colour,
  renderer = ffmpeg_renderer(
    file = "./images/joint_model.mp4",
    options = list(pix_fmt = "yuv444p")
  )
)
