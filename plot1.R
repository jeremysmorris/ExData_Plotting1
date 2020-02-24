# Store file name to be read
fileName <- "household_power_consumption.txt"

# Create a name for plot
plotName <- "plot1.png"

# Calculate memory requirements to load:
fileInfo <- file.info(fileName)
print(paste("File size =", fileInfo$size / 1e+9, "GB"), quote = FALSE)
print(paste("RAM needed to load =", fileInfo$size * 2 / 1e+9, "GB"), 
      quote = FALSE)

# Load the dataset
library(data.table)
data <- fread(fileName)

# Convert 'Date' to good format
library(lubridate)
data$Date <- dmy(data$Date)

# Select desired dates
library(tidyverse)
data <- filter(data, Date >= "2007-02-01" & Date <= "2007-02-02")

# Convert 'Time' to good format and all numeric variables to numeric (will also
# place all non-numerics with NA)
data$Time <- hms(data$Time)
data <- mutate_at(data, 3:9, as.numeric)

# Plot, print to png
png(filename = "plot1.png", width = 480, height = 480, units = "px")
with(data, hist(Global_active_power, col = "red",
                xlab = "Global Active Power (kilowatts)",
                main = "Global Active Power"))
dev.off()
