#merge replicates and draw a boxplot
#chose directory containing your data
setwd("/Volumes/CCHL-User/Paulina/03_Tipin_Timeless/00000001_PLA/PLA_PCNA_Tim_publication/combined")
library(ggplot2)
library(stringr)
boxplots  <- list.files(pattern = "txt")

merged = data.frame()
for (f in boxplots){
  
  data <- read.delim(f)
  merged <- as.data.frame(rbind(merged, data))
}
  sufix <- str_extract(boxplots[1], "_(.*)")
  fileN <- paste0("merge",  sufix)
  write.table(merged, file= fileN, row.names = FALSE, sep = "\t")
  
  filenm <- sub(".txt", ".pdf", fileN)
  
  pdf(file = filenm,   # file name
      width = 6, # The width of the plot in inches
      height = 6) # The height of the plot in inches
 
  
  level_orderX <- c("Sp_Ctrl", "Sp_HU", "Sp_APH", "NSp_Ctrl", "NSp_HU", "NSp_APH")
  p <- ggplot(merged, aes(fill=name, y=Count, x=factor(name, level=level_orderX))) + geom_boxplot(outlier.shape = NA) + theme_bw() + scale_fill_discrete(breaks=level_orderX) ++ theme_bw() + scale_fill_discrete(breaks=level_orderX) + labs( x = "Condition", y = "Count")  
  # save the graph
  print(p)
  dev.off()
  
