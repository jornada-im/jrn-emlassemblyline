#!/bin/bash
# Run this to output 4 xml files that demonstrate how system and Rstudio 
# pandoc handle quoted text in .txt and .docx files. The input files are
# either test.txt or test.docx
#
# When I test them on linux and MacOS Mojave the output files that came from 
# test.txt (test_rspandoc.docbook and test_syspandoc.docbook) contain <quote>
# tags that are not valid EML. The others (from the .docx file) are correctly
# escaped

# Test Rstudio pandoc - first get version
/Applications/RStudio.app/Contents/MacOS/pandoc/pandoc --version

# Test Rstudio pandoc. From .txt file to docbook (xml) format
/Applications/RStudio.app/Contents/MacOS/pandoc/pandoc test.txt -f markdown -t docbook -o test_rspandoc.docbook

# Test Rstudio pandoc. From .docx file to docbook (xml) format
/Applications/RStudio.app/Contents/MacOS/pandoc/pandoc test.docx -f docx -t docbook -o testdocx_rspandoc.docbook

# Test system pandoc - first get version
pandoc --version

# System pandoc. From .txt file to docbook (xml) format
pandoc test.txt -f markdown -t docbook -o test_syspandoc.docbook

# System pandoc. From .docx file to docbook (xml) format
pandoc test.docx -f docx -t docbook -o testdocx_syspandoc.docbook
