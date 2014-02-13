############################################################################
##                      STA250 HW1 Method1 -- Frequency Table Approach
##                                 Huajun Chai
##                                 998584845
##                             hjchai@ucdavis.edu
############################################################################
# Set up working space
setwd("~/Desktop/STA250/HW1")

# Record the start point.
ptm <- proc.time()

# Commandline in shell to extract the column of ArrDelay, and store this info into file delayData.txt.//As I am not familiar with shell script, I ask someone for help in this part.
system("tar xOjf Delays1987_2013.tar.bz2 | cut -d, -f15,45 | sed -e '/_DEL15/d' -e 's/\\.00//' -e 's/[^0-9.-]*//g'  -e '/^$/d' | sort -n | uniq -c > delayData.txt", inter = TRUE)

# Read data into delayData.txt from csv file. Ignore the header line.
delayData <- read.csv("delayData.txt", header = FALSE, sep = "")

# Get data size, including number of sum and the number of rows
numRow = nrow(delayData)
num = sum(delayData[,1])

# Get mean
sumup = 0
for(i in 1:numRow)
{
    sumup = sumup + delayData[i,1] * delayData[i,2]
}
mu = sumup / num

# Get median
if(num%%2 == 1) # Number of records is odd.
{
    index_middle = num/2 + 0.5
    
    x = 0
    y = delayData[1,1]
    for(i in 1:(numRow - 1))
    {
        if(x < index_middle && y >= index_middle)
        {
            med = delayData[i,2]
            break
        }
        x = y
        y = y + delayData[i+1,1]
    }
}

if(num%%2 == 0) # Number of records is even.
{
    index_middle = num / 2
    index_next = index_middle + 1
    
    x = 0
    y = delayData[1,1]
    for(i in 1:(numRow - 1))
    {
        if(x < index_middle && y >= index_middle)
        {
            med_1 = delayData[i,2]
            if(y >= index_middle)
            {
                med_2 = med_1
            }
            if(y < index_middle)
            {
                med_2 = delayData[i+1,2]
            }
            med = (med_1 + med_2) / 2
            break
        }
        x = y
        y = y + delayData[i+1,1]
    }
}

# Get Std
var = 0
for(i in 1:numRow)
{
    var = var + delayData[i,1] * (delayData[i,2] - mu) * (delayData[i,2] - mu)
}
std = sqrt(var/num)

# Record end point
ptm1 <- proc.time()

# Get the total running time.
time = ptm1 - ptm 

# Write result into data file
result1 <- list(time = time, results = c(mean = mu, median = med, sd = std), system = Sys.info(), session = sessionInfo())
save(result1, file = "result_1.rda")
