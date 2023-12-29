#====================================================================
#1.Data Prepare

# Import packages
library(tidyverse)
library(dplyr)
library(hms)
library(DescTools)
library(ggplot2)
library(scales)

# Import cyclistic_trip_datas from 2022-12 to 2023-11
cyclistic_trip_data_202212 <- read_csv("./Documents/Case-Studies/Case-Study-1_-How-does-a-bike-shared-navigate-speedy-success/cyclistic_trip_data( 2022-12 ~ 2023-11 )/202212-divvy-tripdata.csv")
cyclistic_trip_data_202301 <- read_csv("./Documents/Case-Studies/Case-Study-1_-How-does-a-bike-shared-navigate-speedy-success/cyclistic_trip_data( 2022-12 ~ 2023-11 )/202301-divvy-tripdata.csv")
cyclistic_trip_data_202302 <- read_csv("./Documents/Case-Studies/Case-Study-1_-How-does-a-bike-shared-navigate-speedy-success/cyclistic_trip_data( 2022-12 ~ 2023-11 )/202302-divvy-tripdata.csv")
cyclistic_trip_data_202303 <- read_csv("./Documents/Case-Studies/Case-Study-1_-How-does-a-bike-shared-navigate-speedy-success/cyclistic_trip_data( 2022-12 ~ 2023-11 )/202303-divvy-tripdata.csv")
cyclistic_trip_data_202304 <- read_csv("./Documents/Case-Studies/Case-Study-1_-How-does-a-bike-shared-navigate-speedy-success/cyclistic_trip_data( 2022-12 ~ 2023-11 )/202304-divvy-tripdata.csv")
cyclistic_trip_data_202305 <- read_csv("./Documents/Case-Studies/Case-Study-1_-How-does-a-bike-shared-navigate-speedy-success/cyclistic_trip_data( 2022-12 ~ 2023-11 )/202305-divvy-tripdata.csv")
cyclistic_trip_data_202306 <- read_csv("./Documents/Case-Studies/Case-Study-1_-How-does-a-bike-shared-navigate-speedy-success/cyclistic_trip_data( 2022-12 ~ 2023-11 )/202306-divvy-tripdata.csv")
cyclistic_trip_data_202307 <- read_csv("./Documents/Case-Studies/Case-Study-1_-How-does-a-bike-shared-navigate-speedy-success/cyclistic_trip_data( 2022-12 ~ 2023-11 )/202307-divvy-tripdata.csv")
cyclistic_trip_data_202308 <- read_csv("./Documents/Case-Studies/Case-Study-1_-How-does-a-bike-shared-navigate-speedy-success/cyclistic_trip_data( 2022-12 ~ 2023-11 )/202308-divvy-tripdata.csv")
cyclistic_trip_data_202309 <- read_csv("./Documents/Case-Studies/Case-Study-1_-How-does-a-bike-shared-navigate-speedy-success/cyclistic_trip_data( 2022-12 ~ 2023-11 )/202309-divvy-tripdata.csv")
cyclistic_trip_data_202310 <- read_csv("./Documents/Case-Studies/Case-Study-1_-How-does-a-bike-shared-navigate-speedy-success/cyclistic_trip_data( 2022-12 ~ 2023-11 )/202310-divvy-tripdata.csv")
cyclistic_trip_data_202311 <- read_csv("./Documents/Case-Studies/Case-Study-1_-How-does-a-bike-shared-navigate-speedy-success/cyclistic_trip_data( 2022-12 ~ 2023-11 )/202311-divvy-tripdata.csv")

# Combine all data into one data frame
cyclistic_trip_datas <- rbind(cyclistic_trip_data_202212, cyclistic_trip_data_202301, cyclistic_trip_data_202302, cyclistic_trip_data_202303, cyclistic_trip_data_202304, cyclistic_trip_data_202305, cyclistic_trip_data_202306, cyclistic_trip_data_202307, cyclistic_trip_data_202308, cyclistic_trip_data_202309, cyclistic_trip_data_202310, cyclistic_trip_data_202311)

#====================================================================
#2. Preprocess

# Remove incomplete data
cleaned_cyclistic_trip_datas <- na.omit(cyclistic_trip_datas)

# Create columns for ride length, day of the week, month, and quarter, and hour of day
preprocessed_cyclistic_trip_datas <- cleaned_cyclistic_trip_datas %>%
  mutate(
    ride_length = as_hms(ended_at - started_at),  # Calculate ride length
    day_of_week = format(started_at, "%A"),       # Extract day of the week
    month = format(started_at, "%Y%m"),           # Extract month in YYYYMM format
    quarter = quarters(started_at),               # Extract quarter
    hour_of_day = hour(started_at)                # Extract hour of day
  )

# Change the sorting of day_of_week column
preprocessed_cyclistic_trip_datas$day_of_week <- factor(preprocessed_cyclistic_trip_datas$day_of_week, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

#====================================================================
#3. Analyze

summary <- preprocessed_cyclistic_trip_datas %>%
  group_by(member_casual) %>%
  summarise(ride_length_AVG = as_hms(mean(ride_length)), ride_length_MAX = as_hms(max(ride_length)), day_of_week_MODE = Mode(day_of_week), month_MODE = Mode(month), quarter_MODE = Mode(quarter), count = n())



month_summary <- preprocessed_cyclistic_trip_datas %>%
  group_by(member_casual, month) %>%
  summarise(ride_length_AVG = as_hms(mean(ride_length)), ride_length_MAX = as_hms(max(ride_length)), day_of_week_MODE = Mode(day_of_week), count = n())

#====================================================================
#3. Visualize


# Distribution of Month Trips by Member Type
ggplot(data = preprocessed_cyclistic_trip_datas) +
  geom_bar(mapping = aes(x = month, fill = member_casual), color = "black") +
  geom_line(mapping = aes(x = month, y = ..count.., group = 1), stat = 'count', size = 1, color = "red") +
  geom_text(stat = "count", aes(x = month, y = ..count.., label = paste0(after_stat(x), "\n", ..count..)), vjust = 0.5, size = 3, color = "black") +
  scale_y_continuous(labels = scales::comma_format()) +
  facet_wrap(~member_casual) +
  scale_fill_brewer(palette = "Set2") +
  labs(title = "Distribution of Month Trips by Member Type", x = "Month", y = "Total Trips")


# Distribution of Quarterly Trips by Member Type
ggplot(data = preprocessed_cyclistic_trip_datas) +
  geom_bar(mapping = aes(x = quarter, fill = member_casual), color = "black") +
  geom_text(stat = "count", aes(x = quarter, y = ..count.., label = ..count..), vjust = -0.5, size = 3, color = "black") +
  scale_y_continuous(labels = scales::comma_format()) +
  facet_wrap(~member_casual) +
  labs(title = "Distribution of Quarterly Trips by Member Type", x = "Quarter", y = "Total Trips")


# Distribution of the Day_of_week
ggplot(data = preprocessed_cyclistic_trip_datas) +
  geom_line(mapping = aes(x = day_of_week, y = ..count.., group = 1), stat = 'count') +
  geom_point(mapping = aes(x = day_of_week, y = ..count.., group = 1), stat = 'count', size = 3) +
  geom_text(stat = "count", aes(x = day_of_week, y = ..count.., label = ..count..), vjust = -1, size = 3, color = "black") +
  scale_y_continuous(labels = scales::comma_format()) +
  facet_wrap(~member_casual) +
  labs(title = "Distribution of 'the day of week' ", x = "Day of week", y = "Total Trips")


# Distribution of the hour_of_day
ggplot(data = preprocessed_cyclistic_trip_datas) +
  geom_bar(mapping = aes(x = hour_of_day, fill = member_casual), color = "black") +
  geom_text(stat = "count", aes(x = hour_of_day, y = ..count.., label = paste0(after_stat(x),":00") ), vjust = -0.5, size = 3, color = "black") +
  scale_y_continuous(labels = scales::comma_format()) +
  scale_x_continuous(breaks = seq(0, 23, 4), labels = sprintf("%02d:00", seq(0, 23, 4))) +
  geom_vline(xintercept = 12, linetype = "dashed", size = 1) +
  facet_grid(~member_casual) +
  labs(title = "Distribution of 'Hour of day' ", x = "Hour of day", y = "Total Trips")


# Average Ride Length
ride_length_summary <- preprocessed_cyclistic_trip_datas %>%
  group_by(member_casual) %>%
  summarise(ride_length_average = as.numeric(mean(ride_length) / 60),
            ride_length_max = as.numeric(max(ride_length) / 60))

ggplot(ride_length_summary, aes(x = member_casual, y = ride_length_average, fill = member_casual)) +
  geom_col(color = "black") +
  geom_text(aes(label = sprintf("%.2f", ride_length_average)),
            position = position_dodge(width = 0.9),
            vjust = -0.5, size = 3, color = "black") +
  scale_y_continuous(labels = label_number(suffix = "minutes")) +
  labs(title = "Average Ride Length by Member Type", x = "Member Type", y = "Average Ride Length (minutes)")
