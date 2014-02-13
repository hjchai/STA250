############################################################################
##                      STA250 HW1 Method3 -- MySQL Approach
##                                 Huajun Chai
##                                 998584845
##                             hjchai@ucdavis.edu
#############################################################################
# Set up working space
setwd("~/Desktop/STA250/HW1")

# Record the start point.
ptm <- proc.time()

# Commandline in shell to extract the column of ArrDelay, and store this info into file delayData.txt.
system("tar xOjf Delays1987_2013.tar.bz2 | cut -d, -f15,45 | sed -e '/_DEL15/d' -e 's/\\.00//' -e 's/[^0-9.-]*//g'  -e '/^$/d' > delayData_not_sorted.txt", inter = TRUE)

# Load the RmySQL package
library(RMySQL)
# Establish a MySQL connection to your database(mine is airline) with account info.
con <- dbConnect(MySQL(), user='root', password='chaihj900823', dbname='airline', host="localhost") 
# List the existing tables in your database
dbListTables(con)
# Send a query to the database to create a table named as arrdelay_table to store the arrdelay data.
dbSendQuery(con, "create table arrdelay_table(arrdelay int(255) NULL);")
# Set the index, i.e. let the data be in a sorted manner.
dbSendQuery(con, "alter table arrdelay_table add index(arrdelay);")
# Use a query to load arrdelay data from txt file into database.
dbGetQuery(con, "load data infile '/home/huajun/Desktop/STA250/HW1/delayData_not_sorted.txt' into table arrdelay_table lines terminated by '\n';")
# Use select command to compute mean.
mu = dbGetQuery(con, "select avg(arrdelay) from arrdelay_table;")
# Use select command to compute standard deviation.
std = dbGetQuery(con, "select std(arrdelay) from arrdelay_table;")
# Use select command to compute median.
num = dbGetQuery(con, "select count(*) from arrdelay_table;")
if(num%%2 == 1)
{
  middle = num/2 + 0.5
  index_middle = as.character(middle)
  command = paste("select * from arrdelay_table limit", index_middle, ",1;", sep=" ")
  med_data = dbGetQuery(con, command)
  med = med_data[1,1]
}
if(num%%2 == 0)
{
  middle = num/2
  index_middle = as.character(middle)
  command = paste("select * from arrdelay_table limit", index_middle, ",2;", sep=" ")
  med_data = dbGetQuery(con, command)
  med = (med_data[1,1] + med_data[2,1]) / 2
}

# Record end point
ptm1 <- proc.time()

# Get the total running time.
time = ptm1 - ptm

# Write result into data file
result3 <- list(time = time, results = c(mean = mu, median = med, sd = std), system = Sys.info(), session = sessionInfo())
save(result3, file = "result_3.rda")