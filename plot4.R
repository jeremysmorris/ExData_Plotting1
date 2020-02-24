# Store file name to be read
fileName <- "household_power_consumption.txt"

# Create a name for plot
plotName <- "plot4.png"
        
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

# Set up 2 x 2 plot frame
par(mfrow = c(2,2))

# Plot 1
with(data, plot(x = datetime, y = Global_active_power, type = "l",
                xlab = "",
                ylab = "Global Active Power"))

# Plot 2
with(data, plot(x = datetime, y = Voltage, type = "l",
                xlab = "datetime",
                ylab = "Voltage"))

# Plot 3
with(data, plot(x = datetime, y = Sub_metering_1, type = "n",
                ylim = c(0, max(data[ ,7:9])),
                xlab = "",
                ylab = "Energy sub metering"))
with(data, {
  points(x = datetime, y = Sub_metering_1, type = "l", col = "black")
  points(x = datetime, y = Sub_metering_2, type = "l", col = "red")
  points(x = datetime, y = Sub_metering_3, type = "l", col = "blue")
})
legend("topright", lty = 1, col = c("black", "blue", "red"),
       bty = "n", cex = 0.9,
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Plot 4
with(data, plot(x = datetime, y = Global_reactive_power, type = "l",
                xlab = "datetime",
                ylab = "Global_reactive_power"))
dev.off()
