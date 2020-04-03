rm(list=ls()) #���� ����� Data�� value ��� �����ϱ�.

library(dplyr)

src_dir <- c('E:/R/PANC 2nd/ReactomePA _ SORT mutation/Origin')  #�ҷ��� ���ϵ��� �ִ� directory ����
src_file <- list.files(src_dir, pattern = ".tsv")     #�ҷ��� ���ϵ� ����Ʈȭ
src_file_lnc <- length(src_file)  # �ҷ��� ���ϵ��� ���� ����

for (i in 1:src_file_lnc){
  assign(paste0("GL_",i),
         read.table(paste0(src_dir, "/", src_file[i]),
                  header=T, sep="\t",stringsAsFactors = T, na.strings = NA))   #csv�� �о����
  
  GNs<- as.vector(get(paste0("GL_", i))$MoleculeName)
  
  SP <- strsplit(GNs, " ")
  
  DFSP <- as.data.frame(SP)
  
  DF <- as.data.frame(t(DFSP))
  
  A <- select(DF, V2)
  colnames(A) <- NULL
  row.names(A) <- NULL
  
  assign(paste0("name_", i),paste0("E:/R/PANC 2nd/ReactomePA _ SORT mutation/",gsub(".tsv", "",src_file[i]),"-GeneOnly.tsv"))

  write.table(A, get(paste0("name_",i )), row.names = FALSE)
  
  print(i)
  print(src_file[i])
}