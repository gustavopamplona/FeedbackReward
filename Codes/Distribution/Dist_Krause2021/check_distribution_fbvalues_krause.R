library(readxl)
library(rstatix)
library(DescTools)

rm(list = ls())
d<-read_excel("D:/Feedback_appraisal/Analysis/Distribution/Dist_Krause2021/fbvalues_krause.xlsx")

d1 = d[d$mode == "up",]
d2 = d[d$mode == "down",]

hist(d1$fb,100)
hist(d2$fb,100)

# Normality
normality<-d1 %>%
  group_by(subj) %>%
  shapiro_test(fb)
data.frame(normality)

normality<-d2 %>%
  group_by(subj) %>%
  shapiro_test(fb)
data.frame(normality)

df = d[d$censored_trials != "censor",]

df1 = df[df$mode == "up",]
df2 = df[df$mode == "down",]

hist(df1$fb,100)
hist(df2$fb,100)

# Normality
normality<-df1 %>%
  group_by(subj) %>%
  shapiro_test(fb)
data.frame(normality)

normality<-df2 %>%
  group_by(subj) %>%
  shapiro_test(fb)
data.frame(normality)



subject="9"
d_subj = d[d$subj == subject,]
d_subj = d_subj[d_subj$mode == "down",]
hist(d_subj$fb)
shapiro.test(d_subj$fb)

# distributions are not normal in upregulation for subjects 3, 4, 6, 7, 9
# distributions are not normal in upregulation for subjects 3, 6, 8, 9, 10