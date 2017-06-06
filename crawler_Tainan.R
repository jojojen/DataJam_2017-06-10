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
## to clean data
cleanXls <- function(fileName, xth) {
  xlsxFile <- read.xlsx(file=fileName, sheetIndex = xth, encoding="UTF-8")
  xlsxFile %>% .[, c(1:11)] %>%
           `colnames<-`(c("區域別", "土地面積", "里數", "鄰數", "戶數", "每戶平均人口", "總計人口數", "男", "女", "性別比", "人口密度")) %>%
           filter(complete.cases(.)) %>% return
}

# download file
fileName <- "01臺南市歷年各區里數、鄰數、戶數、人口數、性別比例及人口密度統計表 (2).xls"
url <- "http://www.tainan.gov.tw/tn/agr/warehouse/I40000file/01%E8%87%BA%E5%8D%97%E5%B8%82%E6%AD%B7%E5%B9%B4%E5%90%84%E5%8D%80%E9%87%8C%E6%95%B8%E3%80%81%E9%84%B0%E6%95%B8%E3%80%81%E6%88%B6%E6%95%B8%E3%80%81%E4%BA%BA%E5%8F%A3%E6%95%B8%E3%80%81%E6%80%A7%E5%88%A5%E6%AF%94%E4%BE%8B%E5%8F%8A%E4%BA%BA%E5%8F%A3%E5%AF%86%E5%BA%A6%E7%B5%B1%E8%A8%88%E8%A1%A8%20(2).xls"
download(url, fileName, mode = "wb")

# main prog
df <- data.frame(區域名 = character(),
                    里數 = integer(),
                    鄰數 = integer(),
                    戶數 = integer(),
                    人口數 = integer(),
                    男 = integer(),
                    女 = integer(),
                    stringsAsFactors = FALSE)
pattern_date <- '\\d{2,3}.\\d{2}' 
sheetsList = loadWorkbook(fileName) %>% getSheets %>% names %>% str_extract(pattern_date)
nsheet <- length(sheetsList)
for (i in c(1:nsheet)) {
  data = cleanXls(fileName, i) %>% transform(年月 = sheetsList[i])
  df <- rbind(df, data)
}

# check data
View(df)
