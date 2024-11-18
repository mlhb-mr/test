* GMP.sthlp
{smcl}
{* *! version 1.0}{...}
{title:Title}

{p 4 8}{cmd:GMP} {hline 2} Download and load dataset from GitHub with column and country filtering{p_end}

{title:Syntax}

{p 8 17 2}
{cmd:GMP} [{it:varlist}] [{cmd:,} {it:clear} {cmdab:co:untry(}{it:string}{cmd:)}]

{title:Description}

{p 4 4 2}
This command downloads and loads a dataset hosted on GitHub. Users can specify which variables to keep in addition to ISO3 and year, which are always retained. Users can also filter for a specific country using the ISO3 code.

{title:Options}

{p 4 8 2}
{cmd:clear} specifies to clear the current dataset in memory before loading the new one.

{p 4 8 2}
{cmd:country(}{it:string}{cmd:)} specifies a country to filter by using its ISO3 code (e.g., "USA", "GBR", "FRA"). Case-insensitive.

{title:Arguments}

{p 4 8 2}
{it:varlist} optional list of variables to keep in addition to ISO3 and year. If not specified, all variables are retained.

{title:Examples}

{p 4 8 2}
Load the complete dataset:{break}
. GMP

{p 4 8 2}
Load only specific variables (plus ISO3 and year):{break}
. GMP gdp population

{p 4 8 2}
Load data for a specific country:{break}
. GMP, country(USA)

{p 4 8 2}
Load specific variables for a specific country:{break}
. GMP gdp population, country(USA)

{title:Notes}

{p 4 4 2}
- ISO3 and year variables are always kept regardless of specified variables{break}
- The command will return an error if specified variables don't exist in the dataset{break}
- The command will return an error if ISO3 or year variables are missing from the dataset{break}
- The command will return an error if specified country code is not found in the dataset

{title:Author}

{p 4 8 2}
Mohamed Lehbib{break}
lehbib@nus.edu.sg

{title:Version}

{p 4 8 2}
1.0
