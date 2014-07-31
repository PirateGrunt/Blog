## ----setup, echo=FALSE---------------------------------------------------
opts_knit$set(upload.fun = WrapWordpressUpload, base.url = NULL) 
opts_chunk$set(fig.width=5, fig.height=5, cache=FALSE)


## ----FetchHTMLfile-------------------------------------------------------
library(XML)

URL = "http://www.politico.com/2012-election/results/president/north-carolina/"
content.raw = htmlParse(URL, useInternalNodes = TRUE)


## ----GetCountyTables-----------------------------------------------------
tables <- getNodeSet(content.raw, "//table") 
counties = getNodeSet(tables[[2]], "//tbody")
counties = counties[-1]

countyTables = lapply(counties, readHTMLTable, header = FALSE, stringsAsFactors = FALSE)


## ----ShowWrongTable------------------------------------------------------
head(countyTables[[1]])


## ----HelperFunctions-----------------------------------------------------
GetCountyName = function(dfCounty){
  strCounty = dfCounty[1,1]
  strCounty = strsplit(strCounty, " ")
  strCounty[[1]][1]
}

MungeTable = function(dfCounty){
  
  if (ncol(dfCounty) != 5 ) return (data.frame())
  
  dfCounty[1, 1]= GetCountyName(dfCounty)

  dfCounty[-1, 2:5] = dfCounty[-1, 1:4]
  
  dfCounty[, 1] = dfCounty[1, 1]
  
  colnames(dfCounty) = c('CountyName', 'Candidate', 'Party', 'Pct', 'Votes')
  
  dfCounty$Votes = gsub(",", "", dfCounty$Votes)
  dfCounty$Votes = as.numeric(dfCounty$Votes)
  
  dfCounty$Pct = NULL
  
  dfCounty
}

correctTable = MungeTable(countyTables[[1]])
head(correctTable)


## ----MungeCounties-------------------------------------------------------
counties = lapply(countyTables, MungeTable)
dfNorthCarolina = do.call("rbind", counties)

write.csv(dfNorthCarolina, "./Data/NorthCarolina2012.csv", row.names = FALSE)

## ----PlotResults, , fig.width = 10---------------------------------------
library(ggplot2)
ggplot(dfNorthCarolina, aes(x = CountyName, y = Votes, fill = Party)) + geom_bar(stat = "identity")


## ----SessionInfo---------------------------------------------------------
sessionInfo()


