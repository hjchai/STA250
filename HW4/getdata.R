# This piece of code is used to download the traffic monitor data from PeMs website.
setwd("~/Desktop/STA250/HW4")
id = read.table("location.txt", sep = ",")
for (i in id){
  http_str = paste("http://pems.dot.ca.gov/?report_form=1&dnode=VDS&content=loops&tab=det_q&export=text&station_id=",
                   i,
                   "&s_time_id=1394668800&s_mm=3&s_dd=13&s_yy=2014&s_hh=0&e_time_id=1395190799&e_mm=3&e_dd=19&e_yy=2014",
                   "&e_hh=0&tod=all&tod_from=0&tod_to=0&dow_0=on&dow_1=on&dow_2=on&dow_3=on&dow_4=on&dow_5=on&dow_6=on&",
                   "holidays=on&agg=on&x=occ&y=flow", sep = "")
  cookie_str = paste("PHPSESSID=24bb992338099d7e57fad454dd9c7c2b; __utma=267661199.1969479367.1395262098.1395298505.1395302058.4",
                     "; __utmb=267661199.4.10.1395302058; __utmc=267661199; __utmz=267661199.1395298505.3.2.utmcsr=google|utmccn=(organic)|",
                     "utmcmd=organic|utmctr=(not%20provided)", sep ="")
  http_str_1 = paste("http://pems.dot.ca.gov/?report_form=1&dnode=VDS&content=loops&tab=det_timeseries&export=text&station_id=",
                     i,
                     "&s_time_id=1395100800&s_mm=3&s_dd=18&s_yy=2014&s_hh=0&e_time_id=1395190799&e_mm=3&e_dd=19&e_yy=2014",
                     "&e_hh=0&tod=all&tod_from=0&tod_to=0&dow_0=on&dow_1=on&dow_2=on&dow_3=on&dow_4=on&dow_5=on&dow_6=on",
                     "&holidays=on&q=flow&q2=speed&gn=5min&agg=on", sep = "")
  file_name = paste("data/",i,".txt", sep ="")
  cmd = paste("curl -L --cookie '", cookie_str, "' '", http_str, "' > ", file_name, sep = "")
  system(cmd, inter = TRUE)
  file_name_1 = paste("data/",i,"_speed.txt", sep ="")
  cmd_1 = paste("curl -L --cookie '", cookie_str, "' '", http_str_1, "' > ", file_name_1, sep = "")
  system(cmd_1, inter = TRUE)
}

