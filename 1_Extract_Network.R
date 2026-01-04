# Load packages
library(scholar)
library(vecsets)

# Working directory
#setwd(wd)

# Load data
co=read.csv2("Coauthors.csv", stringsAsFactors=FALSE)
nco=dim(co)[1]

# Load functions
source("utils.R")

# ================================
# Build the collaboration network
# ================================

# Initialize empty network object
net = NULL

# Loop over all authors except the last two
for(i in 1:(nco - 2)){
  
  # Get identifier of author i
  idi = co[i, 3]
  
  # Total number of articles for author i (from external source)
  nbi = get_num_articles(idi)
  
  # Pause to avoid overloading the API
  Sys.sleep(2)
  
  # Retrieve publications of author i
  li = get_publications(idi, cstart = 0, pagesize = 100, flush = FALSE)
  
  # Keep only publications with a known year
  li = li[!is.na(li$year), ]
  
  # Extract titles as character vector
  li = as.character(li$title)
  
  # Remove near-duplicate titles
  li = duplipubli(li, threshold = 0.95)
  
  # Short pause between API calls
  Sys.sleep(1)
  
  # Print progress: index, number of unique titles, total articles
  print(c(i, length(li), nbi))
  
  # Compare author i with all following authors
  for(j in (i + 1):nco){
    
    # Get identifier of author j
    idj = co[j, 3]
    
    # Total number of articles for author j
    nbj = get_num_articles(idj)
    
    # Pause to avoid API rate limits
    Sys.sleep(2)
    
    # Retrieve publications of author j
    lj = get_publications(idj, cstart = 0, pagesize = 100, flush = FALSE)
    
    # Keep only publications with a known year
    lj = lj[!is.na(lj$year), ]
    
    # Extract titles as character vector
    lj = as.character(lj$title)
    
    # Remove near-duplicate titles
    lj = duplipubli(lj, threshold = 0.95)
    
    # Short pause between API calls
    Sys.sleep(1)
    
    # Print progress for author j
    print(c("     ", j, length(lj), nbj))
    
    # Add an edge to the network:
    # source = author i
    # target = author j
    # value  = number of similar publications (above threshold)
    net = rbind(net, c(co[i, 1], co[j, 1], 
                       intersectpubli(li, lj, threshold = 0.95))
    )
  }
}

# Remove duplicate edges (same source, target, and value)
net = net[!duplicated(paste0(net[,1], "_", net[,2], "_", net[,3])), ]

# ==============================
# Clean and format network data
# ==============================

# Set node size for the first author using total number of articles
co[1, 5] = get_num_articles(co[1, 3])

# Set node sizes for remaining authors using the first column of edge weights
co[2:40, 5] = net[1:39, 3]

# Keep only relevant columns: name, group, and size
co = co[, c(2, 4, 5)]
colnames(co) = c("name", "group", "size")

# Keep only edges with at least one shared publication
net = net[net[,3] > 0, ]
colnames(net) = c("source", "target", "value")

# Export files
write.csv2(co, "co.csv", row.names = FALSE, fileEncoding = "UTF-8")
write.csv2(net, "net.csv", row.names = FALSE, fileEncoding = "UTF-8")






