library(tidyverse)
library(gapminder)
library(ggplot2)
library(dplyr)
library(broom)
library(reshape2)

#Read in your data
bleaching <- read_csv("pocillopora_bleaching.csv")
tank_conditions <- read_csv("Total_pH.csv")
fluorometry <- read_csv("PAM_Apoc2019.csv")
p_fluorometry <- read_csv("pocillopora_fluorescence.csv")

#trim unnecessary data from "bleaching"
trim_bleach <- subset(bleaching, select = -c(Total) )
long_bleach <- melt(trim_bleach, id.var=c("Temp","Days")) %>% group_by(Days)

#plot coral survival from the pocillopora experiment
coral_survival <- ggplot(long_bleach, aes(x = Temp, y = value, fill = variable)) + 
  geom_bar(position = "fill",stat = "identity") + 
  scale_y_continuous(labels = scales::percent_format()) + facet_wrap("Days") +
  ylab("Percent") + ggtitle("Percent of Pocillopora by Health Status post Infection \nafter a Number of Days")

#filter unnecessary data and NAs from the astrangia fluorometry data
filtered_fluor <- fluorometry %>% filter(complete.cases(.)) %>% group_by(T0.Color)
filtered_fluor[12] <- lapply(filtered_fluor[12], as.numeric)


#plot the Fv or photochemical efficiencies using a point plot
fluor_plot <- ggplot(filtered_fluor) + 
  geom_point(aes(x=Exp.Cond, y=Y, color=Timepoint)) + xlab("Experimental Condition") +
  ylab("Maximal PSII photochemical efficiency") + ggtitle("Maximal Photochemical Efficienty of Photosystem II in \nBreviolum psygmophilum Under Different Conditions")

#filter and group data sets for statistical significance
nlt1 <- filtered_fluor %>% .[which(filtered_fluor$Exp.Cond=="No.Light"),] %>%
  filter(Timepoint=="T1") 
nlt2 <- filtered_fluor %>% .[which(filtered_fluor$Exp.Cond=="No.Light"),] %>%
  filter(Timepoint=="T2")
lt1 <- filtered_fluor %>% .[which(filtered_fluor$Exp.Cond=="Light"),] %>%
  filter(Timepoint=="T1")
lt2 <- filtered_fluor %>% .[which(filtered_fluor$Exp.Cond=="Light"),] %>%
  filter(Timepoint=="T2")
lft1 <- filtered_fluor %>% .[which(filtered_fluor$Exp.Cond=="Light.Feed"),] %>%
  filter(Timepoint=="T1")
lft2 <- filtered_fluor %>% .[which(filtered_fluor$Exp.Cond=="Light.Feed"),] %>%
  filter(Timepoint=="T2")

time_nolight <- t.test(nlt1$Y,nlt2$Y)$p.value
time_light <- t.test(lt1$Y,lt2$Y)$p.value
time_lightfeed <- t.test(lft1$Y,lft2$Y)$p.value
nl_l <- t.test(nlt2$Y,lt2$Y)$p.value
nl_lf <- t.test(nlt2$Y,lft2$Y)$p.value

#filter the tank condition data set and remove the empty column
filtered_tank <- select(tank_conditions,-"Fed..Y.N.") %>% 
  filter(complete.cases(.)) %>% filter(pH.mV <= 0) %>% group_by(Tank)

#convert the Date field into a usable measure of time progression
filtered_tank$Days = 0
for (i in 1:length(filtered_tank$Date)) {
  filtered_tank$Days[i] = filtered_tank$Date[i] - 20190403
}

#plot tank conditions
temp <- ggplot(filtered_tank, aes(x=Days, y=Temp.C)) +
  geom_point() + facet_wrap("Tank") + geom_smooth(method = "lm")  

sal_to_ph <- ggplot(filtered_tank, aes(x=Sal.psu, y=pH.mV)) +
  geom_point() + facet_wrap("Tank") + geom_smooth(method = "lm") 



#plot the maximal fluorescence data from both data sets for comparison
ggplot() + geom_jitter(data=filtered_fluor, aes(x=T0.Color, y=Fm, color="Astrangia")) +
  geom_jitter(data=p_fluorometry, aes(x=T0.Color, y=Fm, color="Pocillopora")) + 
  xlab("Coral Bleaching Status") + ylab("Maximal Fluorescence") +
  ggtitle("Maximal Fluorescence of Pocillopora damicornis \nand Astrangia poculata")

#calculate statistical significance for tank condition linear models
regression_temp = do(filtered_tank, 
  glance(lm(Temp.C ~ Days, data = .)))

regression_sal_ph = do(filtered_tank, 
  glance(lm(pH.mV ~ Sal.psu, data = .)))


#statistical tests on maximal fluorescence
a_dark_filt <- filtered_fluor %>% filter(T0.Color == "Dark")
p_dark_filt <- p_fluorometry %>% filter(T0.Color == "Dark")
a_semi_filt <- filtered_fluor %>% filter(T0.Color == "Semi")
p_semi_filt <- p_fluorometry %>% filter(T0.Color == "Semi")

ap_dark <- t.test(a_dark_filt$Fm,p_dark_filt$Fm)$p.value
ap_semi <- t.test(a_semi_filt$Fm,p_semi_filt$Fm)$p.value
aa <- t.test(a_dark_filt$Fm,a_semi_filt$Fm)$p.value
pp <- t.test(p_dark_filt$Fm,p_semi_filt$Fm)$p.value

