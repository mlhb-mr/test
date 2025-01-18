program define GMP
    version 14.0
    syntax [anything] [, clear Version(string) Country(string)]
    
    * Set default version if not specified
    if "`version'" == "" {
        local version "2025_01"  // Default to current version
    }
    
    * Display package information
    display as text "Global Macro Data by Müller et. al (2025)"
    display as text "Version: `version'"
    display as text "Website: https://github.com/mlhb-mr/test"
    display as text ""
    
    * Define paths
    local personal_dir = c(sysdir_personal)
    local base_dir "`personal_dir'/GMP/"
    local vintages_dir "`base_dir'vintages/"
    
    * Create base and vintages directories if they don't exist
    capture mkdir "`base_dir'"
    capture mkdir "`vintages_dir'"
    
    * Set data path and download file name
    local data_path "`base_dir'GMP.dta"
    local download_file "GMP.dta"
    
    * Check if dataset exists, if not, try to download it
    capture confirm file "`data_path'"
    if _rc {
        display as text "Dataset `download_file' not found locally. Attempting to download..."
        
        * Base URL for dataset using correct GitHub raw URL format
        local base_url "https://github.com/mlhb-mr/test/raw/refs/heads/main"
        
        * Try to download the dataset
        capture copy "`base_url'/`download_file'" "`data_path'", replace
        if _rc {
            display as error "Failed to download dataset `download_file'"
            display as error "Please check if the version exists and your internet connection"
            exit _rc
        }
        display as text "Download complete."
    }
    
    * Load the dataset
    use "`data_path'", clear
    
    * Check if ISO3 and year variables exist
    foreach var in ISO3 year {
        capture confirm variable `var'
        if _rc {
            display as error "`var' variable not found in the dataset"
            exit 498
        }
    }
    
    * If country option is specified, filter for that country
    if "`country'" != "" {
        * Convert country code to uppercase for consistency
        local country = upper("`country'")
        
        * Check if the country exists in the dataset
        quietly: levelsof ISO3, local(countries)
        if !`: list country in countries' {
            display as error "Country code `country' not found in the dataset"
            display as text "Available country codes are: `countries'"
            exit 498
        }
        
        * Keep only specified country
        keep if ISO3 == "`country'"
        display as text "Filtered data for country: `country'"
    }
    
    * If user specified variables, keep only those plus ISO3 and year
    if "`anything'" != "" {
        * Create a local macro with all variables to keep
        local keepvars "ISO3 year `anything'"
        
        * Check if specified variables exist
        foreach var of local anything {
            capture confirm variable `var'
            if _rc {
                display as error "Variable `var' not found in the dataset"
                exit 498
            }
        }
        
        * Keep only specified variables plus ISO3 and year
        keep `keepvars'
        
        * Display success message with kept variables
        display as text "Dataset loaded with variables: `keepvars'"
    }
    else {
        display as text "Dataset loaded with all variables"
    }
    
    * Display final dataset dimensions
    quietly: describe
    display as text "Final dataset: `r(N)' observations of `r(k)' variables"
end
