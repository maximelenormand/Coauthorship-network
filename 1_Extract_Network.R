# Packages
library(scholar)
library(vecsets)

# Working directory
#wd=""
#setwd(wd)

# Load data
co=read.csv2("Coauthors.csv", stringsAsFactors=FALSE)
nco=dim(co)[1]

# Load functions
duplipubli=function(li, threshold){

    n=length(li)

    res=matrix(0,n,n)
    for(i in 1:n){
        for(j in 1:n){
 
            split1=unlist(strsplit(tolower(li[i]), ""))
            split2=unlist(strsplit(tolower(li[j]), ""))
            res[i,j]=2*length(vintersect(split1,split2))/(nchar(tolower(li[i]))+nchar(tolower(li[j])))      

        } 
    }

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

    li

}

intersectpubli=function(li, lj, threshold){

    res=matrix(0,length(li),length(lj))
    for(ki in 1:length(li)){
        for(kj in 1:length(lj)){
 
            split1=unlist(strsplit(tolower(li[ki]), ""))
            split2=unlist(strsplit(tolower(lj[kj]), ""))
            if(length(intersect(split1,split2))==0){
               res[ki,kj]=0
            }else{
               res[ki,kj]=2*length(vintersect(split1,split2))/(nchar(tolower(li[ki]))+nchar(tolower(lj[kj])))      
            }  
        } 
    }    

    sum(res>threshold)

}

# Build network
net=NULL
for(i in 1:(nco-2)){

    idi=co[i,3]
    nbi=get_num_articles(idi)
    Sys.sleep(2)
    li=get_publications(idi, cstart = 0, pagesize = 100, flush = FALSE)
    li=li[!is.na(li$year),]
    li=as.character(li$title)
    #li=as.character(li$pubid)
    #li=li[!duplicated(li)]
    li=duplipubli(li, threshold=0.95)
    Sys.sleep(1)
    
    #tabi=cbind(li,lit)

    print(c(i,length(li),nbi))

    for(j in (i+1):nco){

        idj=co[j,3]
        nbj=get_num_articles(idj)
        Sys.sleep(2)
        lj=get_publications(idj, cstart = 0, pagesize = 100, flush = FALSE)
        lj=lj[!is.na(lj$year),]
        lj=as.character(lj$title)
        #lj=as.character(lj$pubid)
        #lj=lj[!duplicated(lj)]
        lj=duplipubli(lj, threshold=0.95)
        Sys.sleep(1)

        print(c("     ", j, length(lj), nbj))

        #tabj=cbind(lj,ljt)
        #int=intersect(li,lj)
        
        net=rbind(net, c(co[i,1], co[j,1], intersectpubli(li,lj, threshold=0.95)))
        #net=rbind(net, c(co[i,1], co[j,1], length(intersect(li,lj))))
        
    }
}

net=net[!duplicated(paste0(net[,1],"_", net[,2], "_", net[,3])),]

# Clean network
co[1,5]=get_num_articles(co[1,3])
co[2:40,5]=net[1:39,3]
co=co[,c(2,4,5)]
colnames(co)=c("name","group","size")

net=net[net[,3]>0,]
colnames(net)=c("source","target","value")

# Export network
write.csv2(co, "co.csv", row.names=FALSE, fileEncoding="UTF-8")
write.csv2(net, "net.csv", row.names=FALSE, fileEncoding="UTF-8")








