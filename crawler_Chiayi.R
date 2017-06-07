 library(RSelenium)
 url= "http://pxweb.yunlin.gov.tw/Pxweb/Dialog/varval.asp?ma=Po0201A1A&ti=%A4g%A6a%AD%B1%BFn%A1B%B2{%A6%ED%A4%E1%BC%C6%A1B%A4H%A4f%B1K%AB%D7%A4%CE%A9%CA%A4%F1%A8%D2(%A6~)&path=../PXfile/CountyStatistics&lang=9&strList=L"
 remDr <- remoteDriver(
            remoteServerAddr = "localhost", 
            port = 4444, 
            browserName ="chrome"
          )
 remDr$open()           # open browser
 # remDr$getStatus()      # check the status of browser
 remDr$navigate(url)    # website to crawl
 