rm(list=ls()) #���� ����� Data�� value ��� �����ϱ�.

library(stringr)
library(dplyr)

src_dir <- c('E:/R/PANC 2nd/sort_1')  #�ҷ��� ���ϵ��� �ִ� directory ����
src_file <- list.files(src_dir)     #�ҷ��� ���ϵ� ����Ʈȭ
src_file_lnc <- length(src_file)  # �ҷ��� ���ϵ��� ���� ����

Total <-  data.frame(Sample_ID = c(""), Chromosome=c(""), Start_position=c(""), Reference_Allele=c(""), Variant_Allele=c(""),stringsAsFactors=FALSE)

for (i in 1:src_file_lnc){
  A <- assign(paste0("NGS_",i),
              read.csv(paste0(src_dir, "/", src_file[i]),
                       stringsAsFactors = T,
                       na.strings = NA,
                       header = T))   #csv�� �о����
  
  name <- assign(paste0("name_", i), substr(src_file[i],3 ,100)) #�տ� ���� ���� �� ����ο�
  
  A <- transform(A, Sample_ID = name)
  
  B <- assign(paste0("tbl_",i),subset(A, select = c(Sample_ID, CHROM, POS, REF, ALT), sort=F)) #�������� Į�� 2���� sorting
  
  colnames(B) <- c("Sample_ID", "Chromosome", "Start_position", "Reference_Allele", "Variant_Allele")
  
  assign(paste0("sort_",i),B)
  
  Total <-rbind(Total, get(paste0("sort_", i)))
  
}

write.csv(Total, file="E:/R/PANC 2nd/191202 lollipop.csv", row.names=F)