## ----setup, echo=FALSE---------------------------------------------------
opts_knit$set(upload.fun = WrapWordpressUpload, base.url = NULL) 
opts_chunk$set(fig.width=5, fig.height=5, cache=FALSE)


## ----MapHelpers----------------------------------------------------------
library(RColorBrewer)
library(classInt)

MyChoropleth = function(sp, dem, palette, ...){
  df = sp@data
  brks = classIntervals(df[, dem], n=length(palette), style="quantile")
  brks = brks$brks

  sp$MyColor = palette[findInterval(df[, dem], brks, all.inside=TRUE)]
  plot(sp, col=sp$MyColor, axes=F, ...)
}



## ----MapByCounty, fig.width=10, warning = FALSE--------------------------
dfNC = read.csv("./Data/NorthCarolina2012.csv", stringsAsFactors = FALSE)
# NOTE THIS BUG FROM YESTERDAY!! MUST FIX THE CODE SO THAT COUNTIES WHOSE NAME ARE TWO WORDS ARE HANDLED PROPERLY
dfNC$CountyName[dfNC$CountyName == "New"] = "New Hanover"
head(dfNC)

library(reshape2)
dfNC = dcast(dfNC, CountyName ~ Party, sum, value.var = "Votes")
dfNC$Color = ifelse(dfNC$GOP > dfNC$Dem, "red", "blue")
head(dfNC)

library(UScensus2010)
library(UScensus2010county)
data(north_carolina.county10)
spNC = get("north_carolina.county10")

spNC = merge(spNC, dfNC, by.x = "NAME10", by.y = "CountyName")
plot(spNC, col = spNC$Color)


## ----TotalVotes----------------------------------------------------------
totalDem = sum(dfNC$Dem)
totalGOP = sum(dfNC$GOP)
print(totalGOP - totalDem)
print((totalGOP - totalDem) / (totalDem + totalGOP))


## ----PurpleMap, warning = FALSE, fig.width=10----------------------------
spNC$PctRed = spNC$GOP / (spNC$GOP + spNC$Dem)
myPalette = colorRampPalette(brewer.pal(11,"RdBu"))(101)
myPalette = rev(myPalette)
MyChoropleth(spNC, "PctRed", myPalette)

print(spNC$NAME10[spNC$PctRed == min(spNC$PctRed)])


## ----SessionInfo---------------------------------------------------------
citation("UScensus2010county")
sessionInfo()


