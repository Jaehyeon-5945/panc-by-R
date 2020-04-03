rm(list=ls()) #���� ����� Data�� value ��� �����ϱ�.

src_dir <- c('E:/R/PANC 2nd/raw_No modifier')  #�ҷ��� ���ϵ��� �ִ� directory ����
src_file <- list.files(src_dir, pattern = ".csv")     #�ҷ��� ���ϵ� ����Ʈȭ
src_file_lnc <- length(src_file)  # �ҷ��� ���ϵ��� ���� ����

src_dir_g <- c('E:/R/PANC 2nd/ReactomePA _ SORT mutation')  #�ҷ��� ���ϵ��� �ִ� directory ����
src_file_g <- list.files(src_dir_g, pattern = ".tsv")     #�ҷ��� ���ϵ� ����Ʈȭ
src_file_lnc_g <- length(src_file_g)

throw <- function(x,y) {
  get(paste0(x,y))
}

for (i in 1:src_file_lnc){
  assign(paste0("NGS_",i),
         read.csv(paste0(src_dir, "/", src_file[i]),
                  stringsAsFactors = T,
                  na.strings = NA,
                  header = T))   #csv�� �о����
  
  name <- gsub("_No modifier.csv","",src_file[i])
  
  for (j in 1:src_file_lnc_g) {
    assign(paste0("gene_",j),
           read.table(paste0(src_dir_g,"/",src_file_g[j]),
                      header = F,
                      sep = "\t"))
    
    assign(paste0("trans_",j), t(as.vector(get(paste0("gene_", j)))))
    
    assign(paste0("collap_",j), paste(throw("trans_",j), collapse = "$|^"))
    
    assign(paste0("list_",j),
           grep(paste0("^",throw("collap_",j),"$"),throw("NGS_",i)$Gene_Name))
    
    assign(paste0("m.list",j),
           sort(as.matrix(get(paste0("list_",j)))))
    
    assign(paste0("Col_",j),
           get(paste0("NGS_", i))[get(paste0("m.list",j)),])
           
    assign(paste0("uniq_",j),
           get(paste0("Col_",j))[!duplicated(get(paste0("Col_",j))$POS),1:19])
    
    savename <- gsub(".tsv","",src_file_g[j])
    savename <- gsub("[","",savename, fixed = TRUE, ignore.case = TRUE)
    savename <- gsub("]","",savename, fixed = TRUE, ignore.case = TRUE)
    
    assign(paste0("name_",j),
           paste0("E:/R/PANC 2nd/sort_Reactom/by pathway/", savename,"-",name,".csv"))

    write.csv(get(paste0("uniq_",j)), get(paste0("name_",j)), row.names=FALSE)
    
    print(j)
    print(src_file_g[j])
  }
  print(i)
  print(src_file[i])
}