# For the dose-respose (example with Hatse 2012 paper-vitD)
# Paper reports continous result per 10ng/ml
# Need to convert to per 10 nmol/L to harmonise data and calculate dose

# 10 ng/ml*2.496=24.96 nmol/L 

# Calculations:
#####--------------------Total mortality--------------------------#####

# 1. Take the natural logarithm of the HR (go back to the beta coeff)
log(0.79)/24.96
# [1] -0.009444004 # this is per 1 nmol/L
# then multiply by 10 to get per 10 nmol/L

(-0.009444004)*10
# -0.09444004

# Then exponentiate to convert to the hazard ratio scale again 
exp(-0.09444004)
# HR=0.9098823

# Repeat for the lower and upper confidence intervals 
# Lower bound 95% CI

(log(0.65)/24.96)*10 
# [1] -0.1725893 per 10 nmol/L, I multiplied directly 

exp(-0.1725893) # =0.8414831

# Lower bound 95% CI=0.8414831

# Upper bound 95% CI

(log(0.95)/24.96)
# -0.00205502
-0.00205502*10
# -0.0205502

exp(-0.0205502)
# Upper 95% CI=0.9796596

# Estimate per 10 nmol/L: HR= 0.91 95% CI (0.84-0.98)


####--------Breast cancer specific mortality-------------####

# HR=0.9098823, same as above 


# Lower 95% CI
log(0.62)/24.96
# [1] -0.01915208 # this is per 1 nmol/L

(-0.01915208)*10
# -0.1915208 per 10 nmol/L 

exp(-0.1915208) # 0.8257025

# Upper 95% CI
log(1)/24.96 # = 0 
0*10 # 0 
exp(0) #= 1

# So the estimate per 10 nmol/L is HR 0.91 95% CI 0.825-1.00 -use it in the dose-response-



