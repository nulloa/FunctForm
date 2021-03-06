#' get_res_df
#' 
#' Use mcmc objects from package to get posterior estimates of theta
#'
#' @param y response variable used in mcmc
#' @param x explanatory variable used in mcmc
#' @param count n in binomial dist
#' @param group groups of response
#' @param mcmc.obj mcmc object
#' @param nsim number of simulation for which to make predictions (nsim < niter)
#' @param model.name name of the model associated with df
#'
#' @return data.frame
#'
#' @examples
#' 
#' 
#' 
#'
#' @export

get_res_df <- function(y, x, count, group, mcmc.obj, nsim, model.name){
  if(class(mcmc.obj)=="mcmc.list"){
    mcmc.obj <- do.call(rbind, mcmc.obj)
  }else{
    mcmc.obj <- do.call(rbind, coda::as.mcmc(mcmc.obj))
  }
  
  # Generate True mean theta 95 Credible intervals and est mean theta lines for each model
  PThetaEst  <- UpQ <- LwQ <- NULL
  
  # Get predictions and 95% Credible prediction intervals
  ypred <- UPpred <- LWpred <- PostPredSim <- NULL
  
  for (i in 1:length(y)){
    ####### Prediction and 95% PI for Y ######
    for(sim in 1:nsim){
      PostPredSim[sim] <- rbinom(1, count[i],  mcmc.obj[,c(paste("theta[", i, "]", sep=""))][nrow(mcmc.obj)-nsim+sim])
    }
    # Model 1 - ASG Indep
    ypred[i]  <- mean(PostPredSim)
    LWpred[i] <- quantile(PostPredSim, probs=c(.025))
    UPpred[i] <- quantile(PostPredSim, probs=c(.975))
    
    ####### Est and 95% CI for Theta ######
    # For Model 1 - ASG Indep
    LwQ[i]      <- quantile(mcmc.obj[,c(paste("theta[", i, "]", sep=""))],probs=c(.025))
    UpQ[i]      <- quantile(mcmc.obj[,c(paste("theta[", i, "]", sep=""))],probs=c(.975))
    PThetaEst[i] <- mean(mcmc.obj[,c(paste("theta[", i, "]", sep=""))])
  }
  
  
  # Create simplified data frame
  df <- data.frame(Prop = y/count,
                   nTot = count,
                   nILI = y,
                   Group = group,
                   Week = x,
                   Model = as.factor(c(rep(paste(model.name, sep=""),length(y)))),
                   PredY = c(ypred),
                   PYLB =  c(LWpred),
                   PYUB =  c(UPpred),
                   EstTheta = c(PThetaEst),
                   ThetaLB =  c(LwQ),
                   ThetaUB =  c(UpQ))
  return(df)
}