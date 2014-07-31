library(XML)

http://beckmw.wordpress.com/tag/parse/
  http://stackoverflow.com/questions/5830705/web-scraping-in-r
  
URL = "http://www.imdb.com/name/nm0000323/?ref_=fn_al_nm_1#actor"
content.raw = htmlTreeParse(URL, useInternalNodes = TRUE)

myXpath = "//div[@data-category = 'actor']"
myXpath = "//div[@id = 'filmo-head-actor']"
myXpath = "//div[@id = 'filmography']"
actor = getNodeSet(content.raw, path=myXpath)
actor = xmlChildren(actor[[1]])

films = actor[[4]]

years = xpathSApply(films, path="//span[@class='year_column']", xmlValue)
years = gsub("[[:alpha:]]", "", years)
years = gsub("[[:space:]]", "", years)

years = as.numeric(years)

mojo = xpathSApply(years, xmlValue)

data-category = "actor"

ExtractTitle = function(node){
  
  childNode = xmlChildren(node)
  if (length(childNode) == 0) return (character(0))
  
  childNode = childNode[[1]]
  
  link = xmlGetAttr(childNode, "href")
  if (is.null(link)) return (character(0))

  if (grepl("title", link)){
    movieTitle = xmlValue(childNode)
    return (movieTitle)
  } else {
    return (character(0))
  }
}

title = ExtractTitle(nodes[[100]])
titles = sapply(nodes, ExtractTitle)
mojo = do.call("rbind", titles)
evenYears = getNodeSet(works, path = "//div[@class='filmo-row even']")
oddYears = getNodeSet(works, path = "//div[@class='filmo-row odd']")
films = sapply(years, getSibling)