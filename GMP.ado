program define GMP
    version 14.0
    syntax [anything] [, clear Country(string)]
    
    * Define paths
    local personal_dir = c(sysdir_personal)
    local data_path "`personal_dir'GMP_data.dta"
    local url "https://github.com/mlhb-mr/test/raw/refs/heads/main/GMP.dta"
    
    * Check if dataset exists locally
    capture confirm file "`data_path'"
    if _rc {
        * Dataset not found locally - download it
        display as text "Downloading dataset for first use..."
        
        capture copy "`url'" "`data_path'", replace public
        if _rc {
            display as error "Failed to download the dataset"
            exit _rc
        }
        display as text "Dataset successfully downloaded and stored locally"
    }
    
    * Load the local dataset
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
