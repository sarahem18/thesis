### Sarah McNitt
### American Community Survey data collection and management
### requires: unique Census API Key
### output: .dta
### last updated: 4/12/22

library(tidycensus)
library(tidyverse)
library(ipumsr)
library(foreign)

# census_api_key("67a66befd4336b438118da534bfb0cca6b1ef692", install=T)
data05 <- load_variables(2005, "acs1", cache=T)
acs_05 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2005,
                  survey = "acs1",
                  output = "wide")
data06 <- load_variables(2006, "acs1", cache=T)
acs_06 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2006,
                  survey = "acs1",
                  output = "wide")
data07 <- load_variables(2007, "acs1", cache=T)
acs_07 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2007,
                  survey = "acs1",
                  output = "wide")
data08 <- load_variables(2008, "acs1", cache=T)
acs_08 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2008,
                  survey = "acs1",
                  output = "wide")
data09 <- load_variables(2009, "acs1", cache=T)
acs_09 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2009,
                  survey = "acs1",
                  output = "wide")
data10 <- load_variables(2010, "acs1", cache=T)
acs_10 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2010,
                  survey = "acs1",
                  output = "wide")
data11 <- load_variables(2011, "acs1", cache=T)
acs_11 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2011,
                  survey = "acs1",
                  output = "wide")
data12 <- load_variables(2012, "acs1", cache=T)
acs_12 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2012,
                  survey = "acs1",
                  output = "wide")
data13 <- load_variables(2013, "acs1", cache=T)
acs_13 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2013,
                  survey = "acs1",
                  output = "wide")
data14 <- load_variables(2014, "acs1", cache=T)
acs_14 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2014,
                  survey = "acs1",
                  output = "wide")
data15 <- load_variables(2015, "acs1", cache=T)
acs_15 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2015,
                  survey = "acs1",
                  output = "wide")
data16 <- load_variables(2016, "acs1", cache=T)
acs_16 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2016,
                  survey = "acs1",
                  output = "wide")
data17 <- load_variables(2017, "acs1", cache=T)
acs_17 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2017,
                  survey = "acs1",
                  output = "wide")
data18 <- load_variables(2018, "acs1", cache=T)
acs_18 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2018,
                  survey = "acs1",
                  output = "wide")
data19 <- load_variables(2019, "acs1", cache=T)
acs_19 <- get_acs(geography = "state",
                  table = "B02001",
                  year = 2019,
                  survey = "acs1",
                  output = "wide")
## adding year variable to the end of each data set before bind
acs_05$year <- 2005
acs_06$year <- 2006
acs_07$year <- 2007
acs_08$year <- 2008
acs_09$year <- 2009
acs_10$year <- 2010
acs_11$year <- 2011
acs_12$year <- 2012
acs_13$year <- 2013
acs_14$year <- 2014
acs_15$year <- 2015
acs_16$year <- 2016
acs_17$year <- 2017
acs_18$year <- 2018
acs_19$year <- 2019
acs_all <- rbind(acs_05, acs_06, acs_07, acs_08, acs_09, acs_10, acs_11, acs_12, acs_13, acs_14, acs_15, acs_16, acs_17, acs_18, acs_19)
acs0519 <- acs_all[!(acs_all$GEOID==72),]

acs0519 <- acs0519 %>% 
  rename(
    fips = GEOID,
    total = B02001_001E,
    black_est = B02001_003E,
    state = NAME
  )

acs0519 <- acs0519 %>% relocate(year, .before = fips)
options(digits=2)
acs0519$fips = as.double(acs0519$fips)

write.dta(acs0519, "ACS0519.dta")
