# Here's a (simulated) experiment, with a single subject and 500 categorization trials.
all.data <- read.csv('experiment-data.csv')
source('memory-limited-exemplar-model.R')
rm(sample.data.set)
rm(sample.training.data)

# Use optim() to fit the model to this data.
# Note: In optim() you can tell it to display updates as it goes with:
# optim( ... , control=list(trace=4))

#linear.model.error <- function(parameters){
#  b <- parameters[1]
#  m <- parameters[2]
#  
#  predicted.y <- b + m*x
#  
#  sq.error <- (y - predicted.y)^2
#  rmse <- sqrt(mean(sq.error))
#  
# return(rmse)
#}

optim4data <- function(parameters){ 
  sensitivity <- parameters[1]
  decay.rate <- parameters[2]
      exemplar.memory.log.likelihood (all.data, sensitivity, decay.rate)
}

optim(c(1,1), optim4data, method="Nelder-Mead")

# Now try fitting a restricted version of the model, where we assume there is no decay.
# Fix the decay.rate parameter to 1, and use optim to fit the sensitivity parameter.
# Note that you will need to use method="Brent" in optim() instead of Nelder-Mead. 
# The brent method also requires an upper and lower boundary:
# optim( ..., upper=100, lower=0, method="Brent")

optim4data.fixed <- function(parameters){ 
  sensitivity <- parameters[1]
  exemplar.memory.log.likelihood (all.data, sensitivity, 1)
}

# optim4data.fixed (0.33)

optim(c(1), optim4data.fixed, upper=100, lower=0, method="Brent") #note: vector c only has one value instead of 2 because there is only one parameter this time

# What's the log likelihood of both models? (see the $value in the result of optiom(),
# remember this is the negative log likeihood, so multiply by -1.
#ANSWER:
#Log Likelihood of non-fixed model is 345.1454
#Log likelihood of fixed model is 1241.907


# What's the AIC and BIC for both models? Which model should we prefer?
#help(AIC)
#AIC(optim4data)
#AIC(optim4data, k=2)

#Akaike Information Criterion (AIC) = 2k - 2ln(L)
#Where k = the number of free parameters
#L = the maximum likelihood
#N = the sample size
k.aic.nonfixed <- 2
L.aic.nonfixed <- 345.1454
N.aic.nonfixed <- 500
answer.aic.nonfixed <- 2*2 - 2(log(345.1454))

answer.aic.nonfixed

k.aic.fixed <- 1
L.aic.fixed < 1241.907
N.aic.fixed <- 500
answer.aic.fixed <- 2*1 - 2(log(1241.907))

answer.aic.fixed

exp((AICbest - AICcomparison) / 2)

#Bayesian Information Criterion (BIC) = k*ln(N) - 2ln(L)
#Where k = the number of free parameters
#L = the maximum likelihood
#N = the sample size
k.bic.nonfixed <- 2
L.bic.nonfixed <- 345.1454
N.bic.nonfixed <- 500
answer.bic.nonfixed <- 2*log(500) - 2(log(345.1454))

answer.bic.nonfixed

k.bic.fixed <- 1
L.bic.fixed < 1241.907
N.bic.fixed <- 500
answer.bic.fixed <- 1*log(500) - 2(log(1241.907))



#### BONUS...
# If you complete this part I'll refund you a late day. You do not need to do this.

# Use parametric bootstrapping to estimate the uncertainty on the decay.rate parameter.
# Unfortunately the model takes too long to fit to generate a large bootstrapped sample in
# a reasonable time, so use a small sample size of 10-100 depending on how long you are
# willing to let your computer crunch the numbers.

# Steps for parametric bootstrapping:
# Use the best fitting parameters above to generate a new data set (in this case, that means
# a new set of values in the correct column for all.data).
# Fit the model to this new data, record the MLE for decay.rate.
# Repeat many times to get a distribution of decay.rate values.
# Usually you would then summarize with a 95% CI, but for our purposes you can just plot a
# histogram of the distribution.

