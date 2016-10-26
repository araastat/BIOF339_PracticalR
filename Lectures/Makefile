
KNIT = Rscript -e "require(rmarkdown); render('$<')"

LECTURES_SOURCE= $(wildcard *.Rmd)
LECTURES_HTML = $(LECTURES_SOURCE:.Rmd=.html)

html: $(LECTURES_SOURCE)
	ls $<
