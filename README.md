# Building coauthorship networks with R

## Description

This repository contains two R scripts for creating and visualizing coauthorship
networks. It focuses on an egonetwork centered around a single scholar (me in 
this example). The nodes of the network represent my coauthors (people with whom 
I have published at least one paper), and the links between two coauthors are 
proportional to the number of papers they have co-signed (if any).

## Scripts

**1_Extract_Network** scrapes data from Google Scholar using the R package 
[scholar](https://cran.r-project.org/web/packages/scholar/index.html) to build 
the network. It takes as input the file ***Coauthors.csv*** (an example with my 
coauthors) and returns two files, ***co.csv*** and ***net.csv***, representing 
the nodes and links of the coauthorship network, respectively.

**2_Draw_Network** takes as input ***co.csv*** and ***net.csv*** produced by the 
first script and relies on the package 
[networkD3](https://cran.r-project.org/web/packages/networkD3/index.html) 
to produce the file ***Coauthorship.html***, which can be used to interactively 
visualize the network.

If you need help, find a bug, or want to give me advice or feedback, please contact me!

## Repository mirrors

This repository is mirrored on both GitLab and GitHub. You can access it via the following links:

- **GitLab**: [https://gitlab.com/maximelenormand/coauthorship-network](https://gitlab.com/maximelenormand/coauthorship-network)  
- **GitHub**: [https://github.com/maximelenormand/coauthorship-network](https://github.com/maximelenormand/coauthorship-network)  

The repository is archived in Software Heritage:

[![SWH](https://archive.softwareheritage.org/badge/origin/https://github.com/maximelenormand/coauthorship-network/)](https://archive.softwareheritage.org/browse/origin/?origin_url=https://github.com/maximelenormand/coauthorship-network)

