KNIT=Rscript -e "rmarkdown::render('$<')"

TOP_SOURCE=$(wildcard *.Rmd)
TOP_HTML=$(TOP_SOURCE:.Rmd=.html)

all: $(TOP_HTML)
 
%.html:%.Rmd
	$(KNIT)
