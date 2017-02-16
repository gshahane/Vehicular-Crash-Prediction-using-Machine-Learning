library(sqldf)
library(plyr)
library(zoo)
library(reshape2)
library(data.table)
require(functional)

#read file
d= read.csv("/Users/MohanaBansal/Documents/MOHANA/UMCP MIM/FALL 2016/From Data to Insights/Project/Data/Weather/mohana_allYearData.csv",header= TRUE, stringsAsFactors = FALSE)

# replace "error" and "other" by blanks
d$tfs0_text  <-gsub("Error", "", d$tfs0_text)
d$tfs0_text<-gsub("Other", "", d$tfs0_text)
d$tfs0_text<-gsub("-99", "", d$tfs0_text)
d$tfs0_text<-gsub("No Report", "", d$tfs0_text)

d$tfs1_text  <-gsub("Error", "", d$tfs1_text)
d$tfs1_text<-gsub("Other", "", d$tfs1_text)
d$tfs1_text<-gsub("-99", "", d$tfs1_text)

d$tfs2_text  <-gsub("Error", "", d$tfs2_text)
d$tfs2_text<-gsub("Other", "", d$tfs2_text)
d$tfs2_text<-gsub("-99", "", d$tfs2_text)

d$tfs3_text  <-gsub("Error", "", d$tfs3_text)
d$tfs3_text<-gsub("Other", "", d$tfs3_text)
d$tfs3_text<-gsub("-99", "", d$tfs3_text)

#remove rows with all blank records

d <-d[!(d$tfs0_text=="" & d$tfs1_text=="" & d$tfs2_text=="" & d$tfs3_text==""),]

#reassign values to weather conditions
d$tfs0_reassigned <- as.numeric(revalue(d$tfs0_text,
                                              c("Dry"=1 , "Trace Moisture"=2,"Damp" = 3, "Wet"=4,"Ice Warning"=5,  "Ice Watch"=6, "Snow/Ice Warning"= 5, "Snow/Ice Watch"= 6, "Snow Warning"=7 , "Snow Watch"= 8, "Frost"=9, "Chemically Wet"=10)))


#reassign values to weather conditions
d$tfs1_reassigned <- as.numeric(revalue(d$tfs1_text,
                                              c("Dry"=1 , "Trace Moisture"=2,"Damp" = 3, "Wet"=4,"Ice Warning"=5,  "Ice Watch"=6, "Snow/Ice Warning"= 5, "Snow/Ice Watch"= 6, "Snow Warning"=7 , "Snow Watch"= 8, "Frost"=9, "Chemically Wet"=10)))

#reassign values to weather conditions
d$tfs2_reassigned <- as.numeric(revalue(d$tfs2_text,
                                              c("Dry"=1 , "Trace Moisture"=2,"Damp" = 3, "Wet"=4,"Ice Warning"=5,  "Ice Watch"=6, "Snow/Ice Warning"= 5, "Snow/Ice Watch"= 6, "Snow Warning"=7 , "Snow Watch"= 8, "Frost"=9, "Chemically Wet"=10)))

#reassign values to weather conditions
d$tfs3_reassigned <- as.numeric(revalue(d$tfs3_text,
                                              c("Dry"=1 , "Trace Moisture"=2,"Damp" = 3, "Wet"=4,"Ice Warning"=5,  "Ice Watch"=6, "Snow/Ice Warning"= 5, "Snow/Ice Watch"= 6, "Snow Warning"=7 , "Snow Watch"= 8, "Frost"=9, "Chemically Wet"=10)))

str(d)

d$tf_max <- 1

## getting selected rows
#d_sub = data.frame(d$tfs0_reassigned, d$tfs1_reassigned, d$tfs2_reassigned, d$tfs3_reassigned, d$tf_max)
d_sub = data.frame(d$tfs0_reassigned, d$tfs1_reassigned, d$tfs2_reassigned, d$tfs3_reassigned)

d$tf_max <-  apply(d_sub, 1, function(d_sub) { tab <- table(d_sub); names(tab)[which.max(tab)] } ) #return the value with max freq

d$tf_max <- as.numeric(as.character(d$tf_max))

write.csv(d, '/Users/MohanaBansal/Documents/MOHANA/UMCP MIM/FALL 2016/From Data to Insights/Project/Data/Weather/mohana_allYearDataFinalRecoded.csv')


