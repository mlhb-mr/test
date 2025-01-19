{smcl}
{* *! version 1.0.0}{...}
{title:Title}

{p 4 8}{cmd:GMD} {hline 2} Download and analyze Global Macro Dataset with version control{p_end}

{title:Syntax}

{p 8 17 2}
{cmd:GMD} [{it:varlist}] [{cmd:,} {it:clear} {cmdab:v:ersion(}{it:string}{cmd:)} {cmdab:co:untry(}{it:string}{cmd:)}]

{title:Description}

{p 4 4 2}
This command downloads and loads the Global Macro Dataset. Users can specify which version to load, 
which variables to keep, and filter for specific countries. The dataset is available in quarterly 
versions (YYYY_QQ format) or as the current version.

{title:Options}

{p 4 8 2}
{cmd:clear} specifies to clear the current dataset in memory before loading the new one.

{p 4 8 2}
{cmd:version(}{it:string}{cmd:)} specifies which version of the dataset to load. Use either:
{p 8 12 2}
- "current" for the latest version (default)
{p 8 12 2}
- YYYY_QQ format (e.g., "2024_04") for specific versions

{p 4 8 2}
{cmd:country(}{it:string}{cmd:)} specifies a country to filter by using its ISO3 code (e.g., "USA", "GBR"). Case-insensitive.
{p 8 12 2}
Type {cmd:GMD isomapping} to see a list of valid country codes and their corresponding full names.

{title:Arguments}

{p 4 8 2}
{it:varlist} optional list of variables to keep in addition to ISO3 and year. If not specified, all variables are retained.

{title:Examples}

{p 4 8 2}
Load the current version:
{p 8 12 2}{cmd:. GMD}

{p 4 8 2}
Load a specific version:
{p 8 12 2}{cmd:. GMD, version(2024_04)}

{p 4 8 2}
Load specific variables:
{p 8 12 2}{cmd:. GMD gdp population}

{p 4 8 2}
Load data for a specific country:
{p 8 12 2}{cmd:. GMD, country(USA)}

{p 4 8 2}
View country codes and names:
{p 8 12 2}{cmd:. GMD isomapping}

{p 4 8 2}
Combine options:
{p 8 12 2}{cmd:. GMD ngdp pop, country(USA) version(2024_04)}

{title:Storage and Updates}

{p 4 4 2}
The package stores datasets in the following locations:

{p 8 12 2}
- Current version: {it:sysdir_personal}/GMD/GMD.dta

{p 8 12 2}
- Specific versions: {it:sysdir_personal}/GMD/vintages/GMD_YYYY_QQ.dta

{p 4 4 2}
The command automatically:

{p 8 12 2}
- Creates necessary directories
{p 8 12 2}
- Downloads missing datasets
{p 8 12 2}
- Validates version formats
{p 8 12 2}
- Checks for required variables

{title:Author}

{p 4 8 2}
Mohamed Lehbib
{p 4 8 2}
Email: {browse "mailto:lehbib@nus.edu.sg":lehbib@nus.edu.sg}
{p 4 8 2}
Website: {browse "https://www.globalmacrodata.com":https://www.globalmacrodata.com}

{title:Version}

{p 4 8 2}
1.0.0
