Building a coauthorship network with R
===================================================================================

This repository contains two scripts written in R for the creation and visualization of coauthorship networks. It focus on an egonetwork centered around one scholar (me in the example). The nodes of the network are my coauthors (people with whom I published at least one paper) and the link between two coauthors is proportional to the number of papers they cosigned (if any). We will first scrap data from Google Scholar using the R package **scholar** to build the network and then rely on the package **networkD3** to visualize it. **ExtractNetwork** scraps data from Google Scholar using the R package **scholar** to build the network and **DrawNetwork** relies on the package **networkD3** to visualize it.
  
If you want more details feel free to visit [this post](http://www.maximelenormand.com/Blog/coauthorship).

If you need help, find a bug, want to give me advice or feedback, please contact me!
You can reach me at maxime.lenormand[at]irstea.fr
