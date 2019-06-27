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


## Steps to create metadata file

If you are updating the metadata only:

  1. Edit the metadata templates in `./metadata_templates`
  2. Run the build script in R (build_210000000.R or others)

If publishing a new version of the package to the EDI staging server:

  1. Edit the metadata templates in './metadata_templates'
  2. Increment the `package.id` version number in the `revision` addignment of the build script.
  3. Run the build script in R.
  4. Publish to EDI staging server
