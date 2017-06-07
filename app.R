# set working directory
oriDir <- getwd()
mainDir <- "/Users/jen/Documents/DataJam_2017-06-10"
setwd(mainDir)

# main prog
rlist <- list.files(pattern = "crawler")
for (r in rlist) {source(r, echo = TRUE)}
df <- data.frame()
dlist <- list.files(pattern = "data_std") 
for (d in dlist) {
  data = read.csv(d) %>% .[, -1]
  df <- rbind(df, data)
}

# output data and restore env
write.csv(df, "result_std.csv")
setwd(oriDir)