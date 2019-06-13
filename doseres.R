getwd()
dosebea <- read_excel("meta_data/fibre_doseres.xlsx",sheet="beasley")
dosebea$logRR <- with(dosebea, log(RR))

dosebea$sei <- ((log(dosebea$ci_high)-dosebea$logRR)/1.96)

mod <- dosresmeta(formula = logRR ~ dose, type = "ci", cases = cases,
                  n = tot_n, covariance = "gl", se=sei,
                  data= dosebea)
summary(mod)
# get the RR per 10 g/day
exp(-0.0135)^10 # 0.8737159

# get the lower confidence interval per 10 g/day
exp(-0.0314)^10 # 0.730519

# get the upper confidence interval per 10 g/day
exp(0.0043)^10  #  1.043938