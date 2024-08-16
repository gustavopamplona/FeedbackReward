library(readxl)
library(rstatix)
library(DescTools)

rm(list = ls())
d<-read_excel("D:/Feedback_appraisal/Analysis/Distribution/Dist_Zweerings2019/fbvalues_zweerings2019.xlsx")

hist(d$fb,100)

d = d[d$subj != "33",]

d1 = d[d$mode == "up",]
hist(d1$fb)

d1 = d[d$mode == "down",]
hist(d1$fb)

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

d2 = df[df$subj == "4",]
hist(d2$fb,100)

h=hist(d1$fb,100)

count=h$counts
count=count[count!=0]

count>mean(count)+3*sd(count)
d1 = d1[d1$fb != "1",]
d1 = d1[d1$fb != "100",]
