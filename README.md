# COVID-19 Cases/Deaths and Census Demography
**Author:** [David Benkeser](https://www.sph.emory.edu/faculty/profile/#!dbenkes)

-----

## Description

This repository includes a data set (`covid_demog_data.csv`) that I developed 
by combining the [New York Times COVID-19 data](https://github.com/nytimes/covid-19-data)
with the US Census Bureau's [Annual County Resident Population Estimates](https://www.census.gov/content/census/en/data/datasets/time-series/demo/popest/2010s-counties-detail.html) by 
Age, Sex, Race, and Hispanic Origin. 

Data were formatted into a wide format, where rows correspond 
to counties and columns correspond to features of counties. 

## Data dictionary

Details on census variable definitions can be found [here](https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2018/cc-est2018-alldata.pdf).
Details on New York Times data collection can be found [here](https://github.com/nytimes/covid-19-data). The census data were reformatted to include the most recent year's estimates
for each county (`YEAR = 11`, 7/1/2018 estimates) and results by age group were
reshaped into a wide format. Thus, each of the population-related variables described [here](https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2018/cc-est2018-alldata.pdf) appear in the data set with an 
addendum `.X`, where `X` indicates to which age group the variable corresponds. For example,
`TOT_POP.0` corresponds to the total population of county over all age groups, 
`TOT_POP.1` corresponds to the total population of the county with `AGEGRP = 1` (i.e., Age 0 to 4 years), `TOT_POP.2` corresponds to the total population of the county with `AGEGRP = 2` (i.e., Age 5 to 9 years), etc... 

The New York times data were downloaded on April 9, 2020 under [this commit](https://github.com/nytimes/covid-19-data/tree/41dc1b75f857720c223ec4db3b6fcac01a6eda79) and
include cumulative `DEATHS` and `CASES` through April 8, 2020. 

In accordance with the New York Times data, all data for New York City are
combined into a single row. Cases with unknown county of origin were removed from the data set. Kansas City cases were also removed, because I could not quite wrap my head around
how to handle them. 

## Disclaimers

Please note that I do not guarantee the data were generated with 100\% accuracy. 
The `R` script used to format the data is included here. These data are intended mainly
for pedagogical purposes and may not be suitable for e.g., academic publication. Please note 
and respect the New York Time's desire to be referenced in any publication related to their 
data. 

For questions or comments, please [email me](mailto:benkeser@emory.edu)


