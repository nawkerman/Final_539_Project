# Final_539_Project

This repository is an analysis performed in R comparing fluorometry measures obtained from two different coral species. One of the species is a more tropical coral, Pocillopora damicornis, and the other is a more temperate coral species found locally in the waters around Rhode Island, Astrangia poculata. Astrangia naturally occurs in asymbiotic varieties meaning it is not solely dependent on photorespiration like more tropical corals are leading to this comparison between the maximal fluorescence and photochemical efficiency of the two coral species and their symbionts. 

## Requirements

You will require R studio or some other R intrepreter in order to run the analysis. You will also need to have these packages installed in your R environment:
* tidyverse
* gapminder
* ggplot2
* dplyr
* broom
* reshape2

You can install these individually in your R environment with the install command. The rest of the analysis is detailed in the file titled "test_script.R".

## Files

The files contained in this repository are as such:

* Total_pH.csv: this is a dataset containing the tank conditions for the course of the Astrangia poculata experiment 
* pocillopora_bleaching.csv: this is a dataset containing the data for the time course infection of Pocillopora damicornis at different temperatures
* pocillopora_fluorescence.csv: this dataset contains the maximal fluorescence data for pocillopora damicornis along with chlorophyll levels
* PAM_Apoc2019.csv: this dataset consists of the PAM fluorometry data for Astrangia poculata for all dark brown and semi-bleached samples, data for bleached samples was often unreadable
* test_script.R: this is an R script file containing the raw code used to produce the analysis in the final output files
* Final_539_project.Rproj: the R project file used to contain and link all the scripts and datasets
* final_project.Rmd: the R markdown file used to write the report and analysis on this dataset
* final_project.pdf: the file containing the final report and figures for the coral fluorometry analysis
* README.md: this file
