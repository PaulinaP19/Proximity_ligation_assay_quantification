#Combining Proximity Ligation Assay results
#Draw a boxplot from the outcome

# merge files corresponding to a specific condition (Sp: Sphase, NSp: Non Sphase, Ctrl: control, HU: Hydroxyurea, APH: aphidicolin) 
library(ggplot2)

Sp_HU <- list.files(pattern = "PLA_Sphase_230822_PLA_Tim_PCNA_HU001")

Sp_HU_foci  <- data.frame()
for (file in Sp_HU) {
  
  data <- read.delim(file, header = TRUE)
  
  rowf <- data[3]

  
  Sp_HU_foci <- as.data.frame(rbind(Sp_HU_foci, rowf))
  
}

NSp_HU <- list.files(pattern = "PLA_NoSphase_230822_PLA_Tim_PCNA_HU001")

NSp_HU_foci  <- data.frame()
for (file in NSp_HU) {
  
  data <- read.delim(file, header = TRUE)
  
  rowf <- data[3]
  
  NSp_HU_foci <- as.data.frame(rbind(NSp_HU_foci, rowf))
  
}

Sp_APH <- list.files(pattern = "PLA_Sphase_230822_PLA_Tim_PCNA_APH001")

Sp_APH_foci  <- data.frame()
for (file in Sp_APH) {
  
  data <- read.delim(file, header = TRUE)
  
  rowf <- data[3]
  
  Sp_APH_foci <- as.data.frame(rbind(Sp_APH_foci, rowf))
  
}


NSp_APH <- list.files(pattern = "PLA_NoSphase_230822_PLA_Tim_PCNA_APH001")
NSp_APH_foci  <- data.frame()
for (file in NSp_APH) {
  
  data <- read.delim(file, header = TRUE)
  
  rowf <- data[3]
  
  NSp_APH_foci <- as.data.frame(rbind(NSp_APH_foci, rowf))
  
}
Sp_Ctrl <- list.files(pattern = "PLA_Sphase_230822_PLA_Tim_PCNA_Ctrl")

Sp_Ctrl_foci  <- data.frame()

for (file in Sp_Ctrl) {
  
  data <- read.delim(file, header = TRUE)
  
  rowf <- data[3]
  
  Sp_Ctrl_foci <- as.data.frame(rbind(Sp_Ctrl_foci, rowf))
  
}

NSp_Ctrl <- list.files(pattern = "PLA_NoSphase_230822_PLA_Tim_PCNA_Ctrl")
NSp_Ctrl_foci  <- data.frame()

for (file in NSp_Ctrl) {
  
  data <- read.delim(file, header = TRUE)
  
  rowf <- data[3]
  
  NSp_Ctrl_foci <- as.data.frame(rbind(NSp_Ctrl_foci, rowf))
  
}

Sp_APH_foci['name'] <- "Sp_APH"
NSp_APH_foci['name'] <- "NSp_APH"
NSp_HU_foci['name'] <- "NSp_HU"
Sp_HU_foci['name'] <- "Sp_HU"
Sp_Ctrl_foci['name'] <- "Sp_Ctrl"
NSp_Ctrl_foci['name'] <- "NSp_Ctrl" 

PLA_PCNA_Tim <- as.data.frame(rbind(Sp_Ctrl_foci, Sp_HU_foci, Sp_APH_foci, NSp_Ctrl_foci, NSp_HU_foci, NSp_APH_foci))
 
#save combined results
write.table(PLA_PCNA_Tim, file = "PLA_PCNA_Tim_Ctrl_HU_APH.txt", sep = "\t", row.names= F )


pdf("PLA_PCNA_Timeless.pdf",   # name of the graph
    width = 6, # The width of the plot in inches
    height = 6) # The height of the plot in inches

#put the data in wished order
level_orderX <- c("Sp_Ctrl", "Sp_HU", "Sp_APH", "NSp_Ctrl", "NSp_HU", "NSp_APH")
ggplot(PLA_PCNA_Tim, aes(fill=name, y=Count, x=factor(name, level=level_orderX))) + geom_boxplot(outlier.shape = NA) + theme_bw() + scale_fill_discrete(breaks=level_orderX) + labs( x = "Condition", y = "Count")  
#  create the file
print(p)
dev.off()
