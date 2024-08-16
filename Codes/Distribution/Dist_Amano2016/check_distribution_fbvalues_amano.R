library(readxl)
library(rstatix)
library(DescTools)

rm(list = ls())
d<-read_excel("D:/Feedback_reward/Analysis/Distribution/Dist_Amano2016/fbvalues_amano.xlsx")

hist(d$fb,100)

# Normality
normality<-d %>%
  group_by(subj) %>%
  shapiro_test(fb)
data.frame(normality)

d1 = d[d$subj == "2",]
h=hist(d1$fb,100)

df = d[d$censored_trials != "censor",]
hist(df$fb,100)

normality<-df %>%
  group_by(subj) %>%
  shapiro_test(fb)
data.frame(normality)

df1 = df[df$subj == "2",]
h=hist(df1$fb,100)
shapiro.test(df1$fb)

count=h$counts
count=count[count!=0]

count>mean(count)+3*sd(count)
d1 = d1[d1$fb > .05,]
d1 = d1[d1$fb < .95,]


h=hist(d1$fb,100)
shapiro.test(d1$fb)

mean(h$counts)
median(h$counts)
