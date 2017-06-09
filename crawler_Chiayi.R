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
url= "http://townweb.cyhg.gov.tw/pxweb/Dialog/varval.asp?ma=Po0301A1M&ti=%B9%C5%B8q%BF%A4%AD%AB%ADn%B2%CE%ADp%B8%EA%AE%C6%AEw%ACd%B8%DF%A8t%B2%CE&path=../PXfile/CountyStatistics&lang=9&Flag=Q"
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
fileName <- list.files()
df <- readLines(fileName[1])
df <- read.delim(fileName[4])

df <- readLines(file(fileName[4], encoding = "BIG5"))
data <- read.csv(textConnection(df), header = TRUE, stringsAsFactors = FALSE)

df
# output data and restore env
setwd(oriDir)
write.csv(df, "data_full_Chiayi.csv")
write.csv(df_std, "data_std_Chiayi.csv")