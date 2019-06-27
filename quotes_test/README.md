# README.md for quotes_tests

There are 2 scripts here, one in R and one in bash, that illustrate
issues with generating valid EML (or xml) from text files (.txt or .md)
on my systems (one MacOS Mojave, and one Debian Linux).

The input files being tested are text.txt and text.docx. Both are simple
files with double quotes in the text.

The R script (quotes_test.R) runs EML::set_TextType() using .txt and .docx
input files with different results. The <quote> tags that result from the
.txt input files are invalid when checked by EMLassemblyline, Oxygen, and
the EDI EML validator.

Since I discovered that EML::set_TextType runs pandoc to convert text to
xml (via the rmarkdown package), I also decided to see if pandoc was the
problem. There are 2 installations of pandoc on my systems - one 
with RStudio and one system installation that I installed. The bash
script (quotes_test_pandoc.sh) tests both. I get the same result from both
pandocs - .txt produces problem quotes, .docx does not. 
