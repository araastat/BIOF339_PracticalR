
KNIT = Rscript -e "require(rmarkdown); render('$<')"
TOP_DIR=.
MAKE=make

LECTURE_DIR= ./Lectures
LECTURE_SOURCE=$(wildcard $(LECTURE_DIR)/lecture*.Rmd)
LECTURE_HTML=$(LECTURE_SOURCE:.Rmd=.html)
TOP_SOURCE=$(wildcard *.Rmd)
TOP_HTML=$(TOP_SOURCE:.Rmd=.html)
LECTURE_FILE_DIR=$(wildcard $(LECTURE_DIR)/lecture*_files)

all: top lectures lecturefiles
top: $(TOP_HTML)
lectures: $(LECTURE_HTML)
lecturefiles:
	$(foreach bdir,$(LECTURE_FILE_DIR), $(MAKE) -C $(bdir) all;)

%.html:%.Rmd
	$(KNIT)
