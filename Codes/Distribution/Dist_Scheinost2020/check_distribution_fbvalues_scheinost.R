library(readxl)
library(rstatix)
library(DescTools)

rm(list = ls())
d<-read_excel("D:/Feedback_appraisal/Analysis/Distribution/Dist_Scheinost2020/fbvalues_scheinost.xlsx")

dsham = d[d$sham == "yes",]
dreal = d[d$sham == "no",]

hist(dreal$fb,100)
hist(dsham$fb,100) # should be the same and they are

# Normality
normality<-dreal %>%
  group_by(subj) %>%
  shapiro_test(fb)
data.frame(normality)

df = dreal[dreal$censored_trials != "censor",]

hist(df$fb,100)

d1 = d[d$subj == 17,]
hist(d1$fb,100)

df1 = df[df$subj == 17,]
hist(df1$fb,100)