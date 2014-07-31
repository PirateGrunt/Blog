installRWP = TRUE

if(installRWP){install.packages('RWordPress', repos = 'http://www.omegahat.org/R', type = 'source')}

library(RWordPress)
library(knitr)

options(WordpressLogin = c(UserName = 'myPassword'),
        WordpressURL = 'http://PirateGrunt.wordpress.com/xmlrpc.php')

WrapWordpressUpload = function(file){
  
  require(RWordPress)
  
  result = RWordPress::uploadFile(file)
  
  result$url
}

knit2wp('WrongStuff.Rmd', title = 'Stuff I\'ve gotten horribly wrong' , publish = FALSE, shortcode = TRUE)
