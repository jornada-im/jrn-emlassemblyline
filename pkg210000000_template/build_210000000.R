# build_210000000.R
# 
# REMOVE for packages other than 210000000 >>>>>>>>>>>>>>>>>>>>>
# [This is a template build script for running EML assembly line to create a
# data package for EDI. The example data package is # 210000000.]
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#
# After creating the EML with this script, the EML file and data entities
# should be uploaded to EDI (staging first) at:
#
# http://portal-s.lternet.edu/nis/harvester.jsp (Evaluate/Upload Packages tool)
#
# EMLassemblyline instructions (including links to vocab) here:
#
# https://ediorg.github.io/EMLassemblyline
# 
# !!!!!!!!!
# When running this script on the shared drive it may be necessary to set the 
# path based on how you map the drive. i.e.:
#
# setwd('/Volumes/JornadaFiles/LTER_IM/JRN_EMLassemblyline/pkg210.../')
# setwd('Z:\\DataProducts\LTER_IM....
# !!!!!!!!!

# After cloning to the "GitHub" folder your home directory, do:
setwd('~/GitHub/jrn_emlassemblyline/pkg210000000_example/')

library('EMLassemblyline')
library(tidyverse)

mtpath <- "./metadata_templates"
datasettitle <- "Example data package for testing emlassemblyline (mtcars)"
dpath <- "./data_entities"
datafiles <- c("mtcars.csv")
emlpath <- "./eml"
revision <- 8 # Staging=7, EDI=?, Increment by one

# Load mtcars, create a new column with the rownames, remove some columns,
# and export a simplified dataframe as csv (without rownames)
cars <- mtcars 
cars$type <- row.names(cars)

df.export <- cars %>%
  dplyr::select(type, mpg, wt, cyl, gear)

write.csv(df.export, paste0(dpath, "/mtcars.csv"), row.names=FALSE )

# Import the metadata from the template files. If there are no template files
# empty ones will be created where specified
#
# WARNING: If docx or md templates have been created, this command will
# create empty methods.txt, abstract.txt, and potentially other templates.
# (It can be commented out or changed to 'write.file=FALSE')
template_core_metadata(path = mtpath,
                       license = "CCBY",
                       x=NULL, #Not sure what this does
                       write.file=TRUE)

# Create data attributes (variables) template
template_table_attributes(path = mtpath,
                          data.path = dpath,
                          data.table = datafiles)

# Create categorical variables template
template_categorical_variables(path = mtpath,
                               data.path = dpath)

# This function can be used to assign geographic coordinates
# to particular entities in the dataset if they have name, latitudes, and
# longitudes. It is a little easier (given our constraints on sharing 
# geographic info at the Jornada) to just create an empty template and 
#define bounding boxes within it.
template_geographic_coverage(path=mtpath, empty=TRUE)
#  path = mtpath,
#  data.path = dpath,
#  data.table = datafiles,
#  site.col = 'site_name',
#  lat.col = 'site_lat',
#  lon.col = 'site_lon')

# Make the EML file - some metadata elements are filled in here, along with the
# scope and complete packageid.
emlout <- make_eml(path = mtpath,
                   dataset.title = datasettitle,
                   data.path = dpath,
                   data.table = datafiles,
                   eml.path = emlpath,
                   data.table.description = c("Subset of columns from R mtcars dataset"),
#                   temporal.coverage = c(min(df.export$date), max(df.export$date)), #This works if there is a date column 
                   temporal.coverage = c('2018-01-01', '2019-01-01'),
                   maintenance.description = "completed",
                   user.id = "JRN",
                   user.domain = "LTER",
                   package.id = paste0("knb-lter-jrn.210000000.", revision),
                   return.obj = T) # Returns eml as a named list (nice for editing)

# PLEASE READ: there is still invalid EML produced if there are quotes in
# text templates document (a bug?). So, <quote> tags need to be edited out 
# in Oxygen. This would occur if using quoted text in methods, abstract, or
# other text templates **in .txt file formats**.

# You can escape (\") or remove the quotes in the plain text templates before 
# generating the eml to avoid the error - whichever is easier.
