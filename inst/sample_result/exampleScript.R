# Install the package
devtools::install_github("https://github.com/xindizhang/SigAct.git")

# Assign files
sigActPoints <- system.file("extdata", "sigActPoints.csv", package = "SigAct")
changepoints <- system.file("extdata", "changepoints.txt", package = "SigAct")
phis <- system.file("extdata", "phis.txt", package = "SigAct")

# Generate plot for sinhle sample
sinResult <- MutSig(sigActPoints, changepoints, phis)
# display the plot
sinResult[[1]]

# Print all the signatures in the sample and their proposed etiology
signatures <- sinResult[[2]]
for (signature in signatures){
  cat(sprintf("%s\n\n", sigProposedEtiology(signature)))
}

# Plot for two samples in chronological order
sigActPoints2 <- system.file("extdata", "sigActPoints2.csv", package = "SigAct")
changepoints2 <- system.file("extdata", "changepoints2.txt", package = "SigAct")
phis2 <- system.file("extdata", "phis2.txt", package = "SigAct")
MutSig(sigActPoints, changepoints, phis, sigActPoints2, changepoints2, phis2)

# [END]
