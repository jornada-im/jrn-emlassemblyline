# README

Package ID = 210000000 (a fake data package for example and testing purposes)
Title = Example data package for testing emlassemblyline (mtcars)

## Data sources:

The data in this package (mtcars.csv) comes from R's built in mtcars dataset.

This dataset can be read in and modified by the scripts included here

## Metadata sources:

Templates are located in `./metadata_templates

Metadata are completely made up according to the requirements and examples specified in the directions for
EMLassemblyline. See here:

<https://ediorg.github.io/EMLassemblyline/articles/overview.html>

for more info.

## Build scripts

There are build scripts here that run EMLassemblyline and other packages
to illustrate different things.

They are:

* build_210000000.R - Basic build script
* Maybe we'll add others for testing someday


## Steps to create metadata (EML) file

**If updating and publishing new data (and metadata):**

  1. Download and open the latest dataset (in this case it doesn't matter, `mtcars` is built into R).
  2. Make any data file changes necessary with R in the `build_210000000.R` script (again, not really needed here)
  3. Increment `package.id` version number in build_210000000.R (`make_eml()` call)
  4. Increment the `temporal.coverage` array in build_210000000.R (`make_eml()` call)
  5. Update metadata templates
  6. Run the build_210000000.R script in R.
  7. Publish to EDI staging server

**If you are updating the package metadata only:**

  1. Edit the metadata templates in `./metadata_templates`
  2. Increment `package.id` version number in build_210000000.R (`make_eml()` call)
  3. Run the build_210000000.R script in R (careful not to regenerate blank templates)
  4. Publish to EDI or EDI Staging ("Evaluate/Upload Data Packages" tool)
