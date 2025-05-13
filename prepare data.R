
# This R scripts entails all data preparation for the lab.
# You can have a look in case you are interested.




# The first line sets an option for the final document that can be produced from
# the .Rmd file. Don't worry about it.
knitr::opts_chunk$set(echo = TRUE)

# First you define which packages you need for your analysis and assign it to 
# the p_needed object. 
p_needed <-
  c("viridis", "knitr", "MASS", "pROC", "nnet", "mlogit", "foreign")

# Now you check which packages are already installed on your computer.
# The function installed.packages() returns a vector with all the installed 
# packages.
packages <- rownames(installed.packages())
# Then you check which of the packages you need are not installed on your 
# computer yet. Essentially you compare the vector p_needed with the vector
# packages. The result of this comparison is assigned to p_to_install.
p_to_install <- p_needed[!(p_needed %in% packages)]
# If at least one element is in p_to_install you then install those missing
# packages.
if (length(p_to_install) > 0) {
  install.packages(p_to_install)
}
# Now that all packages are installed on the computer, you can load them for
# this project. Additionally the expression returns whether the packages were
# successfully loaded.
sapply(p_needed, require, character.only = TRUE)



dta_raw <- haven::read_dta("raw-data/clean_macro.dta")

dta <- 
  data.frame("country" = dta_raw$country,
             "year" = dta_raw$year, 
             "vote_share_cab" = dta_raw$vote_share_cab,
             "vote_share_cab_tmin1" = dta_raw$vote_share_cab_tmin1,
             "satislfe_survey_mean" = dta_raw$satislfe_survey_mean,
             "parties_ingov" = dta_raw$parties_ingov,
             "seatshare_cabinet" = dta_raw$seatshare_cabinet,
             "cab_ideol_sd" = dta_raw$cab_ideol_sd,
             "ENEP_tmin1" = dta_raw$ENEP_tmin1)

dta <- dta[complete.cases(dta),]

save(dta, file = "raw-data/ward_macro.Rdata")



##### Nested Data Examples ######

nested_ex1 <- 
  data.frame("state" = rep(c("state 1", "state 2"), each = 6),
             "district" = rep(paste("district", 1:3), each = 2),
             "voter_id" = as.factor(1:12),
             "vote_choice" = paste("party", 
                                   sample(c("A", "B", "C", "D"), 12, 
                                          replace = T)))

save(nested_ex1, file = "raw-data/nested_ex1.Rdata")

nested_ex2 <- 
  data.frame("wave" = rep(1:3, each = 3),
             "respondent_id" = rep(1:3, 3),
             "ideology" = c(1, 4, 4,
                            2, 4, 6,
                            3, 4, 5))

save(nested_ex2, file = "raw-data/nested_ex2.Rdata")



###### FE Data ########

set.seed(1)

n <- 20

c1 <- runif(n, -2, 2)
c2 <- runif(n, -1.5, 2.5)
c3 <- runif(n, -1, 3)
c4 <- runif(n, -0.5, 3.5)

fe <- c(6, 4, 2, 0)
b <- 1

y_c1 <- rnorm(n, fe[1] + b*c1, sd = 0.6)
y_c2 <- rnorm(n, fe[2] + b*c2, sd = 0.6)
y_c3 <- rnorm(n, fe[3] + b*c3, sd = 0.6)
y_c4 <- rnorm(n, fe[4] + b*c4, sd = 0.6)

fe_ex <- data.frame("x" = c(c1, c2, c3, c4),
                    "y" = c(y_c1, y_c2, y_c3, y_c4),
                    "unit" = rep(1:4, each = n))

save(fe_ex, file = "raw-data/fe_ex.Rdata")
