## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE,
                      fig.width=4,
                      fig.height=4,
                      comment = '# ',
                      cache=F,
                      warning=F, message=F)

## ---- eval=T-------------------------------------------------------------

# Excel
library(readxl)
clinical_data <- read_excel('lecture6_data/BreastCancer_Clinical.xlsx')

# CSV
clinical_data <- read.csv('lecture6_data/BreastCancer_Clinical.csv',
                          stringsAsFactors=F)


## ---- echo=F-------------------------------------------------------------
head(clinical_data,2)

## ------------------------------------------------------------------------
expression_data <- read.csv('lecture6_data/BreastCancer_Expression.csv',
                            stringsAsFactors=F)
head(expression_data[,1:5],2)

## ------------------------------------------------------------------------
final_data = merge(clinical_data,
                   expression_data[,1:5],
                   by.x = 'Complete.TCGA.ID',
                   by.y = 'TCGA_ID')
head(final_data,2)

save(final_data, file='lecture8_files/final_data.rda', compress=T)
## ------------------------------------------------------------------------
dim(clinical_data)
dim(expression_data)
dim(final_data)

## ------------------------------------------------------------------------
head(final_data,2)

## ------------------------------------------------------------------------
library(dplyr)
selected_data <- select(final_data, Complete.TCGA.ID, ER.Status,
                        starts_with('NP'))



## ------------------------------------------------------------------------
library(reshape2)

reshaped_data <- melt(selected_data,
                      id.vars=c('Complete.TCGA.ID','ER.Status'))


## ------------------------------------------------------------------------
reshaped_data <- arrange(reshaped_data, Complete.TCGA.ID) # from dplyr
head(reshaped_data)



## ------------------------------------------------------------------------
split_data <- split(reshaped_data, reshaped_data$variable)

run_t_test <- function(d){
  test <- t.test(value ~ ER.Status, data=d)
  pvalue <- test$p.value
  return(pvalue)
}

## ------------------------------------------------------------------------
pvalues <- lapply(split_data, run_t_test)


#   -----------------------------------------------------------------------

models <- lapply(split_data, function(d) t.test(value~ER.Status, data=d))
## ------------------------------------------------------------------------
pvalues_final <- plyr::ldply(pvalues) # Use ldply from the plyr package
pvalues_final

## ------------------------------------------------------------------------
library(ggplot2)
ggplot(reshaped_data, aes(x = ER.Status, y = value))+
  geom_boxplot()+
  facet_wrap(~variable, ncol=2)

## ------------------------------------------------------------------------
names(pvalues_final) <- c('variable','pvalue')

## ------------------------------------------------------------------------
pvalues_final[,'pvalue'] <- format.pval(pvalues_final[,'pvalue'],
                                        digits=3)
ggplot(reshaped_data, aes(x = ER.Status, y = value))+
  geom_boxplot()+
  facet_wrap(~variable, ncol=2)+
  geom_text(data=pvalues_final, aes(x=1.5, y=2, label=pvalue))

## ------------------------------------------------------------------------
pvalues_final <- mutate(pvalues_final,
                        pvalue = format.pval(pvalue, digits=3))
ggplot(reshaped_data, aes(x = ER.Status, y = value))+
  geom_boxplot()+
  facet_wrap(~variable, ncol=2)+
  geom_text(data=pvalues_final, aes(x=1.5, y=2, label=pvalue))


