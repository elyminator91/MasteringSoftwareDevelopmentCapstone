
geom_timeline <- function(mapping = NULL, data = NULL, stat = "identity",
                          position = "identity", na.rm = FALSE,
                          show.legend = NA, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = GeomTimeline, mapping = mapping,
    data = data, stat = stat, position = position,
    show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

GeomTimeline <- ggplot2::ggproto("GeomTimeline", Geom,
                                 required_aes = c("x"),
                                 default_aes = ggplot2::aes(shape = 21, colour = "black", alpha = 0.5),
                                 draw_key = ggplot2::draw_key_point,
                                 draw_panel = function(data, panel_scales, coord) {
                                   
                                   ## Transform the data first
                                   coords <- coord$transform(data, panel_scales)
                                   
                                   ## Construct a grid grob
                                   points <- grid::pointsGrob(
                                     x = coords$x,
                                     y = coords$y,
                                     pch = coords$shape,
                                     gp = grid::gpar(fill = coords$colour,
                                                     alpha = coords$alpha)
                                   )
                                   
                                   axes <- grid::polylineGrob(x = unit(c(0, 1), "npc"),
                                                              y = unit(c(0.5, 0.5), "npc"),
                                                              id=NULL, id.lengths=NULL,
                                                              default.units = "npc",
                                                              arrow = NULL, name = NULL,
                                                              gp=grid::gpar(col = "black"), 
                                                              vp = NULL)
                                   
                                   # y_lines <- unique(coords$y)
                                   # 
                                   # 
                                   # ## Construct line grob
                                   # lines <- grid::polylineGrob(
                                   #   x = unit(rep(c(0, 1), each = length(y_lines)), "npc"),
                                   #   y = unit(c(y_lines, y_lines), "npc"),
                                   #   id = rep(seq_along(y_lines), 2),
                                   #   gp = grid::gpar(col = "grey",
                                   #                   lwd = .pt)
                                   # )
                                   # 
                                   grid::gList(points, axes)
                                 })