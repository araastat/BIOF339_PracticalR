## ------------------------------------------------------------------------
# This is a comment, which doesn't get evaluated

1:3 # This is also a comment

# Multi-line code

x <- c(1, 2, 
       3, 4, 5, 6,
       7)
x

## ---- eval=FALSE---------------------------------------------------------
## install.packages('dplyr', repos='http://cran.r-project.org')

## ---- eval=FALSE---------------------------------------------------------
## library(dplyr)

## ------------------------------------------------------------------------
data_spine <- read.csv('lecture2_data/Dataset_spine.csv')

## ------------------------------------------------------------------------
head(data_spine)

## ---- eval=FALSE---------------------------------------------------------
## View(data_spine)  # It looks like a matrix

## ------------------------------------------------------------------------
str(data_spine) # Structure of a dataset

## ------------------------------------------------------------------------
class(data_spine)

## ------------------------------------------------------------------------
matrix(0, nrow=2, ncol=4)

## ------------------------------------------------------------------------
matrix(letters, nrow=2)

## ------------------------------------------------------------------------
matrix(letters, nrow=2, byrow=T)

## ------------------------------------------------------------------------
x <- c(1,2,3,4)
y <- c(10,20,30,40)

## ------------------------------------------------------------------------
cbind(c(1,2,3,4), c(10,20,30,40)) # Column bind

## ------------------------------------------------------------------------
x <- c(1,2,3,4)
y <- c(10,20,30,40)

## ------------------------------------------------------------------------
example_matrix <- rbind(c(1,2,3,4), c(10,20,30,40)) # Row bind
example_matrix

## ------------------------------------------------------------------------
example_matrix 
example_matrix[1,] # Extracts 1st row
example_matrix[,2:3] # extracts 2nd & 3rd columns
example_matrix[1,4]

## ------------------------------------------------------------------------
example_matrix
nrow(example_matrix) # Number of rows
ncol(example_matrix) # Number of columns
dim(example_matrix) # shortcut for above

## ------------------------------------------------------------------------
example_matrix
example_matrix + 5 # Add 5 to each element
example_matrix * 2 # Multiply each element by 2

## ------------------------------------------------------------------------
example_matrix
example_matrix2 <- rbind(3:6, 9:12)
example_matrix2
example_matrix + example_matrix2

## ------------------------------------------------------------------------
example_matrix
example_matrix2
example_matrix * example_matrix2 # Not matrix multiplication, but element-wise multiplication

## ------------------------------------------------------------------------
rbind(example_matrix, example_matrix2)
cbind(example_matrix, example_matrix2)

## ------------------------------------------------------------------------
dim(example_matrix2)
t(example_matrix2) # Transpose of a matrix
example_matrix %*% t(example_matrix2) # Matrix multiplication

## ------------------------------------------------------------------------
example_list <- list(c('Andy','Brian','Harry'), 
                     c(12, 16, 16), 
                     c(TRUE, TRUE, FALSE), 
                     matrix(1, nrow=2, ncol=3))
example_list

## ------------------------------------------------------------------------
example_list[[3]]

## ------------------------------------------------------------------------
example_list[1:2]

## ------------------------------------------------------------------------
example_list[[4]]
class(example_list[[4]])
example_list[[4]][1,]

## ------------------------------------------------------------------------
example_named_list <- list('Names' = c('Andy','Brian','Harry'), 
                     "YearsOfEducation" = c(12, 16, 16), 
                     "Married" = c(TRUE, TRUE, FALSE), 
                     'something' = matrix(1, nrow=2, ncol=3))

example_named_list[['Names']]
example_named_list$Names
example_named_list$Names[3]

## ------------------------------------------------------------------------
head(data_spine)

## ------------------------------------------------------------------------
dim(data_spine)
nrow(data_spine)

data_spine_small <- data_spine[1:4,] # Matrix operation

## ------------------------------------------------------------------------
data_spine_small[,2] # Matrix extraction by position
data_spine_small[[2]] # List extraction by position

## ------------------------------------------------------------------------
data_spine_small[['Pelvic.tilt']] # Named list extraction
data_spine_small[,'Pelvic.tilt'] # Data frame named column extraction
data_spine_small$Pelvic.tilt # Dollar sign extraction

## ------------------------------------------------------------------------
names(data_spine_small)

data_spine_small[,c('Pelvic.tilt', 'Pelvic.slope','Class.attribute')]

## ------------------------------------------------------------------------
data_spine[data_spine$Pelvic.tilt > 20, ]

## ---- eval=F-------------------------------------------------------------
## subset(data_spine, Pelvic.tilt > 20) # is equivalent

## ------------------------------------------------------------------------
data_spine[data_spine$Pelvic.tilt > 20 & data_spine$Pelvic.slope > 0.85, ]

## ---- eval=FALSE---------------------------------------------------------
## subset(data_spine, Pelvic.tilt > 20 & Pelvic.slope > 0.85)

## ------------------------------------------------------------------------
data_spine[data_spine$Pelvic.tilt > 20 & data_spine$Pelvic.slope > 0.85, 
           c('Direct.tilt', 'Class.attribute')]

## ------------------------------------------------------------------------
data_spine_small[,'bad.angle'] <- c('No','Yes','No','No')
data_spine_small

## ---- eval=F-------------------------------------------------------------
## data_spine_small$bad.angle <- ...
## data_spine_small[['bad.angle']] <- ...

## ---- eval=FALSE---------------------------------------------------------
## data_spine_small[, -c(13,14)]
## 
## data_spine_small[,-c('Class.attribute', 'bad.angle')]
## 
## # The next two commands change the original data set
## 
## data_spine_small[c('Class.attribute','bad.angle')] <- NULL
## 
## data_spine_small[['bad.angle']] <- NULL

## ------------------------------------------------------------------------
data_spine_small$bad.angle <- ifelse(data_spine_small$Sacrum.angle > 80, 'Yes','No')

## ------------------------------------------------------------------------
data_spine_small <- transform(data_spine_small, 
                              bad.angle = ifelse(Sacrum.angle > 80, 
                                                 'Yes','No'))

## ------------------------------------------------------------------------
head(mtcars)

## ------------------------------------------------------------------------
mtcars <- transform(mtcars, 
                    kmpg = mpg * 1.6, # Numerical vector
                    low.mpg = ifelse(mpg < 16, 'Yes','No')  # Factor
                    )

## ------------------------------------------------------------------------
str(mtcars)

## ------------------------------------------------------------------------
new_data = rbind(data_spine[1:4,], data_spine[c(8,22),])
new_data

## ------------------------------------------------------------------------
new_data2 <- cbind(data_spine[1:4, c('Pelvic.slope','Class.attribute')], 
                   data.frame(Sex = c('M','F','M','M'),    # Creating a new data frame on the fly
                              Race = c('W','B','As','B'))
                   )
new_data2

