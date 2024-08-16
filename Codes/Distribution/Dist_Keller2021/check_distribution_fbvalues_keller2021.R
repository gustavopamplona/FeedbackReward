library(readxl)
library(rstatix)
library(DescTools)

rm(list = ls())
d<-read_excel("D:/Feedback_appraisal/Analysis/Distribution/Dist_Keller2021/fbvalues_keller2021.xlsx")

hist(d$fb,100)

dL = d[d$mode == "left",]
hist(dL$fb)

dR = d[d$mode == "right",]
hist(dR$fb)

# Normality
normality<-d %>%
  group_by(subj) %>%
  shapiro_test(fb)
data.frame(normality)

df = d[d$censored_trials != "censor",]

normality<-df %>%
  group_by(subj) %>%
  shapiro_test(fb)
data.frame(normality)

hist(df$fb,100)

d1 = df[df$subj == "5",]
hist(d1$fb,100)
