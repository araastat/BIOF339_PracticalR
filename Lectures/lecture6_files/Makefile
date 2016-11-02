KNIT=Rscript -e "rmarkdown::render('$<')"

TOP_SOURCE=Assignment6.Rmd lecture6_suppl.Rmd
TOP_HTML=$(TOP_SOURCE:.Rmd=.html)

all: $(TOP_HTML)
 
%.html:%.Rmd
	$(KNIT)
