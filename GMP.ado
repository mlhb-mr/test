program define GMP
    version 14.0
    syntax [anything] [, clear Version(string) Country(string)]
    
    * Set default version if not specified
    if "`version'" == "" {
        local version "2025_01"  // Default to latest version
    }
    
    * Validate version format (YYYY_QQ)
    if !regexm("`version'", "^20[0-9]{2}_(01|04|07|10)$") {
        display as error "Invalid version format. Use YYYY_QQ format (e.g., 2024_04, 2025_01)"
        display as error "Valid quarters are: 01, 04, 07, 10"
        exit 198
    }
    
    * Display package information
    display as text "Global Macro Data by Müller et. al (2025)"
    display as text "Version: `version'"
    display as text "Website: [placeholder for website]"
    display as text ""
    
    * Define paths
    local personal_dir = c(sysdir_personal)
    local vintages_dir "`personal_dir'/GMP/vintages/"
    local data_path "`vintages_dir'GMP_`version'.dta"
    
    * Create vintages directory if it doesn't exist
    capture mkdir "`vintages_dir'"
    
    * Check if requested version exists, if not, try to download it
    capture confirm file "`data_path'"
    if _rc {
        display as text "Dataset version `version' not found locally. Attempting to download..."
        
        * Base URL for dataset
        local base_url "https://github.com/mlhb-mr/test/raw/refs/heads/main/vintages"
        
        * Try to download the dataset
        capture copy "`base_url'/GMP_`version'.dta" "`data_path'", replace
        if _rc {
            display as error "Failed to download dataset version `version'"
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
