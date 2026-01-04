# Load packages
library(networkD3)

# Working directory
wd="/home/maxime/mmmycloud/Web/Site/Network/2026"
setwd(wd)

# Load data
net=read.csv2("net.csv", stringsAsFactors=FALSE)
net=net[dim(net)[1]:1,]
co=read.csv2("co.csv", stringsAsFactors=FALSE)
co[1,3]=30

# Color edges
colo=rep("lightgrey",dim(net)[1])

# Plot
G=forceNetwork(Links=net, Nodes=co, NodeID = "name", Group = "group",
        
        # Custom nodes and labels
        Nodesize="size",                                                    # column names that gives the size of nodes
        radiusCalculation = JS("d.nodesize/2+5"),                           # How to use this column to calculate radius of nodes? (Java script expression)
        opacity = 1,                                                        # Opacity of nodes when you hover it
        opacityNoHover = 0,                                                 # Opacity of nodes you do not hover
        colourScale = JS("d3.scaleOrdinal(d3.schemeCategory20);"),          # Javascript expression, schemeCategory10 and schemeCategory20 work
        fontSize = 20,                                                      # Font size of labels
        fontFamily = "sans serif",                                          # Font family for labels
 
        # Custom edges
        Value="value",
        arrows = FALSE,                                                     # Add arrows?
        linkColour = colo,                                                  # colour of edges
        linkWidth = JS("function(d) { return Math.sqrt(d.value); }"),       # edges width
 
        # layout
        linkDistance = 100,                                                 # link size, if higher, more space between nodes
        charge = -30,                                                       # if highly negative, more space between nodes
                
        # -- general parameters
        height = NULL,                                                      # height of frame area in pixels
        width = NULL,
        zoom = FALSE,                                                       # Can you zoom on the figure
        legend = FALSE,                                                     # add a legend?
        bounded = TRUE, 
        clickAction = NULL
)

# Export
# IF PROBLEM WITH PANDOC
# sudo ln -s /usr/lib/rstudio/bin/pandoc/pandoc /usr/local/bin
# sudo ln -s /usr/lib/rstudio/bin/pandoc/pandoc-citeproc /usr/local/bin
htmlwidgets::saveWidget(G,"Coauthorship.html")


