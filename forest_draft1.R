getwd()
setwd("\\\\icnas2.cc.ic.ac.uk/mc6515/Desktop/survivors/pa_report")

# Load packages 
library(meta)
library(rmeta)
library(gdata)
library(metafor)
require(gdata)
library(ggplot2)
library(readxl)
library(pwr)
library(xlsx)
library(ggplot2)
library(writexl)
library(stringr)
library(tidyverse)
library(dosresmeta)
?`dosresmeta-package`
dir.create("plots")


# Moderate and Vigorous (subgroups)
test <- read_excel("physactiv_forestpost.xlsx",sheet="modvig_bremortal")
dim(test) # 35 , 110 


results <- subset(test, highvslow=="yes")
dim(results) # 6, 110
View(results)


resultsnew <- results %>%
 select(Author, Year, StudyDescription, MenoStatus, SizeStudy, Number_Women, LengthFollowUp,
        LengthFollowUnits, LengthFollowType, ResultsNumber, 
        RR, CILow, CIUpper, Reference, maxFromReference, analysis_type)
View(resultsnew)

dim(resultsnew) # 6 rows , 16 cols

# add new row with the results of Maliniak that was caclulated with the Fixed effects model 
newRow <- data.frame(Author="Maliniak", Year="2018", StudyDescription="Cancer Prevention Study II Nutrition Cohort", 
                     MenoStatus="Post-menopausal", SizeStudy=5254, Number_Women=5254, 
                     LengthFollowUp=13.3, LengthFollowUnits="years", LengthFollowType="median", 
                     ResultsNumber="7124&7128", RR=0.823, CILow=0.582, CIUpper=1.163, 
                     Reference=0, maxFromReference=1, analysis_type="moderate_and_vig_bremortal")


resultsnew <- rbind(resultsnew,newRow)
View(resultsnew)

# Replace study names 
resultsnew$`Study Description` <- ifelse(resultsnew$`Study Description`=="Cancer Prevention Study II Nutrition Cohort", "CPS-II Nutrition Cohort",
                                         ifelse(resultsnew$`Study Description`=="Women's Heath Initiave", "WHI",
                                                ifelse(resultsnew$`Study Description`=="Colloborative Women's Longevity Study", "CWLS",
                                                       ifelse(resultsnew$`Study Description`=="Women's Healthy Eating and Living Study", "WHEL",
                                                              ifelse(resultsnew$`Study Description`=="LACE", "LACE", NA)))))



# add the contrast column 
resultsnew$contrast <- c("XX", # maliniak to be deleted , I computed average of the two estimates uing fixed effects model; use that intead
                         ">9 vs 0 MET-h/week", # Irwin moderate-vigorous 
                         ">=27 vs <5.3 MET-h/week", # sternfeld moderate-vigorous 
                         ">=6 vs <1 hours/week", # sterfeld moderate
                         ">1 vs <=0 hours/week", # sternfeld vigorous
                         ">=10.3 vs <2 MET-h/week", # holick moderate
                         ">=15.1 vs <0 MET-h/week",  # holick vigorous
                        "22.9–107 vs 0–1.3 MET-h/week", # bertram moderate-vigorous 
                       ">=17.5 vs <3.5 MET-h/week") # maliniak moderate-vogorous
    


vigmodtotmort <- metagen(TE = vigmod_totmort$logRR, seTE = vigmod_totmort$sei,  data=vigmod_totmort, 
                         studlab = vigmod_totmort$Author, sm ="RR", prediction = F,
                         byvar = analysis_type,
                         comb.fixed = F, method.tau="DL")

vigmodtotmort

print.meta(vigmodtotmort, cilayout(bracket = "(", separator = ","))                                               

pdf(file = "plots/forest_modvig_totmort.pdf", width = 9, height = 7)

forest.meta(vigmodtotmort, studlab = TRUE, 
            comb.random = vigmodtotmort$comb.random,
            lyt.random = TRUE,
            type.study="square",
            squaresize=0.5,
            type.random="diamond",
            subgroup = TRUE, # we need to see the pooled results of subgroups
            overall = FALSE, # but not an overall pooling as studies are repeated 
            print.subgroup.labels = TRUE,
            bylab = "",
            text.random = "", # this line to delete text for Random effects model
            col.study="black", 
            col.square="black", 
            col.inside="white", 
            col.diamond="transparent", 
            col.diamond.lines="black",
            col.label.right="black",
            col.label.left="black",
            col.by="black", # specify the color of the results for subgroups
            smlab="", # this to delete the risk ratio at the top of the plot
            leftcols=c("studlab", "Year"),# to remove TE and seTE from plot
            rightcols=c("effect", "ci", "w.random","Study Description", "contrast"),
            rightlabs=c("RR","95% CI", "% Weight", "Study Description", "  contrast (high vs low)"),
            hetlab = "Overall: ", 
            lwd=0.9,
            print.I2 = vigmodtotmort$comb.random,
            plotwidth="5cm",
            colgap.forest.left="0.5cm",
            colgap.forest.right="0.000005cm",
            colgap.right="0.5cm",
            print.I2.ci = FALSE, 
            print.tau2 = FALSE, 
            print.Q = FALSE,
            digits = 2, # specifies the number of digits on the plot after comma
            fontsize = 7)



