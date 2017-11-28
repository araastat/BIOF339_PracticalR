library(ReporteRs)
library(ggplot2)
library(tidyverse)

plt <- ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color=Species))+
  geom_point()

docx( title = 'My document' ) %>%
  addTitle( 'First 5 lines of iris', level = 1) %>%
  addFlexTable( vanilla.table(iris[1:5, ]) ) %>%
  addTitle( 'ggplot2 example', level = 1) %>%
  addPlot(fun = print, x = plt) %>% # Need to print a ggplot object
  addTitle('Text example', level=1) %>%
  addParagraph("My tailor is rich.", stylename="Normal") %>%
  writeDoc('Report.docx')

pptx() %>%
  addSlide('Two Content') %>%
  addTitle('First 10 lines of iris') %>%
  addFlexTable(vanilla.table(iris[1:10,])) %>%
  addParagraph(value = c("", "Hello, World!")) %>%
  addSlide("Title and Content") %>%
  addPlot(fun = print, x = plt) %>%
  writeDoc('Report.pptx')
