# R version 3.3.2 (2016-10-31)
# Platform: x86_64-apple-darwin13.4.0 (64-bit)
# Running under: macOS Sierra 10.12.5
# 
# locale:
#   [1] zh_TW.UTF-8/zh_TW.UTF-8/zh_TW.UTF-8/C/zh_TW.UTF-8/zh_TW.UTF-8
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] stringr_1.2.0 dplyr_0.5.0   XML_3.98-1.7 
# 
# loaded via a namespace (and not attached):
#   [1] Rcpp_0.12.11     binman_0.1.0     assertthat_0.2.0 bitops_1.0-6    
# [5] R6_2.2.1         DBI_0.6-1        semver_0.2.0     magrittr_1.5    
# [9] stringi_1.1.2    rlang_0.1.1      tools_3.3.2      RSelenium_1.7.1 
# [13] wdman_0.2.2      caTools_1.17.1   openssl_0.9.6    tibble_1.3.1

# install packages
pkgs.needs <- c("downloader", "dplyr", "stringr", "xlsx")
pkgs.installed <- installed.packages()[,"Package"]
new.pkgs <- pkgs.needs[!(pkgs.needs %in% pkgs.installed)]
if(length(new.packages)) install.packages(new.pkgs)                        
library(downloader) # download
library(dplyr)      # data manipulation & pipe line
library(stringr)    # str_pad
library(xlsx)       # excel

# define function
## to remove space
rm.smb <- function(x) {x %>% gsub("\\s", "", .) %>% return}
## to clean data
cleanXls <- function(fileName, xth) {
  xlsxFile <- read.xlsx(file=fileName, sheetIndex = xth, encoding="UTF-8")
  xlsxFile %>% .[, c(1:11)] %>%
           `colnames<-`(c("區域名", "土地面積", "里數", "鄰數", "戶數", "每戶平均人口", "人口數", "男", "女", "性別比", "人口密度")) %>%
           filter(complete.cases(.)) %>% lapply(., rm.smb) %>% return
}

# download file
fileName <- "01臺南市歷年各區里數、鄰數、戶數、人口數、性別比例及人口密度統計表 (2).xls"
url <- "http://www.tainan.gov.tw/tn/agr/warehouse/I40000file/01%E8%87%BA%E5%8D%97%E5%B8%82%E6%AD%B7%E5%B9%B4%E5%90%84%E5%8D%80%E9%87%8C%E6%95%B8%E3%80%81%E9%84%B0%E6%95%B8%E3%80%81%E6%88%B6%E6%95%B8%E3%80%81%E4%BA%BA%E5%8F%A3%E6%95%B8%E3%80%81%E6%80%A7%E5%88%A5%E6%AF%94%E4%BE%8B%E5%8F%8A%E4%BA%BA%E5%8F%A3%E5%AF%86%E5%BA%A6%E7%B5%B1%E8%A8%88%E8%A1%A8%20(2).xls"
download(url, fileName, mode = "wb")

# main prog
df <- data.frame()
pattern_date <- '\\d{2,3}.\\d{2}' 
sheetsList = loadWorkbook(fileName) %>% getSheets %>% names %>% str_extract(pattern_date)
nsheet <- length(sheetsList)
for (i in c(1:nsheet)) {
  data = cleanXls(fileName, i) %>% transform(年月 = sheetsList[i])
  df <- rbind(df, data)
}
levels(df$區域名)[levels(df$區域名)=="總計"] <- "臺南市"
std_df = df[, c("區域名","里數","鄰數","戶數","人口數","男","女","年月")] %>% transform(地區="臺南市")
  
# output data and restore env
write.csv(std_df, "data_std_Tainan.csv")
write.csv(df, "data_full_Tainan.csv")
if (file.exists(fileName)) file.remove(fileName)