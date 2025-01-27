program define GMD
    version 14.0
    syntax [varlist] [, country(string)]
    
    * Base URL for the data
    local url "https://github.com/mlhb-mr/test/raw/refs/heads/main/GMD.dta"
    
    * Display package information
    display as text "Global Macro Database by Müller et. al (2025)xx"
    display as text "Website: https://www.globalmacrodata.com/"
    display as text ""
    di "`varlist'"
    * Clear any existing data first
    clear
    
    * Load data based on whether variables are specified
    if "`varlist'" == "" {
        quietly use "`url'"
    }
    else {
        quietly use ISO3 year countryname `varlist' using "`url'"
    }
    
    * If country specified, filter for that country
    if "`country'" != "" {
        local country = upper("`country'")
        quietly keep if ISO3 == "`country'"
        
        * Check if any observations remain
        quietly count
        if r(N) == 0 {
            display as error "No data found for country code: `country'"
            exit 498
        }
        
        display as text "Filtered data for country: `country'"
    }
    
    * Display final dataset dimensions
    quietly: describe
    display as text "Final dataset: `r(N)' observations of `r(k)' variables"
end
