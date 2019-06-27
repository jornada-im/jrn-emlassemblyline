# Get the current EML file from PASTA to replace the methods node (formatting not preserved)
# there is a way to do this with the PASTA API and EDIutils also
#edieml <- EML::read_eml('https://portal.edirepository.org/nis/metadataviewer?packageid=knb-lter-jrn.210000000.11&contentType=application/xml')
#edimethods <- edieml$dataset$methods
# Replace
#emlout$dataset$methods <- edimethods
# Write the revised eml
#EML::write_eml(emlout, paste0(emlpath, '/', emlout$packageId, '.xml'))

url <- paste0(
  'https://pasta.lternet.edu/package/metadata/eml/knb-lter-jrn/210000000/',
  suppressMessages(
    api_list_data_package_revisions(
      scope = 'knb-lter-jrn', 
      '210000000', 
      filter = 'newest',
      environment = 'production'
    )
  )
)

# Read EML into R as list object

eml <- EML::read_eml(url)
