library(readr)
library(dplyr)
library(data.table)

## Increase the time limit for downloads
options(timeout = 2000)

## Function to download 2024 World Population Prospects data
download_wpp24 <-
  function() {
    
    # Function to download and save a file with a warning if it already exists
    download_file <- 
      function(url, destfile) {
        if (file.exists(destfile)) { # Check if the file already exists
          warning(paste("The file", destfile, "already exists. Skipping download."))
        } else {
          download.file(url, destfile = destfile, mode = "wb")
        }
      }
    
    # Create data directory if it does not exist
    if (!dir.exists("data")) {
      dir.create("data")
    }
    
    # URLs for the data files
    url_fertility <- "https://population.un.org/wpp/Download/Files/1_Indicator%20(Standard)/CSV_FILES/WPP2024_Fertility_by_Age1.csv.gz"
    url_female_lifetable <- "https://population.un.org/wpp/Download/Files/1_Indicator%20(Standard)/CSV_FILES/WPP2024_Life_Table_Complete_Medium_Female_1950-2023.csv.gz" 
    url_male_lifetable <- "https://population.un.org/wpp/Download/Files/1_Indicator%20(Standard)/CSV_FILES/WPP2024_Life_Table_Complete_Medium_Male_1950-2023.csv.gz" 
    url_pop <- "https://population.un.org/wpp/Download/Files/1_Indicator%20(Standard)/CSV_FILES/WPP2024_Population1JanuaryBySingleAgeSex_Medium_1950-2023.csv.gz"
    
  
    # Read and save as CSV files if not already saved
    if (!file.exists("data/WPP2024_Fertility_by_Age1.csv")) {
      print("Reading Fertility")
      fertility <- fread(url_fertility)
      print("Saving Fertility")
      fwrite(fertility, "data/WPP2024_Fertility_by_Age1.csv", row.names = FALSE)
    } else {
      warning("Fertility data already saved as CSV. Skipping.")
    }
    
    if (!file.exists("data/WPP2024_Life_Table_Complete_Medium_Female_1950-2023.csv")) {
      print("Reading Female Life Table")
      mortality_female <- fread(url_female_lifetable)
      print("Saving Female Life Table")
      fwrite(mortality_female, "data/WPP2024_Life_Table_Complete_Medium_Female_1950-2023.csv", row.names = FALSE)
    } else {
      warning("Female mortality data already saved as CSV. Skipping.")
    }
    
    if (!file.exists("data/WPP2024_Life_Table_Complete_Medium_Male_1950-2023.csv")) {
      print("Reading Male Life Table")
      mortality_male <- fread(url_male_lifetable)
      print("Saving Male Life Table")
      fwrite(mortality_male, "data/WPP2024_Life_Table_Complete_Medium_Male_1950-2023.csv", row.names = FALSE)
    } else {
      warning("Male mortality data already saved as CSV. Skipping.")
    }
    
    if (!file.exists("data/WPP2024_Population1JanuaryBySingleAgeSex_Medium_1950-2023.csv")) {
      print("Reading Population")
      pop <- fread(url_pop)
      print("Saving Population")
      fwrite(pop, "data/WPP2024_Population1JanuaryBySingleAgeSex_Medium_1950-2023.csv", row.names = FALSE)
    } else {
      warning("Population data already saved as CSV. Skipping.")
    }
    
    # Return a message indicating the process is complete
    return("2024 World Population Prospects data downloaded and saved successfully as CSV files.")
}


#download_wpp24()
