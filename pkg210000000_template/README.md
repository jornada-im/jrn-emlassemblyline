# Jornada package 210000000 (example)

* Package ID: 210000000

## Description

This is the Jornada-IM example dataset for use with the R package [EMLassemblyline](https://ediorg.github.io/EMLassemblyline/) (or `EAL`). Data and metadata files here can be used as a template for new datasets and are commonly used to test data management workflows and code.

(When using this README file as a template replace any text with your own.)

## Metadata sources

(Describe the sources of the metadata in this package. What EML files were
on EDI and the website? What other JRN files were used? Who updates? Etc.)

Metadata templates for `EAL` are stored in `metadata_templates/`. These files are created according to the requirements and examples specified in the directions for `EAL`. See here:

<https://ediorg.github.io/EMLassemblyline/articles/overview.html>

for more info.

## Data table sources

(Describe the source of the data entities in this package. Where did the 
CSVs or other files come from? Where do new data come from, if any? Etc.).

Incoming raw data can be placed in the parent directory if desired, and finished, publishable data files should be placed in `data_entities/`. The raw data in the example dataset (mtcars.csv) comes from R's built in mtcars dataset.

## Other entities

(Describe any other entities included in the data package (maps, procedures 
documents, non-tabular data files, etc.)


## Build scripts

The build scripts here call `EAL` (and related R packages) to prepare the data and metadata for publication. Once complete, the resulting EML and data entities may be published manually using the [EDI portal](https://portal-s.edirepository.org). Metadata such as the title and entity descriptions are also in these build scripts.

* `build_210000000.R` - Basic build script that modifies data and writes EML 


## How to make EML and publish the dataset

For more information on updating and publishing this dataset, see the Jornada IM documentation site:

* [Metadata standards](https://jornada-im.github.io/documentation/jornada_metadata_standards.html)
* [Make EML and publish](https://jornada-im.github.io/documentation/makeEML_emlassemblyline.html)
