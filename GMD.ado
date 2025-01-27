program define GMD
    version 14.0
    syntax [anything] [, clear Version(string) Country(string)]
    
    * Get the directory where the ado file is installed
    local ado_dir : sysdir PLUS
    local pkg_dir "`ado_dir'/g/"
    
    * Check if isomapping is specifically requested
    if "`anything'" == "isomapping" {
        capture use "`pkg_dir'isomapping.dta", clear
        if _rc {
            display as error "Could not find isomapping.dta in the package directory"
            exit _rc
        }
        exit
    }
    
    * Determine current version for display purposes only
    local current_date = date(c(current_date), "DMY")
    local current_year = year(date(c(current_date), "DMY"))
    local current_month = month(date(c(current_date), "DMY"))
    
    * Determine quarter based on current month (for display only)
    if `current_month' <= 3 {
        local quarter "01"
    }
    else if `current_month' <= 6 {
        local quarter "04"
    }
    else if `current_month' <= 9 {
        local quarter "07"
    }
    else {
        local quarter "10"
    }
    
    local current_version "`current_year'_`quarter'"
    
    * Set default version if not specified
    if "`version'" == "" {
        local version "current"
    }
    
    * Validate version format if not current
    if "`version'" != "current" {
        if !regexm("`version'", "^20[0-9]{2}_(01|04|07|10)$") {
            display as error "Invalid version format. Use YYYY_QQ format (e.g., 2024_04) or 'current'"
            display as error "Valid quarters are: 01, 04, 07, 10"
            exit 198
        }
    }
    
    * Display package information
    display as text "Global Macro Database by Müller et. al (2025)"
    display as text "Version: `current_version'"
    display as text "Website: https://www.globalmacrodata.com/"
    display as text ""
    
    * Set data path based on version
    if "`version'" == "current" {
        local data_path "`pkg_dir'GMD.dta"
    }
    else {
        local data_path "`pkg_dir'vintages/GMD_`version'.dta"
    }
    
    * Try to load the dataset
    capture use "`data_path'", clear
    if _rc {
        if "`version'" == "current" {
            display as error "Current version dataset (GMD.dta) not found in package directory"
        }
        else {
            display as error "Version `version' (GMD_`version'.dta) not found in vintages directory"
        }
        display as error "Please check if the version exists and if the package was installed correctly"
        exit _rc
    }
    
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
            display as text "To see a list of valid country codes and full country names, type:"
            display as input "GMD isomapping"
            exit 498
        }
        
        * Keep only specified country
        keep if ISO3 == "`country'"
        display as text "Filtered data for country: `country'"
    }
    
    * If user specified variables, keep only those plus ISO3 and year
    if "`anything'" != "" & "`anything'" != "isomapping" {
        * Create a local macro with all variables to keep
        local keepvars "ISO3 year countryname `anything'"
        
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
    else if "`anything'" != "isomapping" {
        display as text "Dataset loaded with all variables"
    }
    
    * Display final dataset dimensions
    quietly: describe
    display as text "Final dataset: `r(N)' observations of `r(k)' variables"
end
