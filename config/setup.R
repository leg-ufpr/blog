library(knitr)
opts_chunk$set(cache =  FALSE,
               tidy = FALSE,
               fig.width = 6,
               fig.height = 6,
               fig.align = "center",
               eval.after= "fig.cap",
               # dpi = 96,
               dev.args = list(family = "Helvetica"))

library(captioner)

# Figure and table numbers.
tbn_ <- captioner(prefix = "Tabela")
fgn_ <- captioner(prefix = "Figura")

# Figure and table labels.
tbl_ <- function(label) tbn_(label, display = "cite")
fgl_ <- function(label) fgn_(label, display = "cite")
