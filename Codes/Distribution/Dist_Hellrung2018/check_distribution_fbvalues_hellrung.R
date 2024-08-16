library(readxl)
library(rstatix)
library(DescTools)

rm(list = ls())
d<-read_excel("D:/Feedback_appraisal/Analysis/Distribution/Dist_Hellrung2018/fbvalues_hellrung.xlsx")

hist(d$fb,20)

d_subj = d[d$subj == "6",]
hist(d_subj$fb,100)

df = d[d$censored_trials != "censor",]

df_subj = df[df$subj == "6",]
hist(df_subj$fb,100)

d1 = d[d$mode == "happy",]
d2 = d[d$mode == "count",]

hist(d1$fb)
hist(d2$fb)

# Normality
normality<-d1 %>%
  group_by(subj) %>%
  shapiro_test(fb)
data.frame(normality)

normality<-d2 %>%
  group_by(subj) %>%
  shapiro_test(fb)
data.frame(normality)

d_subj = d[d$subj == "16",]
hist(d_subj$fb,100)
t.test(fb ~ mode, data = d_subj, paired = TRUE)

# distributions for count and happy are different for subjs 4 9 11 18 

d_subjHappy = d_subj[d_subj$mode == "happy",]
d_subjCount = d_subj[d_subj$mode == "count",]
hist(d_subjHappy$fb)
shapiro.test(d_subjHappy$fb)
hist(d_subjCount$fb)
shapiro.test(d_subjCount$fb)
