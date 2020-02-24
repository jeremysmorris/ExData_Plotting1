# Store file name to be read
fileName <- "household_power_consumption.txt"

# Create a name for plot
plotName <- "plot2.png"
        
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

# Convert all numeric variables to numeric 
# (will also place all non-numerics with NA)
data <- mutate_at(data, 3:9, as.numeric)

# Add weekday variable
data <- mutate(data, datetime = ymd_hms(paste(Date, Time)))

# Plot, print to png
png(filename = plotName, width = 480, height = 480, units = "px")
with(data, plot(x = datetime, y = Global_active_power, type = "l",
                xlab = "",
                ylab = "Global Active Power (kilowatts)"))
dev.off()
