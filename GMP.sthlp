{smcl}
{* *! version 1.0}{...}
{title:Title}

{p 4 8}{cmd:GMP} {hline 2} Download and load dataset from GitHub with version control, column and country filtering{p_end}

{title:Syntax}

{p 8 17 2}
{cmd:GMP} [{it:varlist}] [{cmd:,} {it:clear} {cmdab:v:ersion(}{it:string}{cmd:)} {cmdab:co:untry(}{it:string}{cmd:)}]

{title:Description}

{p 4 4 2}
This command loads a specific version of the Global Macro Dataset. Users can specify which version to load, which variables to keep, and filter for specific countries. The dataset is released quarterly with versions formatted as YYYY_QQ (e.g., 2024_04, 2025_01).

{title:Options}

{p 4 8 2}
{cmd:clear} specifies to clear the current dataset in memory before loading the new one.

{p 4 8 2}
{cmd:version(}{it:string}{cmd:)} specifies which version of the dataset to load (e.g., "2024_04", "2025_01"). If not specified, defaults to the latest version.

{p 4 8 2}
{cmd:country(}{it:string}{cmd:)} specifies a country to filter by using its ISO3 code (e.g., "USA", "GBR", "FRA"). Case-insensitive.

{title:Arguments}

{p 4 8 2}
{it:varlist} optional list of variables to keep in addition to ISO3 and year. If not specified, all variables are retained.

{title:Examples}

{p 4 8 2}
Load the latest version of the dataset:{break}
. GMP

{p 4 8 2}
Load a specific version:{break}
. GMP, version(2024_04)

{p 4 8 2}
Load specific variables from a particular version:{break}
. GMP gdp population, version(2024_04)

{p 4 8 2}
Load data for a specific country and version:{break}
. GMP, country(USA) version(2024_04)

{title:Notes}

{p 4 4 2}
- Dataset versions are released quarterly (01, 04, 07, 10){break}
- ISO3 and year variables are always kept regardless of specified variables{break}
- The command will return an error if specified variables don't exist in the dataset{break}
- The command will return an error if ISO3 or year variables are missing from the dataset{break}
- The command will return an error if specified country code is not found in the dataset{break}
- The command will return an error if specified version is not found or has invalid format

{title:Author}

{p 4 8 2}
Mohamed Lehbib{break}
lehbib@nus.edu.sg

{title:Version}

{p 4 8 2}
1.0
