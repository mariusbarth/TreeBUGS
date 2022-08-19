
test_that(
  "Latent-Mixture MPT"
  , {
    skip_on_cran()
    skip_on_travis()

    n_per_tree <- 240L

    set.seed(42L)
    data <- do.call(
      "rbind"
      , list(
        cl1 =  genTraitMPT(
          N = 100L
          , numItems = c(E = n_per_tree, N = n_per_tree, U = n_per_tree)
          , eqnfile = system.file("MPTmodels/2htsm.eqn", package = "TreeBUGS")
          , restrictions = list("D1 = D2 = D3", "d1 = d2", "b = g")
          , mean =  c(D1 = .8, d1 = .4, b = .5, a = .6)
          , sigma = c(D1 = .1, d1 = .2, b = .2, a = .2)
        )$data
        , cl2 = genTraitMPT(
          N = 20L
          , numItems = c(E = n_per_tree, N = n_per_tree, U = n_per_tree)
          , eqnfile = system.file("MPTmodels/2htsm.eqn", package = "TreeBUGS")
          , restrictions = list("D1 = D2 = D3", "d1 = d2", "b = g")
          , mean =  c(D1 = .4, d1 = .4, b = .5, a = .4)
          , sigma = c(D1 = .2, d1 = .2, b = .2, a = .2)
        )$data
      )
    )
    outMixture <- mixtureMPT(
      eqnfile = system.file("MPTmodels/2htsm.eqn", package = "TreeBUGS")
      , data = data
      , n.adapt = 1e4
      , n.burnin = 2e4
      , n.iter = 4e4
      , n.chains = 4L
      , H = 2
      , alpha = rep(2, 2)
      , orderedParameter = "D1"
      , restrictions = list("D1 = D2 = D3", "d1 = d2", "b = g")
    )
    summary(outMixture)

    theta <- getParam(outMixture, "theta")

    par(mfrow = c(2, 2))
    idx1 <- 1:100
    idx2 <- 101:120

    hist(theta[idx1, "a"], breaks = seq(.40, .60, .02))
    hist(theta[idx2, "a"], add = TRUE, col = "indianred3")

    hist(theta[idx1, "b"], breaks = seq(.40, .60, .02))
    hist(theta[idx2, "b"], add = TRUE, col = "indianred3")
    hist(theta[idx1, "d1"], breaks = seq(.20, .80, .02))
    hist(theta[idx2, "d1"], add = TRUE, col = "indianred3")
    hist(theta[idx1, "D1"], breaks = seq(.10, .50, .02))
    hist(theta[idx2, "D1"], add = TRUE, col = "indianred3")

  }
)











