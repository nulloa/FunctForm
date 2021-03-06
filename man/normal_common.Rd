% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/normal_common.R
\name{normal_common}
\alias{normal_common}
\title{normal_common}
\usage{
normal_common(y, x, count, group, priors, niter = 2000, nchains = 3,
  nclusters = nchains, burnin = niter/2, thin = 10)
}
\arguments{
\item{y}{response variable which follows binomial dist}

\item{x}{explanatory variable}

\item{count}{n in binomial dist}

\item{group}{groups of response}

\item{priors}{list of priors}

\item{niter}{number of interations to be run (default=2000)}

\item{nchains}{number of chains to be run (default=3)}

\item{nclusters}{number of clusters to be used (default=nchains)}

\item{burnin}{number of samples to be used as burnin (technically adaption, see link below)}

\item{thin}{when you want to thin (default=10)}
}
\value{
A MCMC object
}
\description{
Runs Asymmetric Gaussian MCMC with a common mean structure accross the groups
}
\examples{
priors <- list()
priors$vm <- 10
priors$mx <- 15
priors$vs <- 10


}
\seealso{
\url{http://www.mikemeredith.net/blog/2016/Adapt_or_burn.htm}
}
