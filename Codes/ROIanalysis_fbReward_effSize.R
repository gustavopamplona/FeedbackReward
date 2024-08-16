############################# ROI analysis - Feedback reward - effect size

rm(list = ls())

# library(lme4)
# # install.packages("lmerTest")
# library(lmerTest)
# # install.packages("plyr")
# #install.packages("psych")
# library(psych)
# #install.packages("yhat")
# library(yhat)
# library(tibble)
# #install.packages("forestplot")
# library(forestplot)
# library(dplyr)
# library(car)
# library(stats)

# library(readxl)
sourceFolder = "D:/Feedback_reward/Analysis/ROI_analysis/tables/"
study_str=c("Pamplona", "Scheinost", "Amano")
model = 1
roi = 2

data = c()
for (i in 1:length(study_str)) {
  new_data = read_excel(paste0(sourceFolder, "table_model", as.character(model), "_roi", as.character(roi), "_", study_str[i], ".xlsx"))  
  if (i == 3){
    new_data = subset(new_data, select = -tValue)
  }
  data = rbind(data,new_data)
}

# data$effSize = data$effSize

# ddply(data, .(study), colwise(sd))
# mean(data$effSize)

# data=data[data$study!='scheinost',]
data=na.omit(data)

# library(plyr)
ddply(data, .(study), colwise(mean))

# qqPlot(data$effSize, dist = "norm")
# shapiro.test(data$effSize)
# hist(data$effSize,25)

# library(ggpubr)
ggplot(data, aes(x=study, y=contrast))+
  geom_boxplot(aes(fill = study))

data$study = as.factor(data$study)

m1=lm(contrast ~ 1 + study, data = data, contrasts = list(study= contr.sum))
summary(m1)
# m2=lm(contrast ~ 1, data = data)
# summary(m2)
confint(m1, level = 0.995)

# p.adjust(p, method = "BH", n = length(p))

m1 = lmer(effSize ~ 1 + (1|study), data = data)
summary(m1)
# 
# df=data[data$study=='krause',]
# t.test(data$contrast)
# 
# anova(m1)
# sd(df$contrast)
# 
# df$study = as.factor(df$study)
# 
# m2 = lmer(contrast ~ 1, data = df)
# summary(m2)

######### Forest plot

### MODEL 1
   
base_data <- tibble(mean  = c(0.21,                   0.10,                0.05,                0.31,                 -0.08,                0.03,                -0.02,                      0.24,                        0.02,                             0.17,                        0.07), 
                    lower = c(-0.08,                  -0.18,               -0.23,               0.04,                 -0.33,                -0.25,               -0.42,                      -0.18,                       -0.34,                            -0.17,                       -0.23),
                    upper = c(0.50,                   0.38,                0.33,                0.58,                 0.17,                 0.33,                0.39,                       0.66,                        0.38,                             0.51,                        0.37),
                    roi = c("Caudate nucleus",        "Putamen",          "Thalamus",           "Nucleus accumbens*", "Subgenual ACC",      "Anterior insula",   "Medial prefrontal cortex", "Posterior cingulate gyrus", "Dorsolateral prefrontal cortex", "Posterior parietal cortex", "Lateral occipital cortex"),
                    estimate = c("0.21 [-0.08,0.50]", "0.10 [-0.18,0.38]", "0.05 [-0.23,0.33]", "0.31 [0.04,0.58]",   "-0.08 [-0.33,0.17]", "0.03 [-0.25,0.33]", "-0.02 [-0.42,0.39]",       "0.24 [-0.24,0.66]",         "0.02 [-0.34,0.38]",              "0.17 [-0.17,0.51]",         "0.07 [-0.23,0.37]"))

header <- tibble(roi = c("", "ROI"),
                 estimate = c("", "Estimate [CI]"),
                 summary = FALSE)

styles <- fpShapesGp(
  lines = list(
    gpar(col = ""),
    gpar(col = ""),
    gpar(col = "gray"), #1
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray")
  ),
  box = list(
    gpar(fill = ""),
    gpar(fill = ""),
    gpar(fill = "grey"), #1
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "darkred"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey")
  ) 
)

empty_row <- tibble(mean = NA_real_)

feedback_output_df <- bind_rows(header,
                                base_data,
                                empty_row)

jpeg("D:/Feedback_reward/Analysis/ROI_analysis/figures/ROIanalysis_model1.jpg", width = 17.5, height = 17.5, units = "cm", res = 700)
feedback_output_df %>% 
  forestplot(labeltext = c(roi, estimate),
             is.summary = c(rep(TRUE, 2), rep(FALSE, 16)),
             boxsize = 0.3,
             xlab = 'Parameter estimates with adj. 95% confidence interval
(FDR corrected). * indicates significance',
             shapes_gp = styles,
             vertices = TRUE,
             txt_gp = fpTxtGp(ticks = gpar(fontfamily = "", cex = .7),
                              xlab  = gpar(fontfamily = "", cex = .7)))
dev.off()

### MODEL 2

base_data <- tibble(mean  = c(-0.25,                   -0.07,                -0.05,                -0.11,                -0.10,                -0.11,                      0.14,                        -0.30,                            -0.30,                       0.10),
                    lower = c(-0.72,                   -0.39,                -0.36,                -0.44,                -0.46,                -0.60,                      -0.24,                       -0.66,                            -0.71,                       -0.34),
                    upper = c(0.22,                    0.25,                 0.26,                 0.22,                 0.26,                 0.37,                       0.52,                        0.07,                             0.11,                        0.55),
                    roi = c("Caudate nucleus",         "Putamen",            "Thalamus",           "Subgenual ACC",      "Anterior insula",    "Medial prefrontal cortex", "Posterior cingulate gyrus", "Dorsolateral prefrontal cortex", "Posterior parietal cortex", "Lateral occipital cortex"),
                    estimate = c("-0.25 [-0.72,0.22]", "-0.07 [-0.39,0.25]", "-0.05 [-0.36,0.26]", "-0.11 [-0.44,0.22]", "-0.10 [-0.46,0.26]", "-0.11 [-0.60,0.37]",       "0.14 [-0.24,0.52]",         "-0.30 [-0.66,0.07]",             "-0.30 [-0.71,0.11]",        "0.10 [-0.34,0.55]"))

header <- tibble(roi = c("", "ROI"),
                 estimate = c("", "Estimate [CI]"),
                 summary = FALSE)

styles <- fpShapesGp(
  lines = list(
    gpar(col = ""),
    gpar(col = ""),
    gpar(col = "gray"), #1
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "")
  ),
  box = list(
    gpar(fill = ""),
    gpar(fill = ""),
    gpar(fill = "grey"), #1
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "")
  ) 
)

empty_row <- tibble(mean = NA_real_)

feedback_output_df <- bind_rows(header,
                                base_data,
                                empty_row)

jpeg("D:/Feedback_reward/Analysis/ROI_analysis/figures/ROIanalysis_model2.jpg", width = 17.5, height = 17.5, units = "cm", res = 700)
feedback_output_df %>% 
  forestplot(labeltext = c(roi, estimate),
             is.summary = c(rep(TRUE, 2), rep(FALSE, 16)),
             boxsize = 0.3,
             xlab = 'Parameter estimates with adj. 95% confidence interval
(Bonferroni corrected). * indicates significance',
             shapes_gp = styles,
             vertices = TRUE,
             txt_gp = fpTxtGp(ticks = gpar(fontfamily = "", cex = .7),
                              xlab  = gpar(fontfamily = "", cex = .7)))
dev.off()


### MODEL 3

base_data <- tibble(mean  = c(-0.19,                   -0.32,                 -0.23,                0.07,                 0.01,                -0.17,                -0.08,                      0.02,                        -0.14,                            -0.32,                       -0.19), 
                    lower = c(-0.45,                   -0.62,                 -0.51,                -0.16,                 -0.21,               -0.41,                -0.37,                      -0.32,                       -0.40,                            -0.64,                       -0.51),
                    upper = c(0.08,                    -0.02,                 0.05,                 0.30,                  0.22,                0.07,                 0.20,                       0.35,                        0.12,                             -0.0038,                     0.12),
                    roi = c("Caudate nucleus",         "Putamen*",             "Thalamus",           "Nucleus accumbens",   "Subgenual ACC",     "Anterior insula",    "Medial prefrontal cortex", "Posterior cingulate gyrus", "Dorsolateral prefrontal cortex", "Posterior parietal cortex*", "Lateral occipital cortex"),
                    estimate = c("-0.19 [-0.45,0.08]", "-0.32 [-0.62,-0.02]", "-0.23 [-0.51,0.05]", "0.07 [-0.16,0.30]",  "0.01 [-0.21,0.22]", "-0.17 [-0.41,0.07]", "-0.08 [-0.37,0.20]",       "0.02 [-0.32,0.35]",         "0.14 [-0.40,0.12]",              "0.32 [-0.64,-0.004]",       "-0.19 [-0.51,0.12]"))

header <- tibble(roi = c("", "ROI"),
                 estimate = c("", "Estimate [CI]"),
                 summary = FALSE)

styles <- fpShapesGp(
  lines = list(
    gpar(col = ""),
    gpar(col = ""),
    gpar(col = "gray"), #1
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "")
  ),
  box = list(
    gpar(fill = ""),
    gpar(fill = ""),
    gpar(fill = "grey"), #1
    gpar(fill = "darkblue"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "darkblue"),
    gpar(fill = "grey"),
    gpar(fill = "")
  ) 
)

empty_row <- tibble(mean = NA_real_)

feedback_output_df <- bind_rows(header,
                                base_data,
                                empty_row)

jpeg("D:/Feedback_reward/Analysis/ROI_analysis/figures/ROIanalysis_model3.jpg", width = 17.5, height = 17.5, units = "cm", res = 700)
feedback_output_df %>% 
  forestplot(labeltext = c(roi, estimate),
             is.summary = c(rep(TRUE, 2), rep(FALSE, 16)),
             boxsize = 0.3,
             xlab = 'Parameter estimates with adj. 95% confidence interval
(FDR corrected). * indicates significance',
             shapes_gp = styles,
             vertices = TRUE,
             # xticks=c(-0.2,-0.1,0,.1,.2,.3,.4),
             txt_gp = fpTxtGp(ticks = gpar(fontfamily = "", cex = .7),
                              xlab  = gpar(fontfamily = "", cex = .7)))
dev.off()


### MODEL 4

base_data <- tibble(mean  = c(-0.13,                   -0.19,                -0.26,                -0.22,                -0.26,                -0.04,                -0.08,                      -0.18,                       -0.60,                        -0.30), 
                    lower = c(-0.46,                   -0.55,                -0.63,                -0.54,                -0.60,                -0.38,                -0.56,                      -0.55,                       -1.03,                        -0.69),
                    upper = c(0.20,                    0.17,                 0.11,                 0.10,                 0.08,                 0.30,                 0.40,                       0.19,                        -0.17,                        0.09),
                    roi = c("Caudate nucleus",         "Putamen",            "Thalamus",           "Nucleus accumbens",  "Subgenual ACC",      "Anterior insula",    "Medial prefrontal cortex", "Posterior cingulate gyrus", "Posterior parietal cortex*", "Lateral occipital cortex"),
                    estimate = c("-0.13 [-0.46,0.20]", "-0.19 [-0.55,0.17]", "-0.26 [-0.63,0.11]", "-0.22 [-0.54,0.10]", "-0.26 [-0.60,0.08]", "-0.04 [-0.38,0.30]", "-0.08 [-0.56,0.40]",       "-0.18 [-0.55,0.19]",        "-0.60 [-1.03,-0.17]",        "-0.30 [-0.69,0.09]"))

header <- tibble(roi = c("", "ROI"),
                 estimate = c("", "Estimate [CI]"),
                 summary = FALSE)

styles <- fpShapesGp(
  lines = list(
    gpar(col = ""),
    gpar(col = ""),
    gpar(col = "gray"), #1
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "")
  ),
  box = list(
    gpar(fill = ""),
    gpar(fill = ""),
    gpar(fill = "grey"), #1
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "darkblue"),
    gpar(fill = "grey"),
    gpar(fill = "")
  ) 
)

empty_row <- tibble(mean = NA_real_)

feedback_output_df <- bind_rows(header,
                                base_data,
                                empty_row)

jpeg("D:/Feedback_reward/Analysis/ROI_analysis/figures/ROIanalysis_model4.jpg", width = 17.5, height = 17.5, units = "cm", res = 700)
feedback_output_df %>% 
  forestplot(labeltext = c(roi, estimate),
             is.summary = c(rep(TRUE, 2), rep(FALSE, 15)),
             boxsize = 0.3,
             xlab = 'Parameter estimates with adj. 95% confidence interval
(FDR corrected). * indicates significance',
             shapes_gp = styles,
             vertices = TRUE,
             # xticks=c(-0.2,-0.1,0,.1,.2,.3,.4),
             txt_gp = fpTxtGp(ticks = gpar(fontfamily = "", cex = .7),
                              xlab  = gpar(fontfamily = "", cex = .7)))
dev.off()


######### Forest plot

### MODEL 1

base_data <- tibble(mean  = c(0.53266,                0.92,               0.57,                0.95,                 0.21,                0.47,                0.12,                 0.04,                0.42,                0.47,                0.61,                    0.57,                       1.12,                        0.68,                             0.95,                         0.40), 
                    lower = c(-0.30,                  0.10,               -0.24,               0.17,                 -0.51,               -0.34,               -0.79,                -0.78,               -0.32,               -0.20,               -0.13,                   -0.60,                      -0.07,                       -0.34,                            0.03,                         -0.46),
                    upper = c(1.36,                   1.73,               1.37,                1.72,                 0.93,                1.28,                1.03,                 0.87,                1.15,                1.14,                1.34,                    1.73,                       2.31,                        1.70,                             1.87,                         1.25),
                    roi = c("Caudate nucleus",        "Putamen*",         "Thalamus",          "Nucleus accumbens*", "ACC, subgenual",    "ACC, rostral",    "ACC, supracallosal", "Anterior insula",   "Posterior insula",  "Substantia nigra",  "Parahippocampal gyrus", "Medial prefrontal cortex", "Posterior cingulate gyrus", "Dorsolateral prefrontal cortex", "Posterior parietal cortex*", "Lateral occipital cortex"),
                    estimate = c("0.53 [-0.30,1.36]", "0.92 [0.10,1.73]", "0.57 [-0.24,1.37]", "0.95 [0.17,1.72]",   "0.21 [-0.51,0.93]", "0.47 [-0.34,1.28]", "0.12 [-0.79,1.03]",  "0.04 [-0.78,0.87]", "0.42 [-0.32,1.15]", "0.47 [-0.20,1.14]", "0.61 [-0.13,1.34]",     "0.57 [-0.60,1.73]",        "1.12 [-0.07,2.31]",         "0.68 [-0.34,1.70]",              "0.95 [0.03,1.87]",           "0.40 [-0.46,1.25]"))

header <- tibble(roi = c("", "ROI"),
                 estimate = c("", "Estimate [CI]"),
                 summary = FALSE)

styles <- fpShapesGp(
  lines = list(
    gpar(col = ""),
    gpar(col = ""),
    gpar(col = "gray"), #1
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray")
  ),
  box = list(
    gpar(fill = ""),
    gpar(fill = ""),
    gpar(fill = "grey"), #1
    gpar(fill = "darkred"),
    gpar(fill = "grey"),
    gpar(fill = "darkred"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "darkred"),
    gpar(fill = "grey"),
    gpar(fill = "grey")
  ) 
)

empty_row <- tibble(mean = NA_real_)

feedback_output_df <- bind_rows(header,
                                base_data,
                                empty_row)

jpeg("D:/Feedback_reward/Analysis/ROI_analysis/figures/ROIanalysis_model1.jpg", width = 17.5, height = 17.5, units = "cm", res = 700)
feedback_output_df %>% 
  forestplot(labeltext = c(roi, estimate),
             is.summary = c(rep(TRUE, 2), rep(FALSE, 16)),
             boxsize = 0.3,
             xlab = 'Parameter estimates with adj. 95% confidence interval
(FDR corrected). * indicates significance',
             shapes_gp = styles,
             vertices = TRUE,
             txt_gp = fpTxtGp(ticks = gpar(fontfamily = "", cex = .7),
                              xlab  = gpar(fontfamily = "", cex = .7)))
dev.off()

### MODEL 2

base_data <- tibble(mean  = c(-1.23,                    0.15,                0.08,                -0.51,                -1.84,                 -1.39,                 -0.98,                 -1.97,                 1.74,                0.70,                     -1.78,                       0.46,                        -1.59,                             -1.02,                        0.74), 
                    lower = c(-2.30,                    -0.58,               -0.63,               -1.27,                -2.73,                 -2.32,                 -1.81,                 -2.85,                 0.62,                0.03,                     -2.90,                       -0.40,                       -2.43,                             -1.88,                        -0.28),
                    upper = c(-0.15,                    0.89,                0.79,                0.24,                 -0.96,                 -0.45,                 -0.15,                 -1.09,                 2.86,                1.38,                     -0.67,                       1.33,                        -0.74,                             -0.16,                        1.76),
                    roi = c("Caudate nucleus*",         "Putamen",           "Thalamus",          "ACC, subgenual",     "ACC, rostral*",       "ACC, supracallosal*", "Anterior insula*",    "Posterior insula*",   "Substantia nigra*", "Parahippocampal gyrus*", "Medial prefrontal cortex*", "Posterior cingulate gyrus", "Dorsolateral prefrontal cortex*", "Posterior parietal cortex*", "Lateral occipital cortex"),
                    estimate = c("-1.23 [-2.30,-0.15]", "0.15 [-0.58,0.89]", "0.08 [-0.63,0.79]", "-0.51 [-1.27,0.24]", "-1.84 [-2.73,-0.96]", "-1.39 [-2.32,-0.45]", "-0.98 [-1.81,-0.15]", "-1.97 [-2.85,-1.09]", "1.74 [0.62,2.86]",  "0.70 [0.03,1.38]",       "-1.78 [-2.90,-0.67]",       "0.46 [-0.40,1.33]",         "-1.59 [-2.43,-0.74]",             "-1.02 [-1.88,-0.16]",        "0.74 [-0.28,1.76]"))

header <- tibble(roi = c("", "ROI"),
                 estimate = c("", "Estimate [CI]"),
                 summary = FALSE)

styles <- fpShapesGp(
  lines = list(
    gpar(col = ""),
    gpar(col = ""),
    gpar(col = "gray"), #1
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "")
  ),
  box = list(
    gpar(fill = ""),
    gpar(fill = ""),
    gpar(fill = "darkblue"), #1
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "darkblue"),
    gpar(fill = "darkblue"),
    gpar(fill = "darkblue"),
    gpar(fill = "darkblue"),
    gpar(fill = "darkred"),
    gpar(fill = "darkred"),
    gpar(fill = "darkblue"),
    gpar(fill = "grey"),
    gpar(fill = "darkblue"),
    gpar(fill = "darkblue"),
    gpar(fill = "grey"),
    gpar(fill = "")
  ) 
)

empty_row <- tibble(mean = NA_real_)

feedback_output_df <- bind_rows(header,
                                base_data,
                                empty_row)

jpeg("D:/Feedback_reward/Analysis/ROI_analysis/figures/ROIanalysis_model2.jpg", width = 17.5, height = 17.5, units = "cm", res = 700)
feedback_output_df %>% 
  forestplot(labeltext = c(roi, estimate),
             is.summary = c(rep(TRUE, 2), rep(FALSE, 16)),
             boxsize = 0.3,
             xlab = 'Parameter estimates with adj. 95% confidence interval
(FDR corrected). * indicates significance',
             shapes_gp = styles,
             vertices = TRUE,
             txt_gp = fpTxtGp(ticks = gpar(fontfamily = "", cex = .7),
                              xlab  = gpar(fontfamily = "", cex = .7)))
dev.off()


### MODEL 3

base_data <- tibble(mean  = c(-0.53,                   -0.05,                -0.03,                -0.74,                 -0.17,                -0.45,                -0.19,                 -0.03,                -0.22,                -0.11,                -0.06,                   -0.30,                      -0.26,                       0.20,                             0.07,                        -0.10), 
                    lower = c(-1.46,                   -1.12,                -1.03,                -1.57,                 -0.94,                -1.21,                -1.09,                 -0.89,                -1.09,                -0.91,                -0.85,                   -1.33,                      -1.43,                       -0.72,                            -0.99,                       -1.22),
                    upper = c(0.41,                    1.01,                 0.97,                 0.08,                  0.60,                 0.30,                 0.70,                  0.83,                 0.64,                 0.69,                 0.72,                    0.74,                       0.92,                        1.13,                             1.12,                        1.03),
                    roi = c("Caudate nucleus",         "Putamen",            "Thalamus",           "Nucleus accumbens",   "ACC, subgenual",     "ACC, pregenual",     "ACC, supracallosal",  "Anterior insula",    "Posterior insula",   "Substantia nigra",   "Parahippocampal gyrus", "Medial prefrontal cortex", "Posterior cingulate gyrus", "Dorsolateral prefrontal cortex", "Posterior parietal cortex", "Lateral occipital cortex"),
                    estimate = c("-0.53 [-1.46,0.41]", "-0.05 [-1.12,1.01]", "-0.03 [-1.03,0.97]", "-0.74 [-1.57,0.08]",  "-0.17 [-0.94,0.60]", "-0.45 [-1.21,0.30]", "-0.19 [-1.09,0.70]",  "-0.03 [-0.89,0.83]", "-0.22 [-1.09,0.64]", "-0.11 [-0.91,0.69]", "-0.06 [-0.85,0.72]",    "-0.30 [-1.33,0.74]",       "-0.26 [-1.43,0.92]",        "0.20 [-0.72,1.13]",              "0.07 [-0.99,1.12]",         "-0.10 [-1.22,1.03]"))

header <- tibble(roi = c("", "ROI"),
                 estimate = c("", "Estimate [CI]"),
                 summary = FALSE)

styles <- fpShapesGp(
  lines = list(
    gpar(col = ""),
    gpar(col = ""),
    gpar(col = "gray"), #1
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "")
  ),
  box = list(
    gpar(fill = ""),
    gpar(fill = ""),
    gpar(fill = "grey"), #1
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "grey"),
    gpar(fill = "")
  ) 
)

empty_row <- tibble(mean = NA_real_)

feedback_output_df <- bind_rows(header,
                                base_data,
                                empty_row)

jpeg("D:/Feedback_reward/Analysis/ROI_analysis/figures/ROIanalysis_model3.jpg", width = 17.5, height = 17.5, units = "cm", res = 700)
feedback_output_df %>% 
  forestplot(labeltext = c(roi, estimate),
             is.summary = c(rep(TRUE, 2), rep(FALSE, 16)),
             boxsize = 0.3,
             xlab = 'Parameter estimates with adj. 95% confidence interval
(Bonferroni corrected). * indicates significance',
             shapes_gp = styles,
             vertices = TRUE,
             # xticks=c(-0.2,-0.1,0,.1,.2,.3,.4),
             txt_gp = fpTxtGp(ticks = gpar(fontfamily = "", cex = .7),
                              xlab  = gpar(fontfamily = "", cex = .7)))
dev.off()


### MODEL 4

base_data <- tibble(mean  = c(1.44,                  1.27,               0.55,                1.81,                 2.49,               1.17,               0.70,                 1.31,               1.33,                0.69,                1.07,                     1.42,                        0.45,                        1.68,                         0.43), 
                    lower = c(0.68,                  0.45,               -0.29,               1.08,                 1.71,               0.33,               0.14,                 0.53,               0.59,                -0.14,               0.26,                     0.32,                        -0.39,                       0.77,                         -0.46),
                    upper = c(2.19,                  2.09,               1.40,                2.54,                 3.26,               2.01,               1.53,                 2.10,               2.07,                1.53,                1.89,                     2.52,                        1.29,                        2.58,                         1.32),
                    roi = c("Caudate nucleus*",      "Putamen*",         "Thalamus",          "Nucleus accumbens*", "ACC, subgenual*",  "ACC, pregenual*",  "ACC, supracallosal", "Anterior insula*", "Posterior insula*", "Substantia nigra",  "Parahippocampal gyrus*", "Medial prefrontal cortex*", "Posterior cingulate gyrus", "Posterior parietal cortex*", "Lateral occipital cortex"),
                    estimate = c("1.44 [0,68,2,19]", "1.27 [0.45,2.09]", "0.55 [-0.29,1.40]", "1.81 [1.08,2.54]",   "2.49 [1.71,3.26]", "1.17 [0.33,2.01]", "0.70 [0.14,1.53]",   "1.31 [0.53,2.10]", "1.33 [0.59,2.07]",  "0.69 [-0.14,1.53]", "1.07 [0.26,1.89]",       "1.42 [0.32,2.52]",          "0.45 [-0.39,1.29]",         "1.68 [0.77,2.58]",           "0.43 [-0.46,1.32]"))

header <- tibble(roi = c("", "ROI"),
                 estimate = c("", "Estimate [CI]"),
                 summary = FALSE)

styles <- fpShapesGp(
  lines = list(
    gpar(col = ""),
    gpar(col = ""),
    gpar(col = "gray"), #1
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "gray"),
    gpar(col = "")
  ),
  box = list(
    gpar(fill = ""),
    gpar(fill = ""),
    gpar(fill = "darkred"), #1
    gpar(fill = "darkred"),
    gpar(fill = "grey"),
    gpar(fill = "darkred"),
    gpar(fill = "darkred"),
    gpar(fill = "darkred"),
    gpar(fill = "grey"),
    gpar(fill = "darkred"),
    gpar(fill = "darkred"),
    gpar(fill = "grey"),
    gpar(fill = "darkred"),
    gpar(fill = "darkred"),
    gpar(fill = "grey"),
    gpar(fill = "darkred"),
    gpar(fill = "grey"),
    gpar(fill = "")
  ) 
)

empty_row <- tibble(mean = NA_real_)

feedback_output_df <- bind_rows(header,
                                base_data,
                                empty_row)

jpeg("D:/Feedback_reward/Analysis/ROI_analysis/figures/ROIanalysis_model4.jpg", width = 17.5, height = 17.5, units = "cm", res = 700)
feedback_output_df %>% 
  forestplot(labeltext = c(roi, estimate),
             is.summary = c(rep(TRUE, 2), rep(FALSE, 15)),
             boxsize = 0.3,
             xlab = 'Parameter estimates with adj. 95% confidence interval
(FDR corrected). * indicates significance',
             shapes_gp = styles,
             vertices = TRUE,
             # xticks=c(-0.2,-0.1,0,.1,.2,.3,.4),
             txt_gp = fpTxtGp(ticks = gpar(fontfamily = "", cex = .7),
                              xlab  = gpar(fontfamily = "", cex = .7)))
dev.off()
