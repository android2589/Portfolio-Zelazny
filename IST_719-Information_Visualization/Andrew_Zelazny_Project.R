# Andrew Zelazny
# IST 722 Project

##### 
# Project Scratch Pad
library(ggplot2)
library(lubridate)
library(zoo)
library(tidyverse)

proj_folder = "Z:\\Documents\\SYR-Data_Science\\Courses\\08-IST-719\\Project\\"

full_data = read.csv(paste0(proj_folder, "GlobalLandTemperaturesByState.csv")
                     , header=TRUE
                     , stringsAsFactors=FALSE
                     )
full_data$Year = as.numeric(format(strptime(full_data$dt, "%Y-%m-%d"), "%Y"))
full_data$month = format(strptime(full_data$dt, "%Y-%m-%d"), "%b")
months = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
full_data$month = factor(full_data$month, levels=months)

plot_data = full_data[which(full_data$year > 1855),]

agg_list = list(plot_data$Country, plot_data$year)
full.avg = aggregate(plot_data$AverageTemperature, by=agg_list, FUN=mean)
full.max = aggregate(plot_data$AverageTemperature, by=agg_list, FUN=max)
full.min = aggregate(plot_data$AverageTemperature, by=agg_list, FUN=min)
colnames(full.avg) = c("Country", "Year", "AnnualMeanTemperature")
colnames(full.min) = c("Country", "Year", "AnnualMinTemperature")
colnames(full.max) = c("Country", "Year", "AnnualMaxTemperature")



norm_FUN = function(input_array) {
  norm_array = input_array - mean(input_array, na.rm=TRUE)
  return(norm_array)
}

full.avg$DeltaAnnualMeanTemperature = ave(full.avg$AnnualMeanTemperature, full.avg$Country, FUN=norm_FUN)

#####
# Plot 1
#ggplot(full.avg) + aes(x=Year, y=AnnualMeanTemperature, col=Country) + geom_point() + geom_smooth() +
#  labs(y="Annual Mean Temperature [C]", title="Annual Mean Temperature by Country") +
#  scale_color_brewer(palette="Dark2")+
#  scale_fill_brewer(palette="Dark2") +
#  theme(plot.title = element_text(size=22)
#        , legend.title=element_text(size=17)
#        , legend.text=element_text(size=12)
#        , axis.title.x=element_text(size=17)
#        , axis.title.y=element_text(size=17)
#        , axis.text.x=element_text(face="bold", color="black", size=12)
#        , axis.text.y=element_text(face="bold", color="black", size=12)
#        #, plot.background=element_rect(fill="#48637F")
#        )

ggplot(full.avg) + aes(x=Country, y=AnnualMeanTemperature, fill=Country) + geom_violin() +
  labs(y="Annual Mean Temperature [C]", title="Annual Mean Temperature by Country") +
  scale_color_brewer(palette="Dark2")+
  scale_fill_brewer(palette="Dark2") +
  theme(plot.title = element_text(size=22)
        , legend.title=element_text(size=17)
        , legend.text=element_text(size=12)
        , axis.title.x=element_text(size=17)
        , axis.title.y=element_text(size=17)
        , axis.text.x=element_text(face="bold", color="black", size=12)
        , axis.text.y=element_text(face="bold", color="black", size=12)
        #, plot.background=element_rect(fill="#48637F")
  )

#####
# BIG PLOT
library(rworldmap)
library(RColorBrewer)
library(plotrix)

agg_fun = function(input_array) {
  input_array = input_array[!is.na(input_array)]
  output_array = mean(tail(input_array, 10)) - mean(head(input_array), 10)
  return(output_array)
}

agg.df = aggregate(full.avg$AnnualMeanTemperature, by=list(c(full.avg$Country)), FUN=agg_fun)
#agg.df = aggregate(full.avg$AnnualMeanTemperature, by=list(c(full.avg$Country)), FUN=mean, na.rm=T)
colnames(agg.df) = c("Country", "AverageTemp")
            
iso3.codes = tapply(agg.df$Country, 1:length(agg.df$Country), rwmGetISO3)
tmp.df = data.frame(Country=iso3.codes, labels=agg.df$Country, AverageTemp=agg.df$AverageTemp)
df.map = joinCountryData2Map(tmp.df, joinCode = "ISO3", nameJoinColumn = "Country")
      

reds = brewer.pal(10, "Reds")
my.cols = c(reds[4], reds[9])
my.colors = colorRampPalette(my.cols)

par(mar = c(0, 0, 1, 0))
mapCountryData(df.map
               , nameColumnToPlot = "AverageTemp"
               , numCats = num.cat
               , catMethod = c("pretty", "fixedwidth", "diverging", "quantiles")[1]
               , colourPalette = my.colors(13)
               #, colourPalette="heat"
               , oceanCol = "#48637f"
               , borderCol="gray"
               , mapTitle = ""
               , lwd=2
)




#####
# Plot 2
ggplot(full.avg) + aes(x=Year, y=DeltaAnnualMeanTemperature, col=Country) + geom_point() + geom_smooth(lwd=2) +
  scale_color_brewer(palette="Dark2")+
  scale_fill_brewer(palette="Dark2") +
  labs(y="Delta from Annual Mean Temperature [C]", title="Delta From Annual Mean Temperature by Country") +
  theme(plot.title = element_text(size=22)
        , legend.title=element_text(size=17)
        , legend.text=element_text(size=12)
        , axis.title.x=element_text(size=17)
        , axis.title.y=element_text(size=17)
        , axis.text.x=element_text(face="bold", color="black", size=12)
        , axis.text.y=element_text(face="bold", color="black", size=12)
        #, plot.background=element_rect(fill="#48637F")
        )


#####
# Plot 3
my_data = plot_data[which(plot_data$Country == "Brazil"), ]

my.avg = aggregate(my_data$AverageTemperature, by=list(my_data$month, my_data$year), FUN=mean)
colnames(my.avg) = c("Month", "Year", "AverageTemperature")

my.avg$date = paste(my.avg$Month, "-", "01-", my.avg$Year, sep="")
my.avg$date = date(strptime(my.avg$date, format="%b-%d-%Y"))
my.avg$Month = toupper(my.avg$Month)

# ESRL data, EL Nino and La Nina years
df.ESRL = read_xlsx(paste0(proj_folder, "ESRL_data2.xlsx"))
rownames(df.ESRL) = df.ESRL$Year

my.avg$score = apply(my.avg[, 1:2], 1, function(x) as.numeric(as.character(unlist(df.ESRL[x['Year'], x['Month'] ]))))

my.avg = my.avg[(my.avg$Year >= 1871) & (my.avg$Year <= 2005), ]

score_fun = function (input) {
  value = "Normal"
  if (input <= -0.5) {value = "La Nina"}
  if (input >  0.5) {value = "El Nino"}
  if (is.na(input)) {value= "NA"}
  return(value)
}

my.avg$cat = apply(my.avg[, c("score"), drop=F], 1, score_fun)

my.avg$DeltaAverageTemperature = my.avg$AverageTemperature - mean(my.avg$AverageTemperature, na.rm=T)

my.avg.agg = aggregate(my.avg$DeltaAverageTemperature, by=list(my.avg$cat), FUN=mean, na.rm=T)
colnames(my.avg.agg) = c("Category", "DeltaAverageTemperature")

ggplot(my.avg.agg) + aes(x=Category, y=DeltaAverageTemperature, fill=Category) + geom_bar(stat="identity") +
  scale_color_brewer(palette="Dark2")+
  scale_fill_brewer(palette="Dark2") +
  labs(y="Average Temperature [C]", x="", title="Delta from Average Temperature: Brazil") +
  theme(plot.title = element_text(size=22)
        , legend.title=element_text(size=17)
        , legend.text=element_text(size=12)
        , axis.title.x=element_text(size=17)
        , axis.title.y=element_text(size=17)
        , axis.text.x=element_text(face="bold", color="black", size=12)
        , axis.text.y=element_text(face="bold", color="black", size=12)
  )


#ggplot(my.avg) + aes(x=date, y=AverageTemperature) + geom_point() + geom_line() + geom_smooth(lwd=2) +
#  scale_color_brewer(palette="Dark2")+
#  scale_fill_brewer(palette="Dark2") +  
#  labs(y="Average Temperature [C]", title="Average Temperature: Brazil") +
#  theme(plot.title = element_text(size=22)
#        , legend.title=element_text(size=17)
#        , legend.text=element_text(size=12)
#        , axis.title.x=element_text(size=17)
#        , axis.title.y=element_text(size=17)
#        , axis.text.x=element_text(face="bold", color="black", size=12)
#        , axis.text.y=element_text(face="bold", color="black", size=12)
#  )

#ggplot(my.avg) + aes(x=date, y=AverageTemperature, col=cat) + geom_point() + geom_smooth(se=F, lwd=2) +
#  labs(y="Average Temperature [C]", title="Average Temperature: Brazil") +
#  theme(plot.title = element_text(size=22)
#        , legend.title=element_text(size=17)
#        , legend.text=element_text(size=12)
#        , axis.title.x=element_text(size=17)
#        , axis.title.y=element_text(size=17)
#        , axis.text.x=element_text(face="bold", color="black", size=12)
#        , axis.text.y=element_text(face="bold", color="black", size=12)
#  )


my.avg.agg.2 = aggregate(my.avg$DeltaAverageTemperature, by=list(my.avg$Year, my.avg$cat), FUN=mean, na.rm=T)
colnames(my.avg.agg.2) = c("Year", "Category", "DeltaAverageTemperature")

ggplot(my.avg.agg.2) + aes(x=Year, y=DeltaAverageTemperature, col=Category) + geom_point() + geom_smooth(se=F, lwd=2) +
  labs(y="Delta From Mean Temperature [C]", title="Delta from Mean Temperature: Brazil") +
  scale_color_brewer(palette="Dark2")+
  scale_fill_brewer(palette="Dark2") +
  theme(plot.title = element_text(size=22)
        , legend.title=element_text(size=17)
        , legend.text=element_text(size=12)
        , axis.title.x=element_text(size=17)
        , axis.title.y=element_text(size=17)
        , axis.text.x=element_text(face="bold", color="black", size=12)
        , axis.text.y=element_text(face="bold", color="black", size=12)
        #, plot.background=element_rect(fill="#48637F")
  )


ggplot(my.avg.agg.2) + aes(x=Year, y=DeltaAverageTemperature) + geom_point() + geom_line() +
  labs(y="Average Temperature [C]", title="Average Temperature: Brazil") +
  scale_color_brewer(palette="Dark2")+
  scale_fill_brewer(palette="Dark2") +
  theme(plot.title = element_text(size=22)
        , legend.title=element_text(size=17)
        , legend.text=element_text(size=12)
        , axis.title.x=element_text(size=17)
        , axis.title.y=element_text(size=17)
        , axis.text.x=element_text(face="bold", color="black", size=12)
        , axis.text.y=element_text(face="bold", color="black", size=12)
  )

#####

# OBSOLETE

#####
# Plot 3a
my_data = plot_data[which(plot_data$Country == "Australia"), ]

my.avg = aggregate(my_data$AverageTemperature, by=list(my_data$month, my_data$year), FUN=mean)
colnames(my.avg) = c("Month", "Year", "AverageTemperature")

my.avg$date = paste(my.avg$Month, "-", "01-", my.avg$Year, sep="")
my.avg$date = date(strptime(my.avg$date, format="%b-%d-%Y"))
my.avg$Month = toupper(my.avg$Month)

df.ESRL = read_xlsx(paste0(proj_folder, "ESRL_data2.xlsx"))
rownames(df.ESRL) = df.ESRL$Year

my.avg$score = apply(my.avg[, 1:2], 1, function(x) as.numeric(as.character(unlist(df.ESRL[x['Year'], x['Month'] ]))))

my.avg = my.avg[(my.avg$Year >= 1871) & (my.avg$Year <= 2005), ]

score_fun = function (input) {
  value = "Normal"
  if (input <= -0.5) {value = "La Nina"}
  if (input >  0.5) {value = "El Nino"}
  if (is.na(input)) {value= "NA"}
  return(value)
}

my.avg$cat = apply(my.avg[, c("score"), drop=F], 1, score_fun)

my.avg$DeltaAverageTemperature = my.avg$AverageTemperature - mean(my.avg$AverageTemperature, na.rm=T)

my.avg.agg = aggregate(my.avg$DeltaAverageTemperature, by=list(my.avg$cat), FUN=mean, na.rm=T)
colnames(my.avg.agg) = c("Category", "DeltaAverageTemperature")

ggplot(my.avg.agg) + aes(x=Category, y=DeltaAverageTemperature, fill=Category) + geom_bar(stat="identity") +
  theme(plot.title = element_text(size=22)
        , legend.title=element_text(size=17)
        , legend.text=element_text(size=12)
        , axis.title.x=element_text(size=17)
        , axis.title.y=element_text(size=17)
        , axis.text.x=element_text(face="bold", color="black", size=12)
        , axis.text.y=element_text(face="bold", color="black", size=12)
  )


my.avg.agg.2 = aggregate(my.avg$DeltaAverageTemperature, by=list(my.avg$Year, my.avg$cat), FUN=mean, na.rm=T)
colnames(my.avg.agg.2) = c("Year", "Category", "DeltaAverageTemperature")

ggplot(my.avg.agg.2) + aes(x=Year, y=DeltaAverageTemperature, col=Category) + geom_point() + geom_smooth(se=F) +
  labs(y="Delta From Mean Temperature [C]", title="Delta from Mean Temperature: Australia") +
  theme(plot.title = element_text(size=22)
        , legend.title=element_text(size=17)
        , legend.text=element_text(size=12)
        , axis.title.x=element_text(size=17)
        , axis.title.y=element_text(size=17)
        , axis.text.x=element_text(face="bold", color="black", size=12)
        , axis.text.y=element_text(face="bold", color="black", size=12)
        #, plot.background=element_rect(fill="#48637F")
  )

