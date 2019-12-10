
# This script automates the the process of passing html files 
# into the jekyll system. Its done for the handbook for infectious diseases

library(stringr)
library(rmarkdown)

# Unzip the file
unzip("lehrbuch-ffentlicher-gesundheitsdienst.html.zip")

# This command lists all html files after deleting index.html
file.remove("index.html")
htmlfiles <- list.files(".", pattern = ".html$")

# loop through all zip files
for (a in htmlfiles) {

# a <- htmlfiles[3]  

# Get rid of the annoying error of a missing newline
write("\n", a, append = T)

# Getting the necessary information out of the html-file
number <- strsplit(strsplit(a, "\\.")[[1]][1], "-")[[1]][2]
newfilename <- paste0("../docs/ready", paste0(a, ".md"))

# read in the document
document <- readLines(a)

# Get document title
title_line <- document[grep("<title", document)]
title <- strsplit(strsplit(title_line, ">")[[1]][2], "<")[[1]][1]

# Get content out of document
document <- document[grep("<div class=\"article-part article-richtext article-body\">", document) ][1]
document <- str_split(document, "<div class=\"article-part article-richtext article-body\">")[[1]][2]

write(document, "tmp.html")
pandoc_convert("tmp.html", to = "gfm", output = "tmp.md")
documentToAppend <- readLines("tmp.md")

# remove the old file if it exists
if (file.exists(newfilename)) file.remove(newfilename)

# the new file is created line by line. This is where the jekyll front matter is included
write("---", newfilename)
write("layout: page", file = newfilename, append = T)
write(paste("title:", title), newfilename, append = T)
write(paste("nav_order:", number), newfilename, append = T)
write("---", newfilename, append = T)
# write(paste("{{page.title}}"), newfilename, append = T)
write(paste(" "), newfilename, append = T)
write(paste("<details markdown=\"block\"> "), newfilename, append = T)
write(paste("  <summary> "), newfilename, append = T)
write(paste("      &#9658; Inhaltsverzeichnis Kapitel (ausklappbar) "), newfilename, append = T)
write(paste("  </summary>"), newfilename, append = T)
write(paste(" "), newfilename, append = T)
write(paste("1. TOC"), newfilename, append = T)
write(paste("{:toc}"), newfilename, append = T)
write(paste(" </details>"), newfilename, append = T)
write(paste(" "), newfilename, append = T)
write(paste("   <p></p>"), newfilename, append = T)
write(paste(" "), newfilename, append = T)
write(paste(" "), newfilename, append = T)
write(documentToAppend, newfilename, append = T)


file.remove("tmp.html")
file.remove("tmp.md")

}



# Copying all pictures to the docs folder
pics <- list.files(".", pattern = ".png$")
for (i in pics) {
  file.copy(i, paste0("../docs/", i))
}

# Cleaning up
file.remove(list.files(".", pattern = ".png$"))


