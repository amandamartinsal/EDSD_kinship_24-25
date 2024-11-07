library(readr)
library(dplyr)

# Function to load and filter UN World Population Prospects data for mortality (px) and fertility (fx)

UNWPP_data <-
  function(country, start_year, end_year, sex) {
  
  # Define file paths
  fertility_file <- "data/WPP2024_Fertility_by_Age1.csv"
  male_lifetable_file <- "data/WPP2024_Life_Table_Complete_Medium_Male_1950-2023.csv"
  female_lifetable_file <- "data/WPP2024_Life_Table_Complete_Medium_Female_1950-2023.csv"
  
  # Check if files exist
  if (!file.exists(fertility_file)) stop("Fertility data file not found: ", fertility_file)
  if (!file.exists(male_lifetable_file)) stop("Male life table data file not found: ", male_lifetable_file)
  if (!file.exists(female_lifetable_file)) stop("Female life table data file not found: ", female_lifetable_file)
  
  # Read the life table data
  WPP2024_male_lifetable <- read_csv(male_lifetable_file, show_col_types = FALSE)
  WPP2024_female_lifetable <- read_csv(female_lifetable_file, show_col_types = FALSE)
  
  # Combine male and female life table data
  WPP2024_lifetable <- bind_rows(WPP2024_female_lifetable, WPP2024_male_lifetable)
  
  # Filter life table data based on country, year range, and sex
  px <- WPP2024_lifetable %>%
    select(Location, Sex, Time, AgeGrpStart, px) %>%
    filter(Location == country, Time >= start_year, Time <= end_year, Sex == sex) %>%
    rename(year = Time, age = AgeGrpStart)
  
  # Initialize the final data
  if (sex == "Male") {
    data <- px
  } else if (sex == "Female") {
    # Process fertility data if sex is Female
    fertility_data <- read_csv(fertility_file, show_col_types = FALSE)
    
    asfr <- fertility_data %>%
      select(Location, Time, AgeGrpStart, ASFR) %>%
      mutate(ASFR = ASFR / 1000) %>%
      filter(Location == country, Time >= start_year, Time <= end_year) %>%
      rename(year = Time, age = AgeGrpStart, fx = ASFR)
    
    # Join and finalize the data with fertility rates
    data <- left_join(px, asfr, by = c("Location", "year", "age")) %>%
      mutate(fx = replace_na(fx, 0))
  } else {
    stop("Invalid sex. Please specify 'Male' or 'Female'.")
  }
  
  return(data)
}

# Function to load and filter UN World Population Prospects data for population (N)

UNWPP_pop <-
  function(country_name, start_year, end_year, sex) {
  
  # Read in population data
  WPP2024_pop <- read_csv("data/WPP2024_Population1JanuaryBySingleAgeSex_Medium_1950-2023.csv", show_col_types = FALSE)
  
  # Select the relevant population column based on sex
  if (sex == "Female") {
    wpp <- WPP2024_pop %>% 
      select(age = AgeGrpStart, country = Location, year = Time, pop = PopFemale)
  } else if (sex == "Male") {
    wpp <- WPP2024_pop %>% 
      select(age = AgeGrpStart, country = Location, year = Time, pop = PopMale)
  } else {
    stop("Invalid sex. Please specify 'Male' or 'Female'.") 
  }
  
  # Filter by country and reshape data
  wpp <- wpp %>% 
    filter(country == country_name, year >= start_year, year <= end_year) %>%
    pivot_wider(names_from = year, values_from = pop) %>%
    select(-age, -country) %>%
    as.matrix()
  
  # Add row names for age groups
  row.names(wpp) <- 0:(nrow(wpp) - 1)
  
  return(wpp)
}

# Example usage:
#data <-  UNWPP_data(country = "Brazil", start_year = 2015, end_year = 2015, sex = "Female")

#data_pop <- UNWPP_pop(country_name = "Brazil", start_year = 2015, end_year = 2020, sex = "Female")

