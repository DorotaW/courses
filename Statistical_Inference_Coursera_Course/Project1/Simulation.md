<!-- rmarkdown v1 -->

---
title: "Simulation of Central Limit Theorem"
author: "Dorota"
date: "21 June 2015"
output: pdf_document
---



## Overview

By performing simulations in R we will show that average of n exponentialy distributed variables is approximately normal with mean 1/lambda and the standard deviation 1/(lambda*sqrt(n)). 
It will visually present the central limit theorem, that states that the distribution of average of a large number of independent, identically distributed variables will be approximately normal, regardless of the underlying distribution.

## Simulations: 

We wil perform 1000 simulation. The variable we simulate is average of 40 variables, exponentialy distributed with lambda 0.2.

```r
set.seed(7)
mns = NULL
lambda=0.2
n=40
for (i in 1 : 1000) mns = c(mns, mean(rexp(n,lambda)))
mns<-as.data.frame(merge('Sample',mns))
colnames(mns)<-c('Legend','val')
```

## Sample Mean versus Theoretical Mean

Below we can compare sample mean (4.98) vs theoretical mean of exponentialy distributed variables (` r round(as.numeric( 1/lambda),2)`


```r
# calculate mean
mean=as.data.frame(merge('Sample', as.numeric(mean(mns$val,na.rm=T))))
mean=rbind(mean,merge('Theoretical',as.numeric( 1/lambda)))
colnames(mean)<-c('Legend','mean_val')

#plot
library(ggplot2)
ggplot(data=mns,aes(x=val,colour=Legend)) +
geom_density() +
geom_vline(data=mean, aes(xintercept=mean_val, colour=Legend),linetype="dashed", size=1) +
theme(legend.position="bottom") + 
labs(title="Theoretical and Sample Mean") +  
guides(fill=guide_legend(title='St Deviation'))
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png) 





