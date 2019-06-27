setwd('~/GitHub/jrn_emlassemblyline/quotes_test/')

library('EML')

EML::set_TextType('test.txt')

EML::set_TextType('test.docx')

# In the output from .txt the <quote> tags cause problems in EML validation.
# Output from the .docx seems to have the quotes properly escaped.

# EML::set_TextType converts .txt input to .xml output using pandoc via 
# an rmarkdown command (I checked this in the code in the EML package to
# be sure). Pandoc takes the text in the input file (.txt or .docx) and
# converts to docbook' output, which is a dialect of xml
rmarkdown::pandoc_convert('test.txt', to='docbook')

rmarkdown::pandoc_convert('test.docx', to='docbook')

# Again, the output from .txt has <quote> tags, .docx output is properly
# escaped.