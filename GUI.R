install.packages("gWidgets")
require(gWidgets)
options(guiToolkit="RGtk2")

window = gwindow("File search", visible = FALSE)

paned = gpanedgroup(cont = window)

group = ggroup(cont = paned, horizontal = FALSE)

glabel("Search for (filename):", cont=group, anchor=c(-1,0))
txt_pattern = gedit("", initial.msg = "Possibly wildcards", cont = group)

glabel("Search in:", cont=group, anchor=c(-1,0))
start_dir = gfilebrowse(text = "Specify a directory", quote = FALSE
                        , type = "selectdir", cont=group)

visible(window) = TRUE