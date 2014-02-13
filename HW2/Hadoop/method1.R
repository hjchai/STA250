############################################################################
##                      STA250 HW1 Method1 -- Hadoop Approach
##                                 Huajun Chai
##                                 998584845
##                             hjchai@ucdavis.edu
############################################################################
# Set up working space
setwd("~/Desktop/STA250/HW2/Hadoop/")

# Record the start point.
ptm <- proc.time()

# Start hadoop service
system("~/hadoop-2.2.0/sbin/start-all.sh")

# Makefile
system("make")

# Run hadoop computation
system("hadoop jar eg.jar DelaysFrequencyTable Data Out")

# Copy results from hdfs to local
system("hadoop fs -copyToLocal /user/huajun/Out/* ~/Desktop/STA250/HW2/Hadoop/")

# Remove ../Out folder
system("hadoop fs -rm -r /user/huajun/Out")

# Stop service
system("~/hadoop-2.2.0/sbin/stop-all.sh")

# Rename file
system("mv part-r-00000 delayData.txt")

# Read data into delayData.txt from csv file. Ignore the header line.
delayData <- read.csv("delayData.txt", header = FALSE, sep = "")

# Get data size, including number of sum and the number of rows
numRow = nrow(delayData)
num = sum(delayData[,2])

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
  y = delayData[1,2]
  for(i in 1:(numRow - 1))
  {
    if(x < index_middle && y >= index_middle)
    {
      med = delayData[i,1]
      break
    }
    x = y
    y = y + delayData[i+1,2]
  }
}

if(num%%2 == 0) # Number of records is even.
{
  index_middle = num / 2
  index_next = index_middle + 1
  
  x = 0
  y = delayData[1,2]
  for(i in 1:(numRow - 1))
  {
    if(x < index_middle && y >= index_middle)
    {
      med_1 = delayData[i,1]
      if(y >= index_middle)
      {
        med_2 = med_1
      }
      if(y < index_middle)
      {
        med_2 = delayData[i+1,1]
      }
      med = (med_1 + med_2) / 2
      break
    }
    x = y
    y = y + delayData[i+1,2]
  }
}

# Get Std
var = 0
for(i in 1:numRow)
{
  var = var + delayData[i,2] * (delayData[i,1] - mu) * (delayData[i,1] - mu)
}
std = sqrt(var/num)

# Record end point
ptm1 <- proc.time()

# Get the total running time.
time = ptm1 - ptm 

# Write result into data file
result1 <- list(time = time, results = c(mean = mu, median = med, sd = std), system = Sys.info(), session = sessionInfo())
save(result1, file = "result_1.rda")