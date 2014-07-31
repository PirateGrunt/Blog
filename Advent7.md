
```
## Error: object 'WrapWordpressUpload' not found
```



```r
library(RColorBrewer)
library(classInt)

MyChoropleth = function(sp, dem, palette, ...) {
    df = sp@data
    brks = classIntervals(df[, dem], n = length(palette), style = "quantile")
    brks = brks$brks
    
    sp$MyColor = palette[findInterval(df[, dem], brks, all.inside = TRUE)]
    plot(sp, col = sp$MyColor, axes = F, ...)
}
```

Carrying on from the last post, I'm going to take a closer look at election results for the 2012 US presidential election in North Carolina. This state's 15 electoral votes went to the Republican, Mitt Romney. On the US electoral college map, that means the state shows up as red. As I write this, I'm living in Durham, North Carolina- which is a city just slightly to the left of Leningrad. This part of the state is very blue indeed. How does the rest of the state look? I'll explore this in two steps. The first will color code the map based on the county election results I fetched yesterday. I'll then adjust the color based on the strength of county results. It's all well and good to blue, but who's more blue: Durham or Buncombe county?

First, note that the file I constructed yesterday is effectively "melted". It'll need to be cast so that we have only one row for each county. I'm the world's worst `reshape2` user, but even I can do that in one line of code. (How do I know I'm horrible at reshape2? Because I always assume that `dcast` is in the `plyr` package.)

```r
dfNC = read.csv("./Data/NorthCarolina2012.csv", stringsAsFactors = FALSE)
# NOTE THIS BUG FROM YESTERDAY!! MUST FIX THE CODE SO THAT COUNTIES WHOSE
# NAME ARE TWO WORDS ARE HANDLED PROPERLY
dfNC$CountyName[dfNC$CountyName == "New"] = "New Hanover"
head(dfNC)
```

```
##   CountyName    Candidate Party Votes
## 1   Alamance    M. Romney   GOP 37712
## 2   Alamance B. Obama (i)   Dem 28341
## 3   Alamance   G. Johnson   Lib   585
## 4  Alexander    M. Romney   GOP 12207
## 5  Alexander B. Obama (i)   Dem  4591
## 6  Alexander   G. Johnson   Lib   262
```

```r

library(reshape2)
dfNC = dcast(dfNC, CountyName ~ Party, sum, value.var = "Votes")
dfNC$Color = ifelse(dfNC$GOP > dfNC$Dem, "red", "blue")
head(dfNC)
```

```
##   CountyName   Dem   GOP Lib Color
## 1   Alamance 28341 37712 585   red
## 2  Alexander  4591 12207 262   red
## 3  Alleghany  1574  3378  73   red
## 4      Anson  6894  4125  53  blue
## 5       Ashe  4100  8207 179   red
## 6      Avery  1861  5708  88   red
```

```r

library(UScensus2010)
```

```
## Loading required package: maptools Loading required package: sp Checking
## rgeos availability: TRUE Loading required package: foreign
## 
## Package UScensus2010: US Census 2010 Suite of R Packages Version 0.11
## created on 2011-11-18.
## 
## Zack Almquist, University of California-Irvine ne
## 
## For citation information, type citation("UScensus2010"). Type
## help(package=UScensus2010) to get started.
```

```r
library(UScensus2010county)
```

```
## 
## UScensus2010county: US Census 2010 County Level Shapefiles and Additional
## Demographic Data 
## Version 1.00 created on 2011-11-06 
## copyright (c) 2011, Zack W. Almquist, University of California-Irvine
## Type help(package="UScensus2010county") to get started.
## 
## For citation information, type citation("UScensus2010county").
```

```r
data(north_carolina.county10)
spNC = get("north_carolina.county10")

spNC = merge(spNC, dfNC, by.x = "NAME10", by.y = "CountyName")
plot(spNC, col = spNC$Color)
```

![plot of chunk MapByCounty](figure/MapByCounty.png) 


And there we are in Durham, as blue as we were expecting. Folks familiar with North Carolina will recognize that most of the large population centers- areas near Raleigh and Charlotte- were also blue. Given that, just how close was the race here?


```r
totalDem = sum(dfNC$Dem)
totalGOP = sum(dfNC$GOP)
print(totalGOP - totalDem)
```

```
## [1] 97465
```

```r
print((totalGOP - totalDem)/(totalDem + totalGOP))
```

```
## [1] 0.02188
```


The GOP won by just over 97,000 votes, or a 2% margin. (I'm ignoring votes cast for 3rd party candidates. It pains me to do so, but we live in a two-party democracy.) Knowing that, how purple is North Carolina and where does it lean more red or blue?


```r
spNC$PctRed = spNC$GOP/(spNC$GOP + spNC$Dem)
myPalette = colorRampPalette(brewer.pal(11, "RdBu"))(101)
myPalette = rev(myPalette)
MyChoropleth(spNC, "PctRed", myPalette)
```

![plot of chunk PurpleMap](figure/PurpleMap.png) 

```r

print(spNC$NAME10[spNC$PctRed == min(spNC$PctRed)])
```

```
## [1] "Durham"
```


And, yes, I'm living in the most blue county in North Carolina. Take that, all you hippies in Asheville!

Tomorrow, I'll do some predictive modeling of election results by county using US Census data. Do old people skew Republican? Do childless urbanites vote democrats? Tomorrow, we'll know.


```r
citation("UScensus2010county")
```

```
## 
## To cite UScensus2000 in publications use:
## 
##   Zack W. Almquist (2010). US Census Spatial and Demographic Data
##   in R: The UScensus2000 Suite of Packages. Journal of Statistical
##   Software, 37(6), 1-31. URL http://www.jstatsoft.org/v37/i06/.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Article{,
##     title = {US Census Spatial and Demographic Data in {R}: The {UScensus2000} Suite of Packages},
##     author = {Zack W. Almquist},
##     journal = {Journal of Statistical Software},
##     year = {2010},
##     volume = {37},
##     number = {6},
##     pages = {1--31},
##     url = {http://www.jstatsoft.org/v37/i06/},
##   }
```

```r
sessionInfo()
```

```
## R version 3.0.2 (2013-09-25)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## 
## locale:
## [1] LC_COLLATE=English_United States.1252 
## [2] LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252
## [4] LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] UScensus2010county_1.00 UScensus2010_0.11       foreign_0.8-55         
## [4] maptools_0.8-27         sp_1.0-13               reshape2_1.2.2         
## [7] classInt_0.1-21         RColorBrewer_1.0-5      knitr_1.4.1            
## 
## loaded via a namespace (and not attached):
##  [1] class_7.3-9     digest_0.6.3    e1071_1.6-1     evaluate_0.4.7 
##  [5] formatR_0.9     grid_3.0.2      lattice_0.20-23 plyr_1.8       
##  [9] stringr_0.6.2   tools_3.0.2
```

