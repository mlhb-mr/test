program define GMD
    version 14.0
    syntax [anything] [, clear Version(string) Country(string)]
    
    * Display package header
    display as text _n(2) "Global Macro Data by Müller et. al (2025)"
    display as text "Version: " _continue
    display as result "1.1.0 (macOS compatible)"
    display as text "Website: {browse https://www.globalmacrodata.com/}" _n

    * OS detection for path handling
    local os = c(os)
    local pathsep = cond(c(os) == "MacOSX", "/", "/") 

    * Determine current version
    local current_date = date(c(current_date), "DMY")
    local current_year = year(`current_date')
    local current_month = month(`current_date')
    local quarter = ceil(`current_month'/3)*3 - 2
    local current_version "`current_year'_`=string(`quarter',"%02.0f")'"

    * Version validation
    if "`version'" == "" local version "current"
    if "`version'" != "current" & !regexm("`version'", "^20[0-9]{2}_(01|04|07|10)$") {
        display as error "Invalid version format. Valid formats:"
        display as error "- 'current'"
        display as error "- YYYY_QQ (e.g., 2024_04)"
        exit 198
    }

    * Configure paths with OS-aware handling
    local personal_dir = c(sysdir_personal)
    local base_dir "`personal_dir'GMD`pathsep'"
    local vintages_dir "`base_dir'vintages`pathsep'"

    * Create directories with error handling
    foreach dir in "`base_dir'" "`vintages_dir'" {
        capture mkdir "`dir'"
        if _rc {
            display as error "Failed to create directory: `dir'"
            if "`os'" == "MacOSX" {
                display as error "macOS users: Check permissions for:"
                display as error "`personal_dir'"
                display as error "Try: {stata shell mkdir -p `dir'}"
            }
            exit _rc
        }
    }

    * Configure file paths
    if "`version'" == "current" {
        local data_path "`base_dir'GMD.dta"
        local download_url "https://github.com/mlhb-mr/test/raw/refs/heads/main/GMD.dta"
    }
    else {
        local data_path "`vintages_dir'GMD_`version'.dta"
        local download_url "https://github.com/mlhb-mr/test/raw/refs/heads/main/vintages/GMD_`version'.dta"
    }

    * Dataset download logic with enhanced error handling
    capture confirm file "`data_path'"
    if _rc {
        display as text "Downloading dataset: `=upper("`version'")' version..."
        
        * macOS-specific SSL configuration
        if "`os'" == "MacOSX" set ssl on
        
        capture copy "`download_url'" "`data_path'", replace
        if _rc {
            display as error "Download failed (Error `=_rc')"
            display as error "Possible solutions:"
            display as error "1. Check internet connection"
            if "`os'" == "MacOSX" {
                display as error "2. Try: {stata set ssl on}"
                display as error "3. Check macOS firewall settings"
            }
            display as error "4. Verify version exists on GitHub"
            exit _rc
        }
    }

    * Load data with validation
    use "`data_path'", `clear'
    foreach var in ISO3 year {
        capture confirm variable `var'
        if _rc {
            display as error "Critical error: `var' variable missing!"
            display as error "Reinstall using: {stata GMD, clear}"
            exit 498
        }
    }

    * Country filtering
    if "`country'" != "" {
        local country = upper("`country'")
        capture assert inlist(ISO3, "`country'")
        if _rc {
            levelsof ISO3, local(valid_countries)
            display as error "Invalid country code: `country'"
            display as text "Valid codes: `=subinstr("`valid_countries'", " ", ", ", .)'"
            exit 498
        }
        keep if ISO3 == "`country'"
    }

    * Variable selection
    if "`anything'" != "" {
        local keep_vars ISO3 year `anything'
        capture confirm variable `keep_vars'
        if _rc {
            display as error "Invalid variable(s) specified"
            describe, short
            exit 498
        }
        keep `keep_vars'
    }

    * Final validation
    qui describe
    display as text _n "Dataset loaded successfully:"
    display as text "• Observations: `=string(r(N),"%12.0fc")'"
    display as text "• Variables:    `=r(k)'"
    if "`country'" != "" display as text "• Country:      `country'"
    if "`version'" != "" display as text "• Version:      `version'"
end
