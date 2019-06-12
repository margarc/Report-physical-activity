####-------------------------- Recreational physical activity and Recurrence -----------------------------------####

test <- read_excel("physactiv_forestpost.xlsx",sheet="totphys_recurrence")
dim(test) # 28 , 110 

results <- subset(test, maxFromReference==1)
dim(results) # 7, 110 

View(results)



names(results)[names(results)=="CILow"] <- "low_cl"
names(results)[names(results)=="CIUpper"] <- "upper_cl"

resultsnew <- results %>%
 select(Author, Year, StudyDescription, MenoStatus, SizeStudy, Number_Women, LengthFollowUp,
        LengthFollowUnits, LengthFollowType, ResultsNumber, 
        RR, low_cl, upper_cl, Reference, maxFromReference, 
        analysis_type, contrast)



dim(resultsnew) # 7 , 17 
names(resultsnew)[names(resultsnew)=="StudyDescription"] <- "Study Description"

View(resultsnew)

resultsnew$low_cl <- as.numeric(as.character(resultsnew$low_cl))
resultsnew$upper_cl <- as.numeric(as.character(resultsnew$upper_cl))
resultsnew$RR <- as.numeric(as.character(resultsnew$RR))


# export the clean dataset 
write.xlsx(resultsnew, "meta_data/recre_recurrence.xlsx", col.names=TRUE, 
           row.names=TRUE) 

# compute logRR
resultsnew$logRR <- with(resultsnew, log(RR))

# compute standard error 
resultsnew$sei <- ((log(resultsnew$upper_cl)-resultsnew$logRR)/1.96)


recurr <- metagen(TE = resultsnew$logRR, seTE = resultsnew$sei,  data=resultsnew, 
                  studlab = resultsnew$Author, sm ="RR", prediction = F,
                  comb.fixed = F, method.tau="DL")

recurr

print.meta(recurr, cilayout(bracket = "(", separator = ","))  


pdf(file = "plots/forest_recre_reccur.pdf", width = 9, height = 7)
forest.meta(recurr, studlab = TRUE, 
            comb.random = recurr$comb.random,
            lyt.random = TRUE,
            type.study="square",
            squaresize=0.5,
            type.random="diamond",
            subgroup = FALSE, # dont want to pool at the moment (due to high variability in recurrence definitions)
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
            print.I2 = recurr$comb.random,
            plotwidth="5cm",
            colgap.forest.left="0.5cm",
            colgap.forest.right="0.000005cm",
            colgap.right="0.5cm",
            print.I2.ci = FALSE, 
            print.tau2 = FALSE, 
            print.Q = FALSE,
            digits = 2, # specifies the number of digits on the plot after comma
            fontsize = 7)
dev.off()


# check for pooling them together and getting the overall effect





