#' Fit a latent-mixture MPT
#'
#' fits a latent-mixture MPT
#'
#' @param H Integer. Number of components
#' @param alpha Numeric. Parameters alpha of the dirichlet distribution of component weights.
#' @param orderedParameter Character.
#'
#' @export

mixtureMPT <- function(
  eqnfile,
  data,
  restrictions,
  covData,
  predStructure,
  predType,  # one of: c("c," f", "r")
  transformedParameters,
  corProbit = TRUE,
  # hyperpriors:
  mu = "dnorm(0,1)",
  xi = "dunif(0,.7)",
  alpha,
  V,
  df,
  IVprec = "dgamma(.5,.5)",
  H = 2L,
  orderedParameter = 1L,
  # MCMC stuff:
  n.iter = 20000,
  n.adapt = 2000,
  n.burnin = 2000,
  n.thin = 5,
  n.chains = 3,
  dic = FALSE,
  ppp = 0,
  # File Handling stuff:
  modelfilename,
  parEstFile,
  posteriorFile,
  autojags = NULL,
  ...
){

  if(missing(V)) V <- NULL
  if(missing(df)) df <- NULL
  if(missing(alpha) || is.null(alpha)) alpha <- rep(2, H)

  hyperprior <- list(
    mu = mu, xi = xi, V = V,
    df = df, IVprec = IVprec,
    H = H, orderedParameter = orderedParameter, alpha = alpha)

  fitModel(type="mixtureMPT", eqnfile=eqnfile,
           data=data,restrictions=restrictions,
           covData=covData,
           predStructure=predStructure,
           predType=predType,    # c("c," f", "r")
           transformedParameters=transformedParameters,
           corProbit=corProbit,
           hyperprior=hyperprior,
           n.iter=n.iter,
           n.adapt = n.adapt,
           n.burnin=n.burnin,
           n.thin=n.thin,
           n.chains=n.chains,
           dic =dic,
           ppp = ppp,
           modelfilename=modelfilename,
           parEstFile=parEstFile,
           posteriorFile=posteriorFile,
           autojags=autojags,
           call = match.call(),
           ...)
}
