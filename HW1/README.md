# STA250 Winter 2014: Assignment 1
----
Huajun  Chai

998584845

hjchai@ucdavis.edu

------
Compute summary statistics for arrival delay times from the airline flight data set.

  - Mean
  - Standard deviation
  - Median

In this assignment, I used three different approaches to compute the desired statistics. They are:
  - Frequency table approach
  - Extracting arrdelay column approach
  - Database approach

I will introduce these methods in the following part in details to describe how to actual done every step, and also provide some analysis and comparison about the results from different approaches.

=========================

# Method 1: Frequency table
----
In this method, we will calculate a frequency table from the datasets we have. Every possible delay value will have their corresponding frequency value. Based on that frequency table, we will further come up with some algorithms to compute the required statistics, i.e. mean, median and standard deviation.

## Tools used
- Shell script
- R script

## Instruction of excuting the codes
- First, excute the following shell script in shell to compute the frequency table.

```sh
system("tar xOjf Delays1987_2013.tar.bz2 | cut -d, -f15,45 | sed -e '/_DEL15/d' -e 's/\\.00//' -e 's/[^0-9.-]*//g'  -e '/^$/d' | sort -n | uniq -c > delayData.txt", inter = TRUE)
```
In this shell script, we use pipeline to extract the data we desire, i.e. the "Arr Delay" information. The fisrt step is to cut the "Arr Delay" column out of the files using "cut" command. The deliminator here for "csv" files is ",", i.e. the comma. Based on observation of the files, we know that the "Arr Delay" column is the 43th column or the 15th column, w.r.t different types of files. However, for the monthly data, there are two columns contain "," within the column, so we change 43 to 45 in order to cut the right column we want. See codes below:

```sh
cut -d, -f15,45
```
Then we use "sed" command to select the data: 

This piece of code aims to get rid of the first line(the header, which is "ARR_DEL15") we get from every monthly file.
```sh
sed -e '/_DEL15/d'
```

In the arrdelay column, there is integer value as well as float value, for example 17 and 17.00. The two types of value is the same. So we use this piece of code to trim out the decimal part.
```sh
sed -e 's/\.00//'
```

This part tries to grep the arrdelay column. By observation, we can know that this column contains numbers from 0 to 9, "-" and ".". We use "//g" to grep these data.
```sh
sed -e 's/[^0-9.-]//g'
```

There are some missing values in the column. They appears empty. We need to remove them. "/^$" can find the empty ones.
```sh
sed -e '/^$/d'
```

Sort the data in ascending way.
```sh
sort -n
```
Find the uniq values, and count the number of every value and save it to delayData.txt.
```sh
uniq -c > delayData.txt
```

- Second, run the following R code to finally compute the statistics(mean, median and standard deviation) based on the frequency table we get.

Read data into delayData.txt from csv file. Ignore the header line.
```sh
delayData <- read.csv("delayData.txt", header = FALSE, sep = "")
```

Get data size, including number of sum and the number of rows.
```sh
numRow = nrow(delayData)
num = sum(delayData[,1])
```

Compute mean.
```sh
sumup = 0
for(i in 1:numRow)
{
    sumup = sumup + delayData[i,1] * delayData[i,2]
}
mu = sumup / num
```

Compute median.
```sh
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
```

Get standard deviation.
```sh
var = 0
for(i in 1:numRow)
{
    var = var + delayData[i,1] * (delayData[i,2] - mu) * (delayData[i,2] - mu)
}
std = sqrt(var/num)
```

Record time.
```sh
# Record end point
ptm1 <- proc.time()

# Get the total running time.
time = ptm1 - ptm 
```

- Finally, write the reult into a .rda file.

```sh
result1 <- list(time = time, results = c(mean = mu, median = med, sd = std), system = Sys.info(), session = sessionInfo())
save(result1, file = "result_1.rda")
```

## Result overview
 - Mean: 6.566504
 - Median: 0
 - Std: 31.556326
 - Running time: 971.110 S

# Method 2: Extracting column approach
--------------
This method is pretty similar with the first approach. The main difference is that this time, we don't create a frequency. Instead, the whole column of "ArrDelay" data is store in the txt file. There might be a difference in terms of running time and the final results compared with the first method. I will provide analysis later.

## Tools used
 - Shell script
 - R script

# Introduction of the codes
- First, excute the following shell script in shell to compute the frequency table, and store the result in a txt file. The main part of this shell script is similar to the first method. We are not going to each piece of codes in the pipeline command in detail.

```sh
system("tar xOjf Delays1987_2013.tar.bz2 | cut -d, -f15,45 | sed -e '/_DEL15/d' -e 's/\\.00//' -e 's/[^0-9.-]*//g'  -e '/^$/d' > delayData_not_sorted.txt", inter = TRUE)
```
We haven't included "sort -n" and "uniq -c" within the shell command. This will leave us an entire unsorted delay dataset.
- Then we load this txt file into R.

```sh
delayData <- read.table("delayData_not_sorted.txt",sep="\n")
```
- Using R command to compute statistics.
Get mean:

```sh
mu = mean(delayData[,1])
```
Get median:

```sh
med = median(delayData[,1])
```
Get std:

```sh
std = sd(delayData[,1])
```

Record running time:

```sh
# Record end point
ptm1 <- proc.time()

# Get the total running time.
time = ptm1 - ptm
```
- Finally write result into .rda file

```sh
result2 <- list(time = time, results = c(mean = mu, median = med, sd = std), system = Sys.info(), session = sessionInfo())
save(result2, file = "result_2.rda")
```
## Result overview
 - Mean: 6.566504
 - Median: 0
 - Std: 31.556326
 - Running time: 1004.737 S


# Method 3: Database approach
-----
In this method, a totally new tool is adopted. We use a database to store the arrdelay data, and futher calculate the statistics using SQL queries.

## Tools used
 - Shell script
 - MySQL 5.5

## Preparations
If you don't have MySQL on your machine, you will need to download from this [website], and install it. There is an [instruction] that tells you how to install MySQL for different operation systems.

After installing MySQL on your machine, you can use the following command to login MySQL:

```sh
$mysql -u root -p
```
It will ask you to enter your password. The first time you enter the database, there is no password. You can set up password using this command:

```sh
mysql> SET PASSWORD FOR 'root'@'localhost' = PASSWORD('newpwd');
```
Once you have you account information done, you can create a databse:

```sh
mysql> create database airline;
```
Choose the database you create:

```sh
mysql> use airline;
```
After that, you can use my codes in mehtod3.R freely.

## Introduction of codes
 - First of all, use the shell command to extract the column of "ArrDelay", and store the information in a txt file. The main part of this shell script is exactly the same with that of the second method. We are not going to each piece of codes in the pipeline command in detail.

```sh
system("tar xOjf Delays1987_2013.tar.bz2 | cut -d, -f15,45 | sed -e '/_DEL15/d' -e 's/\\.00//' -e 's/[^0-9.-]*//g'  -e '/^$/d' > delayData_not_sorted.txt", inter = TRUE)
```
 - Then, load RMySQL package into R. RMySQL is the interface between MySQL and R. This package allows us to use MySQL in R environment. If you haven't used MySQL in R before, you might need to download the package from [CRAN], and install it.

```sh
library(RMySQL)
```
 - Establish a MySQL connection to the database "airline" using the account information.

```sh
con <- dbConnect(MySQL(), user='root', password='password', dbname='airline', host="localhost") 
```
 - Send a SQL "create table" query through the connection to create a new table to store arrdelay data. There are some parameters specifying the characteristics of the table: 

"arrdelat_table" is the table name.

"arrdelay" is the column name.

"int(255)" means the column will store integers.

"NULL" means the default value of the table is NULL.

```sh
dbSendQuery(con, "create table arrdelay_table(arrdelay int(255) NULL);")
```
 - Add index to the column. This operation will make the data in the table to be sorted in a ascending way. It will take a considerable amount of time as ordering data takes a huge amount of work. But this will make our life much easier when calculating median.

```sh
dbSendQuery(con, "alter table arrdelay_table add index(arrdelay);")
```
 - Use a SQL query to load data from txt file into database. Here we need to specify the absolute path of the txt file. It might be different for others to run this code. They need to change this info based on their machine. For some ubuntu users, giving an absolute path is not enough. It might end up with this error: "... delaydata.txt file not found.". This might due to lacking of permission on some files. There is a solution for you if you face this problem. [Click here].

```sh
dbGetQuery(con, "load data infile '/home/huajun/Desktop/STA250/HW1/delayData_not_sorted.txt' into table arrdelay_table lines terminated by '\n';")
```
 - Get mean. MySQL provides some basic functionalities such as calculating mean and standard deviation which will make the rest of the work quite easy and straightforward, just one line of SQL query.

```sh
mu = dbGetQuery(con, "select avg(arrdelay) from arrdelay_table;")
```
 - Get standard deviation.

```sh
std = dbGetQuery(con, "select std(arrdelay) from arrdelay_table;")
```

 - Get median. Median is a little bit complicated to calculated since there is no function like "median()" to get the median directly. But from the definition of median, it is still quite easy to get this value as long as we have our database in a sorted way. Since the data is already sorted, the median is simply the middle one(if the total number is odd) or the average of two most middle numbers(if the total number is even). This is why we spend such a great deal of effort in the beginging to add index to the table.

1.First, we need to get the total number of record which can be obtained through select query.

```sh
num = dbGetQuery(con, "select count(*) from arrdelay_table;")
```

2.Then based on the judgement, we can have two different situations: odd and even.

```sh
if(num%%2 == 1) # total number is odd
{
  middle = num/2 + 0.5 # The index of the most middle number.
  
  index_middle = as.character(middle) # Convert integer to string.
  
  command = paste("select * from arrdelay_table limit", index_middle, ",1;", sep=" ") # Use paste() to combine several strings together to form a SQL query command: "select * from arrdelay_table limit index_middle, 1;". 
  # The meaning of this SQL query is to get the value of most middle record in the table.
  
  med_data = dbGetQuery(con, command) # Excute the SQL query through the connection.
  
  med = med_data[1,1] # Read median data.
}

if(num%%2 == 0) # total number is even
{
  middle = num/2 # The index of the most middle number.
  
  index_middle = as.character(middle) # Convert integer to string.
  
  command = paste("select * from arrdelay_table limit", index_middle, ",2;", sep=" ") # "select * from arrdelay_table limit index_middle, 2;" It select the most middle two records in the table.
  
  med_data = dbGetQuery(con, command) # Excute the SQL query.
  
  med = (med_data[1,1] + med_data[2,1]) / 2 # Compute median.
}
```
 - Record running time

```sh
# Record end point
ptm1 <- proc.time()

# Get the total running time.
time = ptm1 - ptm 
```
 - Write result into .rda file.

```sh
# Record end point
ptm1 <- proc.time()

# Get the total running time.
time = ptm1 - ptm 
```
## Result overview
 - Mean: 6.566504
 - Median: 0
 - Std: 31.556326
 - Running time: 3180.432 S

# Analysis and comparison of the results
------
## Comparison of statistics among three approaches

The three adopted methods all provide the same results, which is give below:
![Bilby Stampede](https://github.com/mentals/STA250/blob/master/HW1/value.png?raw=true)
 - Mean: 6.566504
 - Median: 0
 - Std: 31.556326

## Comparison of running time

Running time for three methods are different. If ranked from fastest to slowest, they will be: method1 > method2 > method3.
The following figure shows the running time for each method.

![Bilby Stampede](https://github.com/mentals/STA250/blob/master/HW1/Running_time.png?raw=true)

 - Method 1: 971 S
 - Method 2: 1002 S
 - Method 3: 3180 s

Why will this be true?

 - First let's compare method 1 with method 2.

These two methods are quite similar, both of them use shell and R script. But method 1 incorperates a frequency table, while method 2 merely has an unsorted column of data. For the shell script, i.e. the arrdelay data extraction part, method 1 takes a little bit longer than method2, 969s and 937s respectively, since the first method requires data sorting and counting. The rest is calculation of the statistics. Method 1 is much faster than method 2, 2s and 67s respectively. Because method 1 doesn't need to loop over the total number of records while method 2 needs to do the whole loop in order to calculate the statistics (about 2000 : 140000000). Since method 2 uses the built-in R function, the efficiency of calculation might be bigher than method 1, which is writen by myself. 

So with all these facts, method 2 is nearly 30 s slower than method 1.

 - Next, let's look at method 2 and method 3.

Method 3 uses a totally different way to get the statistics, through MySQL database. The data extraction part is exactly the same with method 2, so this is not the cause.

The data loading takes a huge amount of time, especially when we require the data to be in a sorted manner. In our case, loading data takes nearly 25 mins. 

Since the database is so large, each SQL query takes a considerable amount of time to excute, about 3 minutes to run based on different types of calculations. Since the structure of database is already qiute optimized, so the calculation speed is assume to be fast. But compared with method 2, the SQL query is not that fast. Method 2 uses about 60 s to get all the statistics while methods uses 12 mins to compute those values. This can be easily understood if we know how the database works.

Database stores data in the disk, while R stores data in memory. The access speed for these two kind of storages are quite different. Memory access has a much more fast speed than disk access， more than 10 times faster. This explains why MySQL approach takes much longer than R script.

However, method 2 does consume a great amount of memory since it needs to store all the arrdelay data into the memory. In my case the txt file that contains arrdelay data is more than 400 MB. If the memory consumption is too big, the calculation speed will be dragged down.

# Conclusions
 - Different approaches ahoule yield the same ststistics result as long as the algorithm is correct.


 - Different algorithms and tools have a great different running time. Some might be a lot faster than the others. Carefully designing your algorithm and a good choice of tools used can save you a lot effort in terms of running time.

 - When dealing with big data(like our assignment, total data is 24 GB after decompression), two things are of main concern: memory consumption and calculation time. A balance between these two attributes is our goal. Of course, an accurate result is more important. lol.

[website]: http://dev.mysql.com/downloads/mysql/
[instruction]: http://dev.mysql.com/doc/refman/5.5/en/installing.html
[CRAN]: http://cran.r-project.org/web/packages/RMySQL/index.html
[Click here]: http://stackoverflow.com/questions/2783313/how-can-i-get-around-mysql-errcode-13-with-select-into-outfile
    