if(!('rbenchmark' %in% installed.packages()[,'Package'])){
    install.packages('rbenchmark', repos='http://cran.r-project.org', type='source')
}

library(rbenchmark) # Benchmarking package
library(readr) # Hadley's package for reading data
library(data.table) # an alternative package by Matt Dowle
                    # for storing and manipulating data. It
                    # stores data in a data.table object rather
                    # than a data.frame object


## ------------------------------------------------------------------------
if(!file.exists('BreastCancer_Expression_full.csv')){ # Check if the file already exists
  unzip('fullExpression.zip',
        'BreastCancer_Expression_full.csv', # Specify the file to be extracted
        exdir = '.') # Specify the directory where it will be extracted
}
expression_dat <- fread('BreastCancer_Expression_full.csv') # fread creates a data.table
expression_dat <- as.data.frame(expression_dat) # we convert it to a data.frame
expression_dat <- expression_dat[-(1:3),] # remove 1st three rows (to avoid duplicates)

clinical_dat <- read.csv('BreastCancer_Clinical.csv',
                         stringsAsFactors=F)
full_dat <- merge(clinical_dat, expression_dat,
                  by.x = 'Complete.TCGA.ID', by.y='TCGA_ID')

library(rbenchmark)
benchmark_reading <-
  benchmark('read.csv' = read.csv('BreastCancer_Expression_full.csv', stringsAsFactors=F),
          'read_csv' = read_csv('BreastCancer_Expression_full.csv'),
          'read.csv (zipped)' = read.csv(unz('fullExpression.zip',
                                             'BreastCancer_Expression_full.csv'),
                                         stringsAsFactors=F),
          'read_csv (zipped)' = read_csv(unz('fullExpression.zip',
                                             'BreastCancer_Expression_full.csv')),
          'fread' = fread('BreastCancer_Expression_full.csv'),
          columns = c('test', 'elapsed','replications','relative'),
          order = 'elapsed',
          replications = 5
  )

  library(reshape2)
  library(dplyr)
  reshaped_dat <- melt(full_dat, id.vars = c('Complete.TCGA.ID','ER.Status'),
                       measure.vars = starts_with('NP', vars=names(full_dat)))

  ## ----t-test--------------------------------------------------------------
  run_t_test <- function(d){
    test <- t.test(value ~ ER.Status, data=d)
    pvalue <- test$p.value
    return(data.frame(pvalue=pvalue))
  }

  ## ----sac-----------------------------------------------------------------
  option1 <- function(){
    split_data <- split(reshaped_dat, reshaped_dat$variable)
    pvalues <- lapply(split_data, run_t_test)
    pvalues_final <- plyr::ldply(pvalues)
    return(pvalues_final)
  }

  ## ----for-----------------------------------------------------------------
  option2 <- function(){
    u <- unique(reshaped_dat$variable)
    pval <- rep(0, length(u)) # always efficient to pre-assign a vector
    for (i in 1:length(u)){
      pval[i] <- run_t_test(subset(reshaped_dat, variable==u[i]))
    }
    pvalues_final <- data.frame(variable = u, pvalue=pval)
    return(pvalues_final)
  }

  ## ----no-lapply-----------------------------------------------------------
  option3 <- function(){
    split_data <- split(reshaped_dat, reshaped_dat$variable)
    pval <- rep(0, length(split_data))
    for(i in 1:length(split_data)){
      pval[i] <- run_t_test(split_data[[i]])
    }
    pvalues_final <- data.frame(variable = names(split_data), pvalue = pval)
    return(pvalues_final)
  }

  ## ----plyr----------------------------------------------------------------
  option4 <- function(){
    pvalues_final <- plyr::ddply(reshaped_dat, ~variable, run_t_test)
    return(pvalues_final)
  }

  ## ----dplyr---------------------------------------------------------------
  option5 <- function(){
    require(dplyr)
    grouped <- group_by(reshaped_dat, variable)
    pvalues_final <- do(grouped, run_t_test(.))
    return(pvalues_final)
  }

  ## ------------------------------------------------------------------------
  option6 <- function(){
    pvalues <- by(reshaped_dat, factor(reshaped_dat[,'variable']), run_t_test)
    pvalues_final <- plyr::ldply(unclass(pvalues))
    return(pvalues_final)
  }

  ## ----data.table----------------------------------------------------------
  option7 <- function(){
    require(data.table)
    reshaped_dt <- data.table(reshaped_dat)
    pvalues_final <- reshaped_dt[,run_t_test(.SD), by=variable]
    pvalues_final <- as.data.frame(pvalues_final)
    return(pvalues_final)
  }

  ## ------------------------------------------------------------------------
  library(rbenchmark)
  benchmark_sac <- benchmark(
    'classroom' = option1(),
    'for loop (naive)' = option2(),
    'for loop (list)' = option3(),
    'ddply' = option4(),
    'dplyr group_by' = option5(),
    'by' = option6(),
    'data.table' = option7(),
    columns = c('test','elapsed','replications','relative'),
    order = 'elapsed',
    replications=5
  )

save(benchmark_reading, benchmark_sac, file='benchmarks.rda')
