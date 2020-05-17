

# 5/16/12020
# absorbing matrix function with more than one absorbing states

p.absorbing.matrix = function(len.vector, absorbing.states){
  # this function takes a vector length V as an argument 
  # and makes a VxV matrix with random numbers 
  # and with one absorbing state
  m = list()
  
  for(k in 1:(len.vector)){ # len.vector - 1 in order to have a spare state for the absorbing state
    
    v = c(0, runif(1, 0, 1) )
    
    for(i in 1:(len.vector-1)){
      if(i == (len.vector)){append(v, 1-sum(v))}else(
        v = append(v, runif(1, 0, 1-sum(v))  ) )
    }
    # order randomly
    v.order = sample(1:len.vector, len.vector, replace = FALSE)
    v = v[order(v.order)]
    m[[k]] = v
  }
  # turn list m into a matrix m
  m = matrix(simplify2array(m), nrow = len.vector) 
  v.order = sample(1:len.vector, len.vector, replace = FALSE)
  m = m[,order(v.order)]  # randomly shuffle the columns
  
  #randomly decide which columns are the absorbing states, call it vector x
  x = sample(len.vector, absorbing.states, replace = FALSE)
  #m[x,] = 0
  m[,x] = 0
  for(j in 1:absorbing.states){m[x[j],x[j]] = 1}
  
  return( m )
}


# plot absorbing matrix results


len.vector = 10

ss = round(runif(len.vector, 1, 100 ))
s = ss
s
ll = list(s)

ntrials = 100
absorbing.states = 1

m = p.absorbing.matrix(len.vector, absorbing.states)

for(i in 2:ntrials){
  s = s %*% m # matrix multiplicatoin is %*%
  ll[[i]] = s
}

#plot s as a dataframe version of the simplified ll
df = as.data.frame(t(simplify2array(ll)))
df = cbind(c(1:ntrials), df)
cols = colorRampPalette(c("red", "yellow", "blue"))(len.vector-1)

x = which(m %in% 1)%%len.vector #find the column number in matrix m that is the absorbing state
x[which(x == 0)] = len.vector #if it is the last column, then this  modulo method  needs to be chanced to len.vector instead of 0
k = 1

for(i in 1:len.vector){
  
  if(k<=length(x)){if(i == x[k]){    
    plot(df$`c(1:ntrials)`, df[,i+1], # plot absorbing state with black dashes
         col = "black", pch = 16, cex = 0.8, ylim = c(0, max(ss)), ylab = "", xlab = "")
    par(new = TRUE); k = k+1; next}}
  
  if(i < len.vector){ # plot the other states with colorful symbols
    plot(df$`c(1:ntrials)`, df[,i+1], 
         col = cols[i], ylim = c(0, max(ss)), ylab = "", xlab = "")
    par(new = TRUE)
  }else( # last state doesn't have the par(new = TRUE) statement
    plot(df$`c(1:ntrials)`, df$V1, col = cols[i], 
         ylim = c(0, max(ss)), ylab = "", xlab = "")
  )
  
}

dev.off()
