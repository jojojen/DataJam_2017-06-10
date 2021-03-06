# sessionInfo()
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
#   [1] RSelenium_1.7.1
# 
# loaded via a namespace (and not attached):
#   [1] httr_1.2.1       R6_2.2.1         assertthat_0.2.0 tools_3.3.2     
# [5] wdman_0.2.2      binman_0.1.0     curl_2.6         Rcpp_0.12.11    
# [9] jsonlite_1.4     caTools_1.17.1   openssl_0.9.6    bitops_1.0-6    
# [13] semver_0.2.0     XML_3.98-1.7 

# set working directory
oriDir <- getwd()
seleniumDir <- "./seleniumDownload"
ifelse(!dir.exists(file.path(seleniumDir)), dir.create(file.path(seleniumDir)), FALSE)
setwd(seleniumDir)

# install packages
pkgs.needs <- c("RSelenium", "dplyr")
pkgs.installed <- installed.packages()[,"Package"] 
new.pkgs <- pkgs.needs[!(pkgs.needs %in% pkgs.installed)]
if(length(new.packages)) install.packages(new.pkgs)                         
library(dplyr)     # data manipulation & pipe line
library(RSelenium) # selenium

# define function 
rm.quot <- function(x) {x %>% gsub('"', '', .) %>% return}
rm.dig <- function(x) {x %>% gsub('\\d', '', .) %>% return}

# set download folder 
downloadFolder <- getwd()
eCaps <- list(
  chromeOptions = 
    list(prefs = list(
      "profile.default_content_settings.popups" = 0L,
      "download.prompt_for_download" = FALSE,
      "download.default_directory" = downloadFolder
    )
    )
)
# set remote
url= "http://www.chiayi.gov.tw/pxweb2007P/Dialog/varval.asp?ma=Po0201A1A&ti=%B9%C5%B8q%A5%AB%AD%AB%ADn%B2%CE%ADp%B8%EA%AE%C6%AEw%ACd%B8%DF%A8t%B2%CE&path=../PXfile/CountyStatistics&lang=9&Flag=Q,_new"
remDr <- remoteDriver(
  remoteServerAddr = "localhost", 
  port = 4444, 
  browserName ="chrome",
  extraCapabilities=eCaps
)

# main prog
remDr$open()           # open browser
remDr$navigate(url)    # website to crawl
webElem <- remDr$findElements(value = "//tr//option")  # select all options
for (i in c(1:length(webElem))) {
  webElem[[i]]$clickElement()
}
webElem <- remDr$findElement(value = "//p/input")  # continue
webElem$clickElement()
webElem <- remDr$findElement(value = "//input[@name='prntcb']") # print csv
webElem$clickElement()
Sys.sleep(5)
fileName <- list.files()
df = readLines(fileName, encoding = "BIG5") %>% iconv("big5", "utf8") %>% 
     .[5:length(.)-1] %>% strsplit(., split=',', fixed=TRUE)
for (i in c(1:length(df))) {
  if (df[[i]][1] == '\" \"') {
    df[[i]][1] <- df[[i-1]][1] 
  }
}
df <- Filter(function(x) length(x) == 12, df)
df <- data.frame(matrix(unlist(df), nrow=length(df), byrow=T)) %>%
  lapply(., rm.quot) %>% as.data.frame
df$X2 <- df$X2 %>% lapply(., rm.dig)
df = df %>% transform(年月 = paste0(as.numeric(df$X1)-1911, ".12"))
colnames(df) <- c("西元年","區域名","土地面積","里數",'鄰數',"戶數","人口數","男","女","戶量(人/戶)","人口密度","性別比(男/女)","年月")
df$地區 <- "嘉義市"
df$區域名 = df$區域名 %>% as.character 
df$西元年 = df$西元年 %>% as.character 
df_std = df %>% .[, c("區域名","里數","鄰數","戶數","人口數","男","女","年月","地區")]

# output data and restore env
if (file.exists(fileName)) file.remove(fileName)
setwd(oriDir)
write.csv(df, "data_full_Chiayi_city.csv")
write.csv(df_std, "data_std_Chiayi_city.csv")