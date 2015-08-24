# LPR.R
# Rijksuniversiteit Groningen
# Faculty of Economics and Business
# Graduate School -SOM-
# Research Master in Economics and Business
# Learning and practising research
# Prof. Marco Haan
# Student: Hugo Renato Vargas Aldana (s.2045427)
# Supervisor: Prof. Dr. Erik Dietzenbacher
# Impact of demographic change on energy use in a 
# developing country: an Input-Output approach

# Clean the workspace
rm(list=ls())

# Load the matrices with the basic Supply and Use data.
# Note that vectors are loaded as matrices since the csv
# data already has the desired orientation and that eases
# calculations later on.

# Note that since the original work was done in MATLAB
# the matrices don't have column or row names. R can have names
# and do the calculations, after which the correct commodity
# or industry name will remain, which is useful for future
# reference.

# output
x <- as.matrix(read.csv("/Users/renato/Documents/02Study/01_RM-RUG/LPR/data/Matrices/x.csv", header=FALSE, dec=".", sep=",", comment.char="\""))

# commodity use vector
q <- as.matrix(read.csv("/Users/renato/Documents/02Study/01_RM-RUG/LPR/data/Matrices/q.csv", header=FALSE, dec=".", sep=",", comment.char="\""))

# Use matrix
U <- as.matrix(read.csv("/Users/renato/Documents/02Study/01_RM-RUG/LPR/data/Matrices/U.csv", header=FALSE, dec=".", sep=",", comment.char="\""))

# Make matrix
V <- as.matrix(read.csv("/Users/renato/Documents/02Study/01_RM-RUG/LPR/data/Matrices/V.csv", header=FALSE, dec=".", sep=",", comment.char="\""))

# Final demand X 15 years (corrected for urban/rural)
corrsim_e <- as.matrix(read.csv("/Users/renato/Documents/02Study/01_RM-RUG/LPR/data/Matrices/corrsim_e.csv", header=FALSE, dec=".", sep=",", comment.char="\""))

# Final demand X 15 years (uncorrected for urban/rural)
uncorrsim_e <- as.matrix(read.csv("/Users/renato/Documents/02Study/01_RM-RUG/LPR/data/Matrices/uncorrsim_e.csv", header=FALSE, dec=".", sep=",", comment.char="\""))

# Energy use coefficients ("M_p" in the paper)
effi_ener <- as.matrix(read.csv("/Users/renato/Documents/02Study/01_RM-RUG/LPR/data/Matrices/effi_ener.csv", header=FALSE, dec=".", sep=",", comment.char="\""))

# Since vectors are loaded as matrices, when creating "hat"
# diagonal vectors we make a half-step to turn them to vectors.
# Otherwise we obtain weird outcomes.

xv <- as.vector(x)
qv <- as.vector(q)

# We create the diagonal of industry output and commodity use
xhat <- diag(xv)
qhat <- diag(qv)

# Then we create the equivalents of A: B and D.

B = U %*% solve(xhat)
D = V %*% solve(qhat)

# We also need two identity matrices 
# of commodity and industry size
I219 <- diag(219)
I123 <- diag(123)

# We solve our model for the corrected and uncorrected cases
# and we obtain simulated output.
xt1 <- (solve(I123 - (D%*%B)) %*% D) %*% corrsim_e
xt2 <- (solve(I123 - (D%*%B)) %*% D) %*% uncorrsim_e

# Finally we premultiply that output with the energy coefficients
# to obtain energy use by energy commodity for 15 years.
Ep <- effi_ener %*% xt1
Epb <- effi_ener %*% xt2

# And export it to something Excel can read.
write.csv(Ep, file = "/Users/renato/Documents/02Study/01_RM-RUG/LPR/data/Matrices/Ep.csv", fileEncoding = "macroman")
write.csv(Ep, file = "/Users/renato/Documents/02Study/01_RM-RUG/LPR/data/Matrices/Epb.csv", fileEncoding = "macroman")
