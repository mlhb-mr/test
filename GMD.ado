program define GMD
    version 14.0
    syntax [varlist] [, clear country(string)]
    
    * Base URL for the data
    local url "https://github.com/mlhb-mr/test/raw/refs/heads/main/GMD.dta"
    
    * Display package information
    display as text "Global Macro Database by Müller et. al (2025)"
    display as text "Website: https://www.globalmacrodata.com/"
    display as text ""
    
    * Load data with clear option always enabled
    if "`varlist'" == "" {
        use "`url'", clear
    }
    else {
        use ISO3 year countryname `varlist' using "`url'", clear
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
