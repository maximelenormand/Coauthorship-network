library(scholar)
library(vecsets)

wd=""
setwd(wd)

# Load data
co=read.csv("Coauthors.csv", stringsAsFactors=FALSE) # Five columns: 
                                                     #    - ID: Unique integer node id. The first node is the central node around which is build the network. 
                                                     #    - Name: Full name of the author as it will appear on the final network
                                                     #    - Scholar: Google Scholar id
                                                     #    - Group: You can define different group of coauthors displayed in different colors
                                                     #    - W: Weight of the node that will be used to set the size of the circles. 
                                                     #         We will update the value according to the number of publis with the central node. 
nco=dim(co)[1] # Number of nodes                                    

# Load functions
simat=function(li, lj){ # Return a matrix of similarities between two vectors of character strings li and lj
                        # The element ij of the matrix is the fraction of letters in common between the ith string of li and the jth string of lj

    res=matrix(0,length(li),length(lj))
    for(i in 1:length(li)){
        for(j in 1:length(lj)){
 
            split1=unlist(strsplit(tolower(li[i]), ""))
            split2=unlist(strsplit(tolower(lj[j]), ""))
            res[i,j]=2*length(vintersect(split1,split2))/(nchar(tolower(li[i]))+nchar(tolower(lj[j]))) # Similarity metric     

        } 
    }    

    return(res)

}

duplipubli=function(li, threshold){ # Remove duplicated entries from the vector of character string li
                                    # Duplicated values identify with the similarity metric define in simat
                                    # The degree of similarity can be adjusted with a threshold value
    n=length(li)

    res=simat(li, li) # Compute similarity matrix to identify potential duplicated values

    # Remove iteratively the doublons (string with similarity metric higher than the defined threshold value)
    i=1
    test=(sum(res>threshold)>n)
    while(test){

        n=length(li)
        indupl=as.numeric(which(res[i,]>threshold))
        if(length(indupl)>1){
            li=li[-indupl[-1]] 
            res=res[-indupl[-1],-indupl[-1]]     
        }
      
        i=i+1 
        test=(sum(res>threshold)>n)
    }

    return(li)

}

intersectpubli=function(li, lj, threshold){ # Return the number of articles in common between two vector of character strings li and lj 
                                            # Articles in common identify with the similarity metric define in simat
                                            # The degree of similarity can be adjusted with a threshold value

    res=simat(li, lj)
  
    return(sum(res>threshold))

}

# Build network
net=NULL
for(i in 1:(nco-2)){

    # Extract list of articles of scholar i
    idi=co[i,3]
    li=get_publications(idi, cstart = 0, pagesize = 100, flush = FALSE)
    li=li[!is.na(li$year),]   # Remove articles without publication year
    li=as.character(li$title)
    li=duplipubli(li, threshold=0.95)  # Remove doublons
    Sys.sleep(1)

    for(j in (i+1):nco){

        # Extract list of articles of scholar j
        idj=co[j,3]
        lj=get_publications(idj, cstart = 0, pagesize = 100, flush = FALSE)
        lj=lj[!is.na(lj$year),]   # Remove articles without publication year
        lj=as.character(lj$title)   
        lj=duplipubli(lj, threshold=0.95)  # Remove doublons
        Sys.sleep(1)

        # Add the number of articles in common between scholar i and j to the network
        net=rbind(net, c(co[i,1], co[j,1], intersectpubli(li,lj, threshold=0.95)))
        
    }

}

# Set node weight W according to the number of publis in common with the central node
co[1,5]=get_num_articles(co[1,3])   # If central node: Number of publis of central node 
co[2:40,5]=net[1:39,3]              # Otherwise: Number of publis in common between the central node and the others

# Clean network for network3D
co=co[,c(2,4,5)]
colnames(co)=c("name","group","size")

net=net[net[,3]>0,]
colnames(net)=c("source","target","value")

# Export network
write.csv2(co, "co.csv", row.names=FALSE, fileEncoding="UTF-8")
write.csv2(net, "net.csv", row.names=FALSE, fileEncoding="UTF-8")








