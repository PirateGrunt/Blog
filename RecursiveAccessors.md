Here's yet another example, where I just need to read the help files. Before I go on, I should add my own notion as to why that's not always easy to do. On loads of message boards, you'll see people say- correctly- the documentation is very clear on XYZ. True. But that's only relevant if you read the bit of the documentation that actually matters to you and you have all of the context you need to understand the terse (though accurate!) descriptions there. It's a bit like a bus schedule in Samarkand. Absolutely clear and useful if you're in central Asia and know where you are and where you need to go and when you need to get there. If you've been walking the Silk Road for weeks and can't tell Samarkand from Tashqent, that bus schedule may not do you as much good. So it is with R documentation sometimes. You'll have to dust off your shoes, get patient and ask a stranger for help.

So what I had wanted to do was to understand something fairly basic. How is the following statement processed:


```r
myObject$MyColumn[2] = "New value"
```


To investigate, I created a very simple object with easy properties that I could assign. 


```r
setClass("Person", representation(FirstName = "character", LastName = "character", 
    Birthday = "Date"))
```


I then created two easy access and set methods. For reasons that will become clear in a moment, I also added a statement to indicate when the methods had been called.


```r
setMethod("$", signature(x = "Person"), function(x, name) {
    print("Just called $ accessor")
    arguments <- as.list(match.call())
    slot(x, name)
})

setMethod("$<-", signature(x = "Person"), function(x, name, value) {
    print("Just called $ assignment")
    arguments <- as.list(match.call())
    slot(x, name) = value
    x
})
```


And I created a new object.


```r
objPeople = new("Person", FirstName = c("Ambrose", "Victor", "Jules"), LastName = c("Bierce", 
    "Hugo", "Verne"), Birthday = seq(as.Date("2001/01/01"), as.Date("2003/12/31"), 
    by = "1 year"))
```


So, I can access the properties and my methods will tell me when they've been accessed. I can also assign to the member and I'll be told when that happens as well.


```r
objPeople$FirstName
```

```
## [1] "Just called $ accessor"
```

```
## [1] "Ambrose" "Victor"  "Jules"
```

```r

objPeople$FirstName = "Joe"
```

```
## [1] "Just called $ assignment"
```


Now here's the interesting bit. (Interesting if you've just gotten to the train station in Samarkand and are trying to find your hotel. Not so interesting if you've been in Uzbekistan for a few weeks.)


```r
objPeople$FirstName[2] = "Joe"
```

```
## [1] "Just called $ accessor"
## [1] "Just called $ assignment"
```


The assignment produced a call to the accessor function? Why? The answer may be found in one of two places. One is the very clear, concise and speedy answer that I got to a question I posed on StackOverflow, which may be read [here](http://stackoverflow.com/questions/23862050/when-are-accessor-methods-for-s4-objects-called-in-r). Two is the R documentation, which may be found [here](http://cran.r-project.org/doc/manuals/r-release/R-lang.html#Subset-assignment).

This will tell us that the following two sets of statements are equivalent:

```r
objPeople$FirstName[2] = "Joe"

`*tmp*` <- objPeople
objPeople <- `$<-`(`*tmp*`, name = "FirstName", value = `[<-`(`*tmp*`$FirstName, 
    2, value = "Joe"))
```


So what's happening? When I want to assign to a subset, three things take place. First, I use my accessor to sort out precisely which value I'm extracting from. Next, I use bracket assignment to alter the elements of a subset of that vector. Finally, I assign the whole vector back to the component of my object. This is a bit easier to see, if we take the steps one at a time.


```r
gonzo = objPeople$FirstName
mojo = `[<-`(gonzo, 2, value = "Joe")
objPeople = `$<-`(objPeople, "FirstName", mojo)
```


This is why the accessor is not called if there is no subset in the assignment. In that case, the equivalent expression is simply the following:


```r
objPeople = `$<-`(objPeople, "FirstName", mojo)
```


Welcome to Uzbekistan. Please enjoy our fine network of busses.
