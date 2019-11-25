library(TreeBUGS)

# load("data/arnold2013.RData")


n_per_tree <- 240

data <- do.call(
  "rbind"
  , list(
    cl1 =  genTraitMPT(
      N = 100
      , numItems = c(E = n_per_tree, N = n_per_tree, U = n_per_tree)
      , eqnfile = system.file("MPTmodels/2htsm.eqn", package = "TreeBUGS")
      , restrictions = list("D1 = D2 = D3", "d1 = d2")
      , mean = c(D1 = .2, d1 = .6, b = .5, g = .5, a = .7)
    )$data
    , cl2 = genTraitMPT(
      N = 5
      , numItems = c(E = n_per_tree, N = n_per_tree, U = n_per_tree)
      , eqnfile = system.file("MPTmodels/2htsm.eqn", package = "TreeBUGS")
      , restrictions = list("D1 = D2 = D3", "d1 = d2")
      , mean = c(D1 = 0, d1 = 0, b = .5, g = .5, a = 0)
    )$data
    # , cl3 = genTraitMPT(
    #   N = 30
    #   , numItems = c(E = n_per_tree, N = n_per_tree, U = n_per_tree)
    #   , eqnfile = system.file("MPTmodels/2htsm.eqn", package = "TreeBUGS")
    #   , restrictions = list("D1 = D2 = D3", "d1 = d2")
    #   , mean = c(D1 = .4, d1 = .2, b = .4, g = .6, a = .5)
    # )$data
  )
)
data <- as.data.frame(data)

outTrait <- traitMPT(
  eqnfile = system.file("MPTmodels/2htsm.eqn", package = "TreeBUGS")
  , data = data
  , restrictions = list("D1 = D2 = D3", "d1 = d2")
)


outMixture <- mixtureMPT(
  eqnfile = system.file("MPTmodels/2htsm.eqn", package = "TreeBUGS")
  , data = data
  # , inits = initfun
  , n.adapt = 5e3
  , n.burnin = 1e4
  , n.iter = 2e4
  , n.chains = 4L
  , H = 2
  , alpha = rep(5, 2)
  , orderedParameter = "D1"
  , restrictions = list("D1 = D2 = D3", "d1 = d2", "b = g")
)
outMixture <- extendMPT(outMixture, n.adapt = 5e3)
#
# outMixture3 <- mixtureMPT(
#   eqnfile = system.file("MPTmodels/2htsm.eqn", package = "TreeBUGS")
#   , data = data
#   , inits = initfun
#   , n.adapt = 5e3
#   , n.burnin = 1e4
#   , n.iter = 2e4
#   , n.chains = 4L
#   , H = 3L
#   , s_ordered = 3
#   , restrictions = list("D1 = D2 = D3", "d1 = d2")
# )

# outMixture$summary$groupParameters
# library(runjags)
# failed.jags()
# outMixture$mcmc.summ[c("pi[11,1]", "pi[11,2]"), ]
# outMixture$mcmc.summ[c("sigma[1,1]", "sigma[1,2]"), ]
# outMixture$mcmc.summ[c("phi["), ]
# outMixture$mptInfo
# coda::traceplot(out$runjags$mcmc)
# outMixture$runjags$model

