program define GMP
    version 14.0
    syntax [anything] [, clear Country(string)]
    
    * URL with dataset name
    local url "https://github.com/mlhb-mr/test/raw/refs/heads/main/GMP_2025_01.dta"
    
    * Display package information
    display as text "Global Macro Data by Müller et. al (2025)"
    display as text "Version: 2025_01"
    display as text "Website: [placeholder for website]"
    display as text ""
    
    * Define path to dataset
    local personal_dir = c(sysdir_personal)
    local data_path "`personal_dir'GMP_data.dta"
    
    * Check if dataset exists
    capture confirm file "`data_path'"
    if _rc {
        display as error "Dataset not found. There might have been an error during package installation."
        display as error "Please reinstall the package using: net install gmp, from(https://raw.githubusercontent.com/mlhb-mr/test/main/) replace"
        exit 601
    }
    
    * Load the dataset
    use "`data_path'", clear
    
    * Rest of your original code remains the same
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
