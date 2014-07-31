
```
## Error: object 'WrapWordpressUpload' not found
```

Some time back, I started a [project on GitHub](https://github.com/PirateGrunt/FinancialLiteracy) wherein I would explore the efficacy of financial literacy efforts in the area where I live. This is done with the support of a local non-profit organization.

As a first step, I tried to draw a picture of the area at a relatively fine level of detail. This relies on the UScensus suite of packages that I [wrote about](http://pirategrunt.com/2013/12/02/24-days-of-r-day-2-3/) a couple days ago. Today, we'll be looking at data for five counties in North Carolina at the level of a US census tract. First, we'll load up the data and see what levels of homeownership are.

```r
library("UScensus2010")
```

```
## Loading required package: maptools
## Loading required package: sp
## Checking rgeos availability: FALSE
##  	Note: when rgeos is not available, polygon geometry 	computations in maptools depend on gpclib,
##  	which has a restricted licence. It is disabled by default;
##  	to enable gpclib, type gpclibPermit()
## Loading required package: foreign
## 
## 
## Package UScensus2010: US Census 2010 Suite of R Packages
## Version 0.11 created on 2011-11-18.
## 
## Zack Almquist, University of California-Irvine
## ne
## 
## For citation information, type citation("UScensus2010").
## Type help(package=UScensus2010) to get started.
```

```r
library("UScensus2010tract")
```

```
## Error: there is no package called 'UScensus2010tract'
```

```r

durham = county(name = "durham", state = "nc", level = "tract")
```

```
## Loading required package: UScensus2010tract
```

```
## Warning: there is no package called 'UScensus2010tract'
## Warning: data set 'north_carolina.tract10' not found
```

```
## Error: object 'north_carolina.tract10' not found
```

```r
orange = county(name = "orange", state = "nc", level = "tract")
```

```
## Loading required package: UScensus2010tract
```

```
## Warning: there is no package called 'UScensus2010tract'
## Warning: data set 'north_carolina.tract10' not found
```

```
## Error: object 'north_carolina.tract10' not found
```

```r
wake = county(name = "wake", state = "nc", level = "tract")
```

```
## Loading required package: UScensus2010tract
```

```
## Warning: there is no package called 'UScensus2010tract'
## Warning: data set 'north_carolina.tract10' not found
```

```
## Error: object 'north_carolina.tract10' not found
```

```r
johnston = county(name = "johnston", state = "nc", level = "tract")
```

```
## Loading required package: UScensus2010tract
```

```
## Warning: there is no package called 'UScensus2010tract'
## Warning: data set 'north_carolina.tract10' not found
```

```
## Error: object 'north_carolina.tract10' not found
```

```r
chatham = county(name = "chatham", state = "nc", level = "tract")
```

```
## Loading required package: UScensus2010tract
```

```
## Warning: there is no package called 'UScensus2010tract'
## Warning: data set 'north_carolina.tract10' not found
```

```
## Error: object 'north_carolina.tract10' not found
```

```r

uwgt = spRbind(orange, durham)
```

```
## Error: error in evaluating the argument 'obj' in selecting a method for function 'spRbind': Error: object 'orange' not found
```

```r
uwgt = spRbind(uwgt, wake)
```

```
## Error: error in evaluating the argument 'obj' in selecting a method for function 'spRbind': Error: object 'uwgt' not found
```

```r
uwgt = spRbind(uwgt, johnston)
```

```
## Error: error in evaluating the argument 'obj' in selecting a method for function 'spRbind': Error: object 'uwgt' not found
```

```r
uwgt = spRbind(uwgt, chatham)
```

```
## Error: error in evaluating the argument 'obj' in selecting a method for function 'spRbind': Error: object 'uwgt' not found
```

```r

rm(durham, orange, wake, johnston, chatham)
```

```
## Warning: object 'durham' not found
## Warning: object 'orange' not found
## Warning: object 'wake' not found
## Warning: object 'johnston' not found
## Warning: object 'chatham' not found
```


Whether or not someone owns their home is a strong indicator of economic stability and the potential to retain and accumlate wealth. What percentage of folks own their own home?


```r
# Description of codes can be found in the documentation for the
# UScensus2010 package
uwgt$TotalPopulation = uwgt$H0030002
```

```
## Error: object 'uwgt' not found
```

```r
uwgt$pctHomeowner = 1 - uwgt$H0040004/uwgt$H0030002
```

```
## Error: object 'uwgt' not found
```

```r
plot(uwgt$pctHomeowner[order(uwgt$pctHomeowner)], pch = 19)
```

```
## Error: error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'uwgt' not found
```

```r
plot(uwgt$TotalPopulation, uwgt$pctHomeowner, pch = 19, xlab = "Total population", 
    ylab = "% Homeownership")
```

```
## Error: error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'uwgt' not found
```

We see that it runs the gamut from zero to 100% homeownership. We might assume that areas of higher population have lower percentages of home ownership. Such areas may be more densely populated and urbanized where people are likely to rent. However, there doesn't appear to be any relationship between the total population and home ownership. The construction of a census tract may have something to do with this. 

We'll recreate the choropleth helper function from two days ago so that we can map this data. We'll then draw a map that shows high and low concentrations of homeowners.

```r
library(RColorBrewer)
library(classInt)
```

```
## Error: there is no package called 'classInt'
```

```r

MyChoropleth = function(sp, dem, palette, ...) {
    df = sp@data
    brks = classIntervals(df[, dem], n = length(palette), style = "quantile")
    brks = brks$brks
    
    sp$MyColor = palette[findInterval(df[, dem], brks, all.inside = TRUE)]
    plot(sp, col = sp$MyColor, axes = F, ...)
}

myPalette = brewer.pal(9, "Blues")

MyChoropleth(uwgt, "pctHomeowner", myPalette, border = "transparent")
```

```
## Error: object 'uwgt' not found
```



```r
dfCountyColor = data.frame(county = c("135", "063", "183", "101", "037"), countyName = c("Orange", 
    "Durham", "Wake", "Johnston", "Chatham"), color = c("orange", "blue", "red", 
    "green", "yellow"))
uwgt = merge(uwgt, dfCountyColor)
```

```
## Error: error in evaluating the argument 'x' in selecting a method for function 'merge': Error: object 'uwgt' not found
```

There's a clear geographic distribution at work. In the central part of the map the area between Durham and Raleigh has lower levels of home ownership. These are more urbanized areas, which means they may have more young or transient residents. However, these are also areas of low wealth. We can see this when we load in data from the American Community Survey.


```r
setwd("~/GitHub/FinancialLiteracy/Data/ACS_11_5YR_B17005")
dfCensus = read.csv("ACS_11_5YR_B17005.csv", skip = 1)
marginOfError = grep("margin", colnames(dfCensus), ignore.case = TRUE)

dfCensus = dfCensus[, -marginOfError]
rm(marginOfError)

colnames(dfCensus) = gsub(".", "", colnames(dfCensus), fixed = TRUE)
colnames(dfCensus) = gsub("Estimate", "", colnames(dfCensus), fixed = TRUE)

uwgtACS = merge(uwgt, dfCensus, by.x = "fips", by.y = "Id2", all.x = TRUE)
```

```
## Error: error in evaluating the argument 'x' in selecting a method for function 'merge': Error: object 'uwgt' not found
```

```r
uwgtACS$pctNonPoverty = 1 - uwgtACS$Incomeinthepast12monthsbelowpovertylevel/uwgtACS$Total
```

```
## Error: object 'uwgtACS' not found
```

```r
par(mfrow = c(1, 2))
MyChoropleth(uwgtACS, "pctHomeowner", myPalette, border = "transparent")
```

```
## Error: object 'uwgtACS' not found
```

```r
title("% Homeowners")
```

```
## Error: plot.new has not been called yet
```

```r
MyChoropleth(uwgtACS, "pctNonPoverty", myPalette, border = "transparent")
```

```
## Error: object 'uwgtACS' not found
```

```r
title("% Above Poverty")
```

```
## Error: plot.new has not been called yet
```


Visually, there's evidence of a relationship, which we can establish through a simple linear model.

```r
plot(uwgtACS$pctNonPoverty, uwgtACS$pctHomeowner, pch = 19, xlab = "% Above Poverty", 
    ylab = "% Homeowners")
```

```
## Error: error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'uwgtACS' not found
```

```r
fit = lm(pctHomeowner ~ pctNonPoverty, data = uwgtACS)
```

```
## Error: object 'uwgtACS' not found
```

```r
summary(fit)
```

```
## Error: error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'fit' not found
```

```r
lines(uwgtACS$pctNonPoverty[!is.na(uwgtACS$pctNonPoverty)], predict(fit))
```

```
## Error: object 'uwgtACS' not found
```


Obviously, there are many other factors at play- marital status, available housing stock, zoning laws, size of family, type of employment- to name but a few. One thing I'd like to explore is the influence of county government on various statistics. Here's the same plot, with sample points color coded by county:

```r
uwgtACS$color = as.character(uwgtACS$color)
```

```
## Error: object 'uwgtACS' not found
```

```r
par(mfrow = c(1, 1))
plot(uwgtACS$pctNonPoverty, uwgtACS$pctHomeowner, pch = 19, xlab = "% Above Poverty", 
    ylab = "% Homeowners", col = uwgtACS$color)
```

```
## Error: error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'uwgtACS' not found
```

I'll explore that in a later post.

Tomorrow: not sure what I'll write about! Possibly the PISA testing results that were released this week.

```r
citation("UScensus2010tract")
```

```
## Error: package 'UScensus2010tract' not found
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
## [1] RColorBrewer_1.0-5 UScensus2010_0.11  foreign_0.8-55    
## [4] maptools_0.8-27    sp_1.0-14          knitr_1.5         
## 
## loaded via a namespace (and not attached):
## [1] evaluate_0.5.1  formatR_0.10    grid_3.0.2      lattice_0.20-23
## [5] stringr_0.6.2   tools_3.0.2
```

