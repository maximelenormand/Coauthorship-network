# Function that removes near-duplicate strings from a list
# li: vector of character strings
# threshold: similarity threshold above which two strings are considered 
#            duplicates
duplipubli = function(li, threshold){
  
  # Number of strings
  n = length(li)
  
  # Similarity matrix between all pairs of strings
  res = matrix(0, n, n)
  
  # Compute pairwise similarity scores
  for(i in 1:n){
    for(j in 1:n){
      
      # Split strings into lowercase characters
      split1 = unlist(strsplit(tolower(li[i]), ""))
      split2 = unlist(strsplit(tolower(li[j]), ""))
      
      # Similarity score based on character overlap
      # (Dice coefficient–like measure)
      res[i, j] = 2 * length(vintersect(split1, split2)) /
        (nchar(tolower(li[i])) + nchar(tolower(li[j])))
    }
  }
  
  # Index used to scan through the similarity matrix
  i = 1
  
  # Test if there are more similarities above the threshold than expected
  test = (sum(res > threshold) > n)
  
  # Loop until no excessive duplicates remain
  while(test){
    
    n = length(li)
    
    # Indices of strings similar to the i-th string above the threshold
    indupl = as.numeric(which(res[i, ] > threshold))
    
    # If more than one similar string is found
    if(length(indupl) > 1){
      
      # Remove duplicate strings (keep the first one)
      li = li[-indupl[-1]]
      
      # Remove corresponding rows and columns from the similarity matrix
      res = res[-indupl[-1], -indupl[-1]]
    }
    
    # Move to the next string
    i = i + 1
    
    # Re-evaluate stopping condition
    test = (sum(res > threshold) > n)
  }
  
  # Return the filtered list of strings
  li
  
}

# Function that counts how many string pairs between two lists
# are similar above a given threshold
# li: first vector of character strings
# lj: second vector of character strings
# threshold: similarity threshold
intersectpubli = function(li, lj, threshold){
  
  # Similarity matrix between li and lj
  res = matrix(0, length(li), length(lj))
  
  # Compute similarity for each pair of strings
  for(ki in 1:length(li)){
    for(kj in 1:length(lj)){
      
      # Split strings into lowercase characters
      split1 = unlist(strsplit(tolower(li[ki]), ""))
      split2 = unlist(strsplit(tolower(lj[kj]), ""))
      
      # If no common characters, similarity is zero
      if(length(intersect(split1, split2)) == 0){
        res[ki, kj] = 0
      } else {
        # Otherwise compute similarity score
        res[ki, kj] = 2 * length(vintersect(split1, split2)) /
          (nchar(tolower(li[ki])) + nchar(tolower(lj[kj])))
      }
    }
  }
  
  # Return the number of pairs with similarity above the threshold
  sum(res > threshold)
}

