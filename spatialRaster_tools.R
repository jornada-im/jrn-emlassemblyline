library(raster)# Work with rasters
library(tools) # MD5sum function
#library(EML)

# Documentation for spatialRaster entities at knb:
#  https://eml.ecoinformatics.org/eml-schema.html#the-eml-spatialraster-module---logical-information-about-regularly-gridded-geospatial-image-data

# Function to build a spatialRaster entity
build_spatialRaster <- function(rasterFname,        # Filename (local path)
                                rasterDesc,         # Free-text descr. of raster
                                rasterGeoDesc,      # Raster geographic coverage
                                rasterAttributes,   # Attributes table
                                rasterFactors=NULL, # Factor codes table
                                baseURL=""){        # Public URL of raster file
  # The CAP LTER capeml R package (Stevan Earl) was a helpful starting
  # point for this function, especially the use of EML package:

  #  https://github.com/CAPLTER/capeml/blob/master/R/create_spatialRaster.R

  
  # Load raster ---------------------------------------------------------------
  # (should be ok even for large files)
  rasterObject <- raster(rasterFname)
  
  
  # Get spatial reference and convert to EML standard--------------------------
  
  # First read the proj4 string
  proj4str <- crs(rasterObject, asText=TRUE)[[1]]
  print(paste('Spatial reference in proj4 format is:', proj4str))
  
  # Assign EML-compliant name - a manually determined translation of proj4str
  # Allowed values for EML seem to be enumerated here: 
  #  https://eml.ecoinformatics.org/schema/eml-spatialReference_xsd.html#SpatialReferenceType
  # Searching projection names at https://spatialreference.org is helpful
  # for the translation
  if (proj4str=="+proj=utm +zone=13 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0"){
    emlProjection <- "NAD_1983_UTM_Zone_13N"
  } else if (proj4str=="+proj=utm +zone=13 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"){
    emlProjection <- "NAD_1983_CSRS98_UTM_Zone_13N"
  }
  print(paste("Translated to", emlProjection, 'in EML spatialReference schema'))
  
  
  # Determine coverage (bbox) of raster ---------------------------------------
  
  # For EML, this apparently needs to be in decimal degrees, so convert
  # to SpatialPolygons and then reproject with spTransform
  extent <- as(raster::extent(rasterObject), "SpatialPolygons")
  sp::proj4string(extent) <- proj4str
  extent.geo <- sp::spTransform(extent, CRS("+proj=longlat +datum=WGS84 +no_defs 
                                            +ellps=WGS84 +towgs84=0,0,0"))
  print('Determining spatial coverage...')
  spatialCoverage <- EML::set_coverage(geographicDescription = rasterGeoDesc,
                                  west = extent.geo@bbox["x", "min"],
                                  east = extent.geo@bbox["x", "max"],
                                  north = extent.geo@bbox["y", "max"],
                                  south = extent.geo@bbox["y", "min"])
  
  
  # projections----------------------------------------------------------------
  projections <- list(section = list(
    paste0("<title>Raster derived coordinate reference system</title>\n<para>",
           proj4str, "</para>")
    ))

  
  # Create attributes table----------------------------------------------------
  # EML schema reference:
  # https://eml.ecoinformatics.org/eml-schema.html#the-eml-attribute-module---attribute-level-information-within-dataset-entities
  # EML R package reference: 
  # https://ropensci.github.io/EML/articles/creating-EML.html#attribute-metadata
  #
  # Must provide attributes table, if raster has factors add a factors table
  print('Building attributes...')
  
  # If rasterFactors is not NULL
  if (!is.null(rasterFactors)){
    # Build attribute list with rasterAttributes and rasterFactors
    # rasterAttributes must contain:
    #     attributeName
    #     attriuteDefinition
    # rasterFactors enumerates each code and its definition for attributeName
    attr_list <- EML::set_attributes(attributes=rasterAttributes,
                                    factors=rasterFactors, 
                                    col_classes = "factor")
    
  } else {  # If factorTable IS NULL
    # Build attribute list with rasterAttributes
    # rasterAttributes (for numeric data) must contain:
    #     attributeName
    #     attriuteDefinition
    #     unit (such as "dimensionless")
    #     numberType ('real', 'natural', 'integer', 'whole')
    #
    # CAP's capeml has a way to determine raster value number type
    # see here: https://github.com/CAPLTER/capeml/blob/master/R/create_spatialRaster.R
    #
    # This will fail if the units are not appropriate
    attr_list <- EML::set_attributes(attributes=rasterAttributes,
                                     col_classes="numeric")
  }
  
  
  # set authentication (md5)---------------------------------------------------
  print('Calculating MD5 sum...')
  fileAuthentication <- EML::eml$authentication(method = "MD5")
  fileAuthentication$authentication <- md5sum(rasterFname)
  
  
  # set file size--------------------------------------------------------------
  fileSize <- EML::eml$size(unit = "byte")
  fileSize$size <- deparse(file.size(rasterFname))
  
  
  # set file format------------------------------------------------------------
  fileDataFormat <- EML::eml$dataFormat(
    externallyDefinedFormat=EML::eml$externallyDefinedFormat(
      formatName=file_ext(rasterFname))
    )
  
  # Create rasterPhysical pieces-----------------------------------------------
  rasterBaseName <- basename(rasterFname)
  directoryName <- dirname(rasterFname)
  directoryNameFull <- sub("/$", "", path.expand(directoryName))
  pathToFile <- path.expand(rasterFname)
  
  # set distribution
  fileDistribution <- EML::eml$distribution(
    EML::eml$online(url = paste0(baseURL, rasterBaseName))
    )
  
  # build physical
  spatialRasterPhysical <- EML::eml$physical(
    objectName = rasterBaseName,
    authentication = fileAuthentication,
    size = fileSize,
    dataFormat = fileDataFormat,
    distribution = fileDistribution
    )
  
  
  # build spatialRaster--------------------------------------------------------
  print('Building spatialRaster entity...')
  newSR <- EML::eml$spatialRaster(
    entityName = rasterBaseName,
    entityDescription = rasterDesc,
    physical = spatialRasterPhysical,
    coverage = spatialCoverage,
    additionalInfo = projections,
    attributeList = attr_list,
    spatialReference = EML::eml$spatialReference(
      horizCoordSysName = emlProjection),
    numberOfBands = bandnr(rasterObject),
    rows = nrow(rasterObject),
    columns = ncol(rasterObject),
    horizontalAccuracy = EML::eml$horizontalAccuracy(accuracyReport="Unknown"),
    verticalAccuracy = EML::eml$verticalAccuracy(accuracyReport="Unknown"),
    cellSizeXDirection = xres(rasterObject),
    cellSizeYDirection = yres(rasterObject),
    rasterOrigin = "Upper Left",
    verticals = 1,
    cellGeometry = "pixel",
    id = rasterBaseName
    )
  
  return(newSR)
}


