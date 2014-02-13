############################################################################
##                      STA250 HW1 Method2 -- Extracting Column Approach
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

# Then use R script to compute the statistics.

# Load data into R
delayData <- read.table("delayData_not_sorted.txt",sep="\n")
# Mean
mu = mean(delayData[,1])
# Standard deviation
std = sd(delayData[,1])
# Median
med = median(delayData[,1])
# Record end point
ptm1 <- proc.time()

# Get the total running time.
time = ptm1 - ptm

# Write result into data file
result2 <- list(time = time, results = c(mean = mu, median = med, sd = std), system = Sys.info(), session = sessionInfo())
save(result2, file = "result_2.rda")