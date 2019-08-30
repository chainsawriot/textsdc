
<!-- README.md is generated from README.Rmd. Please edit that file -->
textsdc
=======

The goal of textsdc (text statistical data cleaning) is to clean text data statistically. The current version can do:

1.  text deduplication using a very simple similarity-based algorithm.

Future version should be able to do:

1.  removal of "boilerplates".

Related packages:

1.  [quanteda](https://github.com/quanteda/quanteda) - for text analysis
2.  [textclean](https://github.com/trinker/textclean) - for normalization of text data

Installation
------------

You can install the experimental version of textsdc from github:

``` r
devtools::install_github("chainsawriot/textsdc")
```

Example
-------

### Deduplication

Calculate the possible duplicates in your input text.

``` r
require(textsdc)
#> Loading required package: textsdc
demands <- c("Completely withdraw Extradition Bill",
             "Retract the proclamation that protests on 9th June and 12th June were riots",
             "Withdraw criminal charges against all protesters",
             "Thoroughly investigate abuse of powers by the police",
             "Dissolve the Legislative Council by administrative order, and immediately implement Dual Universal Suffrage",
             "Withdraw criminal charges against all protesters",
             "Dissolve the Legisative Council by administrative order, and immediately implement Dual Universal Suffrage")
dups <- calculate_duplication(demands)
dups
#> Text vector of length 7 with 1 duplicates.
```

``` r
dups$dist_matrix
#>           text1      text2     text3      text4     text5     text6
#> text1 1.0000000 0.00000000 0.2041241 0.00000000 0.0000000 0.2041241
#> text2 0.0000000 1.00000000 0.0000000 0.09128709 0.1380131 0.0000000
#> text3 0.2041241 0.00000000 1.0000000 0.00000000 0.0000000 1.0000000
#> text4 0.0000000 0.09128709 0.0000000 1.00000000 0.1889822 0.0000000
#> text5 0.0000000 0.13801311 0.0000000 0.18898224 1.0000000 0.0000000
#> text6 0.2041241 0.00000000 1.0000000 0.00000000 0.0000000 1.0000000
#> text7 0.0000000 0.13801311 0.0000000 0.18898224 0.9285714 0.0000000
#>           text7
#> text1 0.0000000
#> text2 0.1380131
#> text3 0.0000000
#> text4 0.1889822
#> text5 0.9285714
#> text6 0.0000000
#> text7 1.0000000
```

Adjust the threshold for duplication.

``` r
dups2 <- calculate_duplication(demands, threshold = 0.9)
dups2
#> Text vector of length 7 with 2 duplicates.
```

Extract the deduplicated version

``` r
get_deduplicated_version(dups2)
#> [1] "Completely withdraw Extradition Bill"                                                                       
#> [2] "Retract the proclamation that protests on 9th June and 12th June were riots"                                
#> [3] "Withdraw criminal charges against all protesters"                                                           
#> [4] "Thoroughly investigate abuse of powers by the police"                                                       
#> [5] "Dissolve the Legislative Council by administrative order, and immediately implement Dual Universal Suffrage"
```

You can also use percentile-based threshold, e.g. assuming 70% of the articles are not duplicates.

``` r
dups3 <- calculate_duplication(demands, threshold = 0.7, percentile = TRUE)
dups3
#> Text vector of length 7 with 2 duplicates.
```

``` r
get_deduplicated_version(dups3)
#> [1] "Completely withdraw Extradition Bill"                                                                       
#> [2] "Retract the proclamation that protests on 9th June and 12th June were riots"                                
#> [3] "Withdraw criminal charges against all protesters"                                                           
#> [4] "Thoroughly investigate abuse of powers by the police"                                                       
#> [5] "Dissolve the Legislative Council by administrative order, and immediately implement Dual Universal Suffrage"
```

CJK language

``` r
demands2 <- c("徹底撤回修例",
              "收回暴動定義",
              "撤銷對至今為止所有反送中抗爭者控罪",
              "徹底追究警隊濫權情況",
              "以行政命令解散立法會，立即實行雙真普選",
              "撤銷對至今為止所有反送中抗爭者控罪",
              "以命令解散立法會，立即實行雙真普選")
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

There are four precedence options on how to get the deduplicated version of the input text.

Default: earlier

``` r
metallica <- c("Unforgiven",
               "Unforgiven II",
               "Unforgiven III",
               "Fight Fire With Fire",
               "Master of Puppets",
               "For Whom The Bell Tolls",
               "For Whom The Bell Toll",
               "Master of Puppets")
metallica_dups <- calculate_duplication(metallica, threshold = 0.7)
get_deduplicated_version(metallica_dups)
#> [1] "Unforgiven"              "Fight Fire With Fire"   
#> [3] "Master of Puppets"       "For Whom The Bell Tolls"
```

Longer

``` r
get_deduplicated_version(metallica_dups, precedence = "longer")
#> [1] "Unforgiven III"          "Fight Fire With Fire"   
#> [3] "Master of Puppets"       "For Whom The Bell Tolls"
```

Shorter

``` r
get_deduplicated_version(metallica_dups, precedence = "shorter")
#> [1] "Unforgiven"             "Fight Fire With Fire"  
#> [3] "Master of Puppets"      "For Whom The Bell Toll"
```

Random

``` r
get_deduplicated_version(metallica_dups, precedence = "random")
#> [1] "Unforgiven"              "Fight Fire With Fire"   
#> [3] "Master of Puppets"       "For Whom The Bell Tolls"
```
