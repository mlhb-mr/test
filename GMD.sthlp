{smcl}
{* *! version 1.0.0}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "GMD##syntax"}{...}
{viewerjumpto "Description" "GMD##description"}{...}
{viewerjumpto "Options" "GMD##options"}{...}
{viewerjumpto "Examples" "GMD##examples"}{...}
{viewerjumpto "Storage" "GMD##storage"}{...}
{title:Title}

{phang}
{bf:GMD} {hline 2} Download and analyze Global Macro Dataset with version control f

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:GMD} [{it:varlist}] [{cmd:,} {it:clear} {cmdab:v:ersion(}{it:string}{cmd:)} {cmdab:co:untry(}{it:string}{cmd:)}]

{marker description}{...}
{title:Description}

{pstd}
This command downloads and loads the Global Macro Dataset. Users can specify which version to load, 
which variables to keep, and filter for specific countries. The dataset is available in quarterly 
versions (YYYY_QQ format) or as the current version.

{marker options}{...}
{title:Options}

{phang}
{cmd:clear} specifies to clear the current dataset in memory before loading the new one.

{phang}
{cmd:version(}{it:string}{cmd:)} specifies which version of the dataset to load. Use either:{p_end}
{pmore}
- "current" for the latest version (default){p_end}
{pmore}
- YYYY_QQ format (e.g., "2024_04") for specific versions

{phang}
{cmd:country(}{it:string}{cmd:)} specifies a country to filter by using its ISO3 code 
(e.g., "USA", "GBR"). Case-insensitive.{p_end}
{pmore}
Type {cmd:GMD isomapping} to see a list of valid country codes and their corresponding full names.

{marker arguments}{...}
{title:Arguments}

{phang}
{it:varlist} optional list of variables to keep in addition to ISO3 and year. If not specified, all variables are retained.

{marker examples}{...}
{title:Examples}

{phang}Load the current version:{p_end}
{phang2}{cmd:. GMD}

{phang}Load a specific version:{p_end}
{phang2}{cmd:. GMD, version(2024_04)}

{phang}Load specific variables:{p_end}
{phang2}{cmd:. GMD gdp population}

{phang}Load data for a specific country:{p_end}
{phang2}{cmd:. GMD, country(USA)}

{phang}View country codes and names:{p_end}
{phang2}{cmd:. GMD isomapping}

{phang}Combine options:{p_end}
{phang2}{cmd:. GMD ngdp pop, country(USA) version(2024_04)}

{marker storage}{...}
{title:Storage and Updates}

{pstd}
The package stores datasets in the following locations:

{pmore}
Current version: {it:sysdir_personal}/GMD/GMD.dta

{pmore}
Specific versions: {it:sysdir_personal}/GMD/vintages/GMD_YYYY_QQ.dta

{pstd}
The command automatically:

{pmore}- Creates necessary directories{p_end}
{pmore}- Downloads missing datasets{p_end}
{pmore}- Validates version formats{p_end}
{pmore}- Checks for required variables{p_end}

{title:Author}

{pstd}
Mohamed Lehbib{break}
Email: {browse "mailto:lehbib@nus.edu.sg":lehbib@nus.edu.sg}{break}
Website: {browse "https://www.globalmacrodata.com":https://www.globalmacrodata.com}

{title:Version}

{pstd}
1.0.0
