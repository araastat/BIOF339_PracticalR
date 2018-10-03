library(qqman)
library(ggplot2)
library(ggthemes)
ggplot(gwasResults, aes(x = BP, y=-log(P, base=10)))+
  geom_point(size=0.3)+
  facet_wrap(~CHR, nrow=5, scales='free_x')+
  geom_hline(yintercept = 7, linetype=2, color='red')+
  labs(x = 'Chromosomal position', y = expression(-log[10](P)))

findmids <- function(x){
  x = c(0,x)
  xx = x[-length(x)] + (x[-1]-x[-length(x)])/2
  return(xx)
}
mdat <- gwasResults %>% mutate(xloc = 1:n())
bl <- gwasResults %>% count(CHR) %>% mutate(N=cumsum(n),
                                            xlegloc = findmids(N))

ggplot(mdat, aes(x = xloc, y = -log(P, base=10), color=factor(ifelse(CHR %%2,1,2))))+
  geom_point(size=0.8)+
  geom_hline(yintercept=c(5,7), color=c('blue','red'), size=0.5, linetype=2)+
  scale_x_continuous('Chromosome', breaks = bl$xlegloc, labels = as.character(1:22))+
  theme_few()+
  # theme_bw()+
  theme(legend.position='none')+
  scale_color_grey(start=0.5, end=0.8)+
  labs(y = expression(-log[10](P)))
