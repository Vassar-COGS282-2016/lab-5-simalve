sample.training.data <- data.frame(x=c(0.5,0.6), y=c(0.4,0.3), category=c(1,2))

x.val <- 0.5
y.val <- 0.55
sensitivity <-0.8
sample.training.data$distance <- mapply(function(x,y){
  d <- sqrt((x-x.val)^2 + (y-y.val)^2)
  return(d)
}, sample.training.data$x, sample.training.data$y) 
sample.training.data$similarity <- exp(-sensitivity*sample.training.data$distance)
sample.training.data$similarity <- sapply(sample.training.data$distance, function(d){
  exp (-sensitivity*d)
})