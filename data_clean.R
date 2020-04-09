# formatting covid data for bios 511
data_dir <- "~/Dropbox/Emory/Teaching/BIOS511_2020/covid/"

# census data
# downloaded from https://www2.census.gov/programs-surveys/popest/datasets/2010-2018/counties/asrh/cc-est2018-alldata.csv
# data dictionary: https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2018/cc-est2018-alldata.pdf
full_cens_data <- read.csv(file.path(data_dir, "cc-est2018-alldata.csv"))

# combine state and county fip code
zero_pad_county <- sprintf("%03d", full_cens_data$COUNTY)
zero_pad_state <- sprintf("%02d", full_cens_data$STATE)
my_fip <- paste0(zero_pad_state, zero_pad_county)

# subset to most recent year
recent_cens_data <- by(full_cens_data, my_fip, function(x){
	x[x$YEAR == max(x$YEAR),]
})
dat <- Reduce(rbind, recent_cens_data)

# reshape to wide
wide_dat <- reshape(dat, timevar = "AGEGRP", 
                    idvar = c("SUMLEV", "STATE", "COUNTY", "STNAME", "CTYNAME", "YEAR"),
                    direction = "wide")

# combine state and county fip code
zero_pad_county <- sprintf("%03d", wide_dat$COUNTY)
zero_pad_state <- sprintf("%02d", wide_dat$STATE)
my_fip <- paste0(zero_pad_state, zero_pad_county)
wide_dat$FIPS <- my_fip

# need to combine all NY burroughs
ny_burroughs <- c("New York County", "Kings County", "Queens County", "Bronx County", "Richmond County")
all_nyc <- wide_dat[wide_dat$STNAME == "New York" & wide_dat$CTYNAME %in% ny_burroughs,]
collapse_nyc_data <- apply(all_nyc[,7:(ncol(all_nyc) - 1)], 2, sum)
nyc_data <- data.frame(SUMLEV = 50, 
                       STATE = 36, 
                       COUNTY = NA, 
                       STNAME = "New York",
                       CTYNAME = "New York City", 
                       YEAR = 11, 
                       as.list(collapse_nyc_data),
                       FIPS = 99999)
wide_dat <- rbind(wide_dat, nyc_data)
wide_dat <- wide_dat[-which(wide_dat$STNAME == "New York" & wide_dat$CTYNAME %in% ny_burroughs), ]

# new york times data downloaded https://github.com/nytimes/covid-19-data/blob/master/us-counties.csv
# commit 41dc1b75f857720c223ec4db3b6fcac01a6eda79
covid_data <- read.csv(file.path(data_dir, "us-counties.csv"))

#subset data to 04/08/2020
recent_covid_data <- covid_data[covid_data$date == "2020-04-08", ]

#format
colnames(recent_covid_data) <- c("DATE", "CTYNAME", "STNAME", "FIPS", "CASES", "DEATHS")
recent_covid_data[recent_covid_data$STNAME == "New York" & recent_covid_data$CTYNAME == "New York City", "FIPS"] <- 99999

# zero pad
recent_covid_data$FIPS <- sprintf("%05d", recent_covid_data$FIPS)

recent_covid_data <- recent_covid_data[-which(recent_covid_data$FIPS == "000NA"),]
# try to merge
merge_data <- merge(x = recent_covid_data[,c("FIPS","CASES","DEATHS")], 
                    y = wide_dat, 
                    by = c("FIPS"), 
                    all.y = TRUE, all.x = FALSE)
# assume 0 deaths if none reported
merge_data$DEATHS[is.na(merge_data$DEATHS)] <- 0
merge_data$CASES[is.na(merge_data$CASES)] <- 0

# save file
write.csv(merge_data, file = file.path(data_dir, "covid_demog_data.csv"))