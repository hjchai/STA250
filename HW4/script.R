# This piece of code is used to construct the kml's, .json files.
setwd("~/Desktop/STA250/HW4")
loc <- read.table("location.txt",sep=",")
stations <- read.table("d03_stations_2014_01_01.txt", header = TRUE, sep = "\t")
index <- match(loc, stations$ID)
kml_header = c(
  '<?xml version="1.0" encoding="utf-8" standalone="yes"?>',
  '<kml xmlns="http://earth.google.com/kml/2.1">',
  '  <Folder>')

write(kml_header, file="location.kml",append = FALSE, sep = "\n")
write("var Stations = [", file = "location.json", append = FALSE, sep = "\n")

for (i in 1:length(loc)){
  tmp0 = c(
    '    <Placemark>',
    '      <name />',
    '      <Snippet maxLines="0">',
    '      </Snippet>',
    '      <styleUrl>#Style_icon</styleUrl>',
    '      <Point>')
  write(tmp0,file = "location.kml", append = TRUE, sep = "\n")
  lon <- stations$Longitude[index[i]]
  lat <- stations$Latitude[index[i]]
  station_id <- loc[[i]]
  tmp <- c("        <coordinates>", lon, ",", lat)
  tmp1 <- c("[", lon, ",", lat, ', "', station_id, '"],', "\n")
  cat(tmp1, file = "location.json", append = TRUE, sep = "")
  cat(tmp, file = "location.kml", append = TRUE, sep = " ")
  write( c("</coordinates>", "      </Point>", "    </Placemark>", "\n"), file = "location.kml", append = TRUE, sep = "\n")
}
write("]", file = "location.json", append = TRUE)

kml_tail = c(
  "  </Folder>",
  "</kml>")
write(kml_tail, file = "location.kml", append = TRUE, sep = "\n")

# moving files to dropbox public folder to make them publicly available online.
# Might need to change the directory to make it work fine on your machine.
file.copy("location.kml", "~/Dropbox/Public/kml/location.kml", overwrite = TRUE)
file.copy("location.json", "~/Dropbox/Public/kml/location.json", overwrite = TRUE)