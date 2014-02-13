####################################################################################
#                    STA250 Homework1 Method 1 -- Frequency Table
#                         Yu Liu 998611750 yuliu@ucdavis.edu
####################################################################################

# Alternate1: execute shell command in R and read stdout into table unique
# Note: this shell command may cause error when executing in R. If so, please swith to Alternate2.
# com = "tar xOjf Delays1987_2013.tar.bz2 | cut -d, -f15,45 | sed -e '/ARR_DEL15/d' -e' s/[^0-9.-]*//g'  -e '/^$/d'  -e 's/\\.00//' | sort -n | uniq -c"
# uniq = system (com, intern = TRUE)

# Alternate2: execute the following shell command in bash, stdout is written to csv file
# $tar xOjf Delays1987_2013.tar.bz2 | cut -d, -f15,45 | sed -e '/ARR_DEL15/d' -e' s/[^0-9.-]*//g'  -e '/^$/d'  -e 's/\.00//' | sort -n | uniq -c > uniq.txt
# Run time = 1168s
# R code timer starts here
start <- proc.time()
# Then read unique value table from csv file
uniq <- read.csv("uniq.txt", header = FALSE, sep = "")

# Data size
n = sum(uniq[,1])
row = nrow(uniq)

# Calculate average
SumDelay = 0
for (i in 1:row){
  SumDelay =  SumDelay + uniq[i,1] * uniq[i,2]
}
Mean = SumDelay/n

# Calculate standard variation
Var = 0
for (i in 1:row){
  Var = Var + (uniq[i,2] - Mean)^2 * uniq[i,1]
}
SD = sqrt(Var/n)

# Find the median, the average of values of index mid1 and mid2
if(n%%2 == 0){
  mid1 = n/2
  mid2 = mid1 + 1
}
if(n%%2 == 1){
  mid1 = n/2 + 0.5
  mid2 = mid1
}
# Use t1, t2 to track current index
t1 = 0
t2 = uniq[1,1]
for (i in 1:(row-1)){
  if(t1 < mid1 && t2 >= mid1)
    m1 = uniq[i,2]
  if(t1 < mid2 && t2 >= mid2){
    m2 = uniq[i,2]
    break
  }
  t1 = t2
  t2 = t2 + uniq[i+1,1]
}
Median = (m1 + m2)/2

# Get execution time
time = proc.time()-start

# Result1: Mean = 6.5665 SD = 31.5563 Median = 0 time = 0.437s
 
M1Info <- list(time = time + 1168, results = c(mean = Mean, median = Median, sd = SD),
     system = Sys.info(),  session = sessionInfo())
save(M1Info, file = "results1.rda")


