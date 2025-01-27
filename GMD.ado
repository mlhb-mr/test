program define GMD
    version 14.0
    syntax [anything] [, clear country(string)]
    
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
    
    * Display package information
    display as text "Global Macro Database by Müller et. al (2025)"
    display as text "Website: https://www.globalmacrodata.com/"
    display as text ""
    
    * Set data path for main dataset
    local data_path "`pkg_dir'GMD.dta"
    
    * Try to load the dataset
    capture use "`data_path'", clear
    if _rc {
        display as error "Dataset (GMD.dta) not found in package directory"
        display as error "Please check if the package was installed correctly"
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
