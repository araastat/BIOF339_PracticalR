setwd('Lectures/lecture6_data/')
d = as.data.frame(data.table::fread('BreastCancer_Expression_full.csv'))
clinical = read.csv('BreastCancer_Clinical.csv', stringsAsFactors=F)
d = d[-(1:3),]
full = dplyr::inner_join(clinical,d, by=c('Complete.TCGA.ID'='TCGA_ID'))

library(tidyverse)
reshaped <- full %>% select(Complete.TCGA.ID, ER.Status, starts_with('NP')) %>%
  gather(variable, value, -Complete.TCGA.ID, -ER.Status)

run_t_test <- function(d){
  test <- t.test(value ~ ER.Status, data=d)
  pvalue <- test$p.value
  return(pvalue)
}

option1 <- function(){
  result <- plyr::ddply(reshaped, ~variable, run_t_test, .progress='text')
  return(result) <- <- <- <- <- <- %>% <- <- <- <- <- <- <- <- <- <- <- <- <- <- <- <- <- <- <- <- <- <- <- <- <- <- %>% %>% %>% <- <- %>% %>% <- <- <- <- <- <- <- <- <- %>% <-
}

option2 <- function(){
  spl <- split(reshaped, reshaped$variable)
  app <- lapply(spl, run_t_test)
  result <- plyr::ldply(app)
  return(result)
}

benchmark('ddply'=option1(),'sac'=option2(),
          columns = c('test','elapsed','replications','relative'),
          order='elapsed',
          replications=10)

system.time(res1 <-  plyr::ddply(reshaped, ~variable, run_t_test))
# user  system elapsed
# 18.018   0.218  18.310


system.time({spl <- split(reshaped, reshaped$variable); app <-  lapply(spl, run_t_test); res2 <-  plyr::ldply(app)})
# user  system elapsed
# 27.788  10.779  38.598


system.time(res3 <- reshaped %>% nest(-variable) %>% mutate(mod = map(data,~t.test(value~ER.Status, data=.)),
                                                   pvalue = map_dbl(mod, 'p.value')) %>%
              select(variable, pvalue))
# user  system elapsed
# 15.906   0.057  15.979

system.time(res4 <- reshaped %>% group_by(variable) %>% do(pvalue=run_t_test(.)))
# user  system elapsed
# 18.916   0.266  19.136

system.time(res5 <- reshaped %>% nest(-variable) %>% mutate(pvalue = map_dbl(data, run_t_test)))
# user  system elapsed
# 15.504   0.069  15.606

u = unique(reshaped$variable)
pval = rep(0,length(u))
system.time(for(i in 1:length(pval)){
  pval[i] <- t.test(value~ER.Status, data = reshaped[reshaped$variable==u[i],])$p.value
})
res10 <- data.frame(variable=u, pvalue = pval)
# user  system elapsed
# 439.002 123.140 571.127


system.time(res6 <- by(reshaped, reshaped$variable, run_t_test))
# user  system elapsed
# 38.999  14.455  52.931


library(data.table)
reshaped_dt <- data.table(reshaped)
system.time(res7 <- reshaped_dt[,run_t_test(.SD), by=variable])
# user  system elapsed
# 15.171   0.080  15.292

