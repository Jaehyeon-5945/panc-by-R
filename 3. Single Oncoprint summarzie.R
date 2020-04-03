rm(list=ls()) #���� ����� Data�� value ��� �����ϱ�.
library(data.table)
library(arules)
library(dplyr)

src_dir <- c('E:/R/PANC 2nd/raw_No modifier')  #�ҷ��� ���ϵ��� �ִ� directory ����
src_file <- list.files(src_dir)     #�ҷ��� ���ϵ� ����Ʈȭ
src_file_lnc <- length(src_file)  # �ҷ��� ���ϵ��� ���� ����

throw <- function(x,y) {
  get(paste0(x,y))
}

NGS <- read.csv("E:/R/PANC 2nd/sort_Reactom/by pathway/Participating Molecules R-HSA-73857 RNApol II-GeneOnly-SNU2729B1.csv", header = T, stringsAsFactors = TRUE, na.strings = NA)
NGS_df <- select(NGS, Gene_Name, Effect)
NGS_new <- data.table()

n <- nrow(NGS_df)

for (i in 1:n){
  
  print(i) # to check progress
  
  name_index <- as.character(NGS_df[i, 1])
  
  item_index <- as.character(NGS_df[i, 2])
  
  item_index_split_temp <- data.frame(strsplit(item_index, split = '&'))
  
  mart_temp <- data.frame(cbind(name_index, item_index_split_temp))
  
  names(mart_temp) <- c("Gene_Name", "Effect")
  
  NGS_new <- rbind(NGS_new, mart_temp)
}

NGS_new <- as(NGS_new, "data.frame")

NGS_tr <- as(split(NGS_new[,"Effect"],NGS_new[,"Gene_Name"]), "transactions")

NGS_summ <- as(NGS_tr, "data.frame")

NGS_summ$items <- gsub("}","",NGS_summ$items, fixed = TRUE, ignore.case = TRUE)
NGS_summ$items <- gsub("{","",NGS_summ$items, fixed = TRUE, ignore.case = TRUE)
NGS_summ$items <- gsub(",",";",NGS_summ$items, fixed = TRUE, ignore.case = TRUE)


NGS_summ <- select(NGS_summ, transactionID, items)

