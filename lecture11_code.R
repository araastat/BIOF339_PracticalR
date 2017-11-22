output <-
  as.data.frame(res) %>%
  rownames_to_column('gnames') %>% # Adds the row names as a column of the data
  filter(padj < 0.1) %>% # Keep only rows where the adjusted p-value is less than 0.1
  arrange(desc(abs(log2FoldChange))) %>%  # Arrange in descending order of the FC magnitude
  select(gnames, baseMean:padj) %>%  # Rearrange columns to put gnames first
  mutate_at(vars(starts_with('p')), format.pval, digits=4, eps = 1e-8, scientific=T) %>% # Format the p-values
  mutate_at(vars(baseMean:stat), round, 2) # Format the other numerical values
