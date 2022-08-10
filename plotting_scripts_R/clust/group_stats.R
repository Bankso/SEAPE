library(caret)

# Used to check difference in groups with non-normal distributions, though normalcy can be assumed for large groups
# Input data has been min-max scaled as per mscaler function in pre-processing
wilcox.test(mmmat$`10s`, nmmat$`10s`, exact = FALSE, paired = FALSE, alternative = "greater")
wilcox.test(mmmat$`20s`, nmmat$`20s`, exact = FALSE, paired = FALSE, alternative = "greater")
wilcox.test(mmmat$`60s`, nmmat$`60s`, exact = FALSE, paired = FALSE, alternative = "greater")

#Normalize the data, if it wasn't normalized already
pnsmomat <- preProcess(smomat, method = "range")
nsmomat <- predict(pnsmomat, smomat)

#Standardize the data, should be done if you want to use a t-test since it assumes normally distributed data
ssmomat <- scale(smomat[, c(2:4)])
mssmomat <- cbind(smomat[, "motif"], ssmomat)
#t-test to check if groups have significantly different means after normalizing
t.test(`10s` ~ V1, data = mssmomat, paired = FALSE)
t.test(`20s` ~ V1, data = mssmomat, paired = FALSE)
t.test(`60s` ~ V1, data = mssmomat, paired = FALSE)
