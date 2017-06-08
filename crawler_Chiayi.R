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
# install.packages("RSelenium")

library(RSelenium)

url= "http://pxweb.yunlin.gov.tw/Pxweb/Dialog/varval.asp?ma=Po0201A1A&ti=%A4g%A6a%AD%B1%BFn%A1B%B2{%A6%ED%A4%E1%BC%C6%A1B%A4H%A4f%B1K%AB%D7%A4%CE%A9%CA%A4%F1%A8%D2(%A6~)&path=../PXfile/CountyStatistics&lang=9&strList=L"
remDr <- remoteDriver(
          remoteServerAddr = "localhost", 
          port = 4444, 
          browserName ="chrome"
        )
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
