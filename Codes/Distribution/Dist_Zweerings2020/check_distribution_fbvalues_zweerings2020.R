library(readxl)
library(rstatix)
library(DescTools)

rm(list = ls())
d<-read_excel("D:/Feedback_appraisal/Analysis/Distribution/Dist_Zweerings2020/fbvalues_zweerings2020.xlsx")

hist(d$fb)

# Normality
normality<-d %>%
  group_by(subj) %>%
  shapiro_test(fb)
data.frame(normality)

df = d[d$censored_trials != "censor",]
hist(df$fb)

d1 = d[d$subj == "1",]
df1 = df[df$subj == "1",]
hist(d1$fb)
hist(df1$fb)
