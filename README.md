
<!-- README.md is generated from README.Rmd. Please edit that file -->

# textsdc

The goal of textsdc (text statistical data cleaning) is to clean text
data statistically. The current version can do:

1.  text deduplication using a very simple similarity-based algorithm.

Future version should be able to do:

1.  removal of “boilerplates”.

Related packages:

1.  [quanteda](https://github.com/quanteda/quanteda) - for text analysis
2.  [textclean](https://github.com/trinker/textclean) - for
    normalization of text data

## Installation

You can install the experimental version of textsdc from github:

``` r
devtools::install_github("chainsawriot/textsdc")
```

## Example

### Deduplication

Calculate the possible duplicates in your input text.

``` r
require(textsdc)
```

``` r
lyrics <- c("He drinks a Whiskey drink",
            "he drinks a Vodka drink",
            "He drinks a Lager drink",
            "he drinks a Cider drink",
            "He sings the songs that remind him of the good times",
            "He sings the songs that remind him of the best times",
            "Oh Danny Boy",
            "Danny Boy",
            "Danny Boy",
            "I get knocked down, but I get up again",
            "You are never gonna keep me down",
            "I get knocked down, but I get up again",
            "You are never gonna keep me down",
            "I get knocked down, but I get up again",
            "You are never gonna keep me down",
            "I get knocked down, but I get up again",
            "You are never gonna keep me down")
dups <- calculate_duplication(lyrics)
dups
#> Text vector of length 17 with 7 duplicates.
```

``` r
dups$dist_matrix
#>            text1     text2     text3     text4     text5     text6     text7
#> text1  1.0000000 0.8000000 0.8000000 0.8000000 0.1240347 0.1240347 0.0000000
#> text2  0.8000000 1.0000000 0.8000000 0.8000000 0.1240347 0.1240347 0.0000000
#> text3  0.8000000 0.8000000 1.0000000 0.8000000 0.1240347 0.1240347 0.0000000
#> text4  0.8000000 0.8000000 0.8000000 1.0000000 0.1240347 0.1240347 0.0000000
#> text5  0.1240347 0.1240347 0.1240347 0.1240347 1.0000000 0.9230769 0.0000000
#> text6  0.1240347 0.1240347 0.1240347 0.1240347 0.9230769 1.0000000 0.0000000
#> text7  0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 1.0000000
#> text8  0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.8164966
#> text9  0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.8164966
#> text10 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text11 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text12 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text13 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text14 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text15 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text16 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text17 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#>            text8     text9    text10    text11    text12    text13    text14
#> text1  0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text2  0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text3  0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text4  0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text5  0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text6  0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text7  0.8164966 0.8164966 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text8  1.0000000 1.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text9  1.0000000 1.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> text10 0.0000000 0.0000000 1.0000000 0.1010153 1.0000000 0.1010153 1.0000000
#> text11 0.0000000 0.0000000 0.1010153 1.0000000 0.1010153 1.0000000 0.1010153
#> text12 0.0000000 0.0000000 1.0000000 0.1010153 1.0000000 0.1010153 1.0000000
#> text13 0.0000000 0.0000000 0.1010153 1.0000000 0.1010153 1.0000000 0.1010153
#> text14 0.0000000 0.0000000 1.0000000 0.1010153 1.0000000 0.1010153 1.0000000
#> text15 0.0000000 0.0000000 0.1010153 1.0000000 0.1010153 1.0000000 0.1010153
#> text16 0.0000000 0.0000000 1.0000000 0.1010153 1.0000000 0.1010153 1.0000000
#> text17 0.0000000 0.0000000 0.1010153 1.0000000 0.1010153 1.0000000 0.1010153
#>           text15    text16    text17
#> text1  0.0000000 0.0000000 0.0000000
#> text2  0.0000000 0.0000000 0.0000000
#> text3  0.0000000 0.0000000 0.0000000
#> text4  0.0000000 0.0000000 0.0000000
#> text5  0.0000000 0.0000000 0.0000000
#> text6  0.0000000 0.0000000 0.0000000
#> text7  0.0000000 0.0000000 0.0000000
#> text8  0.0000000 0.0000000 0.0000000
#> text9  0.0000000 0.0000000 0.0000000
#> text10 0.1010153 1.0000000 0.1010153
#> text11 1.0000000 0.1010153 1.0000000
#> text12 0.1010153 1.0000000 0.1010153
#> text13 1.0000000 0.1010153 1.0000000
#> text14 0.1010153 1.0000000 0.1010153
#> text15 1.0000000 0.1010153 1.0000000
#> text16 0.1010153 1.0000000 0.1010153
#> text17 1.0000000 0.1010153 1.0000000
```

Extract the deduplicated version

``` r
get_deduplicated_version(dups)
#>  [1] "He drinks a Whiskey drink"                           
#>  [2] "he drinks a Vodka drink"                             
#>  [3] "He drinks a Lager drink"                             
#>  [4] "he drinks a Cider drink"                             
#>  [5] "He sings the songs that remind him of the good times"
#>  [6] "He sings the songs that remind him of the best times"
#>  [7] "Oh Danny Boy"                                        
#>  [8] "Danny Boy"                                           
#>  [9] "I get knocked down, but I get up again"              
#> [10] "You are never gonna keep me down"
```

Adjust the threshold for duplication.

``` r
dups2 <- calculate_duplication(lyrics, threshold = 0.9)
dups2
#> Text vector of length 17 with 8 duplicates.
```

``` r
get_deduplicated_version(dups2)
#> [1] "He drinks a Whiskey drink"                           
#> [2] "he drinks a Vodka drink"                             
#> [3] "He drinks a Lager drink"                             
#> [4] "he drinks a Cider drink"                             
#> [5] "He sings the songs that remind him of the good times"
#> [6] "Oh Danny Boy"                                        
#> [7] "Danny Boy"                                           
#> [8] "I get knocked down, but I get up again"              
#> [9] "You are never gonna keep me down"
```

You can also use percentile-based threshold, e.g. assuming 70% of the
articles are not duplicates.

``` r
dups3 <- calculate_duplication(lyrics, threshold = 0.7, percentile = TRUE)
dups3
#> Text vector of length 17 with 13 duplicates.
```

``` r
get_deduplicated_version(dups3)
#> [1] "He drinks a Whiskey drink"             
#> [2] "Oh Danny Boy"                          
#> [3] "I get knocked down, but I get up again"
#> [4] "You are never gonna keep me down"
```

CJK language

``` r
demands2 <- c("徹底撤回修例",
              "收回暴動定義",
              "撤銷對至今為止所有反送中抗爭者控罪",
              "徹底追究警隊濫權情況",
              "以行政命令解散立法會，立即實行雙真普選",
              "撤銷對至今為止所有反送中抗爭者控罪",
              "解散立法會，立即實行雙真普選")
dups4 <- calculate_duplication(demands2, threshold = 0.7, percentile = TRUE)
dups4
#> Text vector of length 7 with 2 duplicates.
```

``` r
get_deduplicated_version(dups4)
#> [1] "徹底撤回修例"                          
#> [2] "收回暴動定義"                          
#> [3] "撤銷對至今為止所有反送中抗爭者控罪"    
#> [4] "徹底追究警隊濫權情況"                  
#> [5] "以行政命令解散立法會，立即實行雙真普選"
```

There are four precedence options on how to get the deduplicated version
of the input text.

Default: earlier

``` r
metallica <- c("The Unforgiven",
               "The Unforgiven II",
               "The Unforgiven III",
               "Fight Fire With Fire",
               "Master of Puppets",
               "For Whom The Bell Tolls",
               "For Whom The Bell Toll",
               "Master of Puppets")
metallica_dups <- calculate_duplication(metallica, threshold = 0.7)
get_deduplicated_version(metallica_dups)
#> [1] "The Unforgiven"          "Fight Fire With Fire"   
#> [3] "Master of Puppets"       "For Whom The Bell Tolls"
```

Longer

``` r
get_deduplicated_version(metallica_dups, precedence = "longer")
#> [1] "The Unforgiven III"      "Fight Fire With Fire"   
#> [3] "Master of Puppets"       "For Whom The Bell Tolls"
```

Shorter

``` r
get_deduplicated_version(metallica_dups, precedence = "shorter")
#> [1] "The Unforgiven"         "Fight Fire With Fire"   "Master of Puppets"     
#> [4] "For Whom The Bell Toll"
```

Random

``` r
get_deduplicated_version(metallica_dups, precedence = "random")
#> [1] "The Unforgiven"         "Fight Fire With Fire"   "For Whom The Bell Toll"
#> [4] "Master of Puppets"
```
